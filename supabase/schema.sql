-- Earnings Daybook: sync tables. Paste into the Supabase SQL editor of the Kana Kanji SRS project and run it.
-- Safe to re-run. Doesn't touch any other tables.

-- One row per logged day per account
create table if not exists public.daybook_days (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  day date not null,
  amounts jsonb not null default '{}'::jsonb,   -- {sourceId: amount}
  note text,
  edited_at timestamptz not null,               -- when it was saved on the device; the newest save wins
  synced_at timestamptz not null default now(), -- set by the server; devices pull rows newer than their last pull
  primary key (user_id, day)
);
create index if not exists daybook_days_synced on public.daybook_days (user_id, synced_at);

-- One row per account: sources, currency, goals and goal reminders
create table if not exists public.daybook_meta (
  user_id uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  data jsonb not null,
  synced_at timestamptz not null default now()
);

-- Keep the newer save when two devices edit the same day, and stamp every write with the server time
create or replace function public.daybook_days_keep_newest() returns trigger
language plpgsql set search_path = '' as $$
begin
  if tg_op = 'UPDATE' and new.edited_at < old.edited_at then
    return old;
  end if;
  new.synced_at := now();
  return new;
end $$;
drop trigger if exists daybook_days_keep_newest on public.daybook_days;
create trigger daybook_days_keep_newest before insert or update on public.daybook_days
  for each row execute function public.daybook_days_keep_newest();

create or replace function public.daybook_meta_stamp() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.synced_at := now();
  return new;
end $$;
drop trigger if exists daybook_meta_stamp on public.daybook_meta;
create trigger daybook_meta_stamp before insert or update on public.daybook_meta
  for each row execute function public.daybook_meta_stamp();

-- Every signed-in account can only see and change its own rows
alter table public.daybook_days enable row level security;
alter table public.daybook_meta enable row level security;

drop policy if exists "own daybook days" on public.daybook_days;
create policy "own daybook days" on public.daybook_days for all to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists "own daybook meta" on public.daybook_meta;
create policy "own daybook meta" on public.daybook_meta for all to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.daybook_days to authenticated;
grant select, insert, update, delete on public.daybook_meta to authenticated;
