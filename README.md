# Earnings Daybook

A daily income log that runs in Safari on an iPhone. Each day, enter what each source earned (Amazon ebooks, Audible, Shopify, TikTok Shop, YouTube, Meta, or your own), then see weekly, monthly and yearly charts and a forecast for next month and the next 12 months.

Entries are saved on the phone only, so export a backup now and then.

## Hosting

It's served by GitHub Pages from the `main` branch, root folder, at `https://danielsan163.github.io/earnings-daybook/`. The code is public, but income entries never leave the phone.

## Add it to the iPhone

1. Open that address in **Safari** (not a Private tab).
2. Tap **Share → Add to Home Screen**.
3. Always open it from the Home Screen icon. That copy keeps its storage most reliably, and it works with no signal once it's been opened once.

## Daily use

- **Today**: one box per source. Enter moves to the next box; Enter on the last box saves. Empty boxes count as 0. Use the arrows or date picker to fill in or fix past days; unlogged days from the last two weeks show as buttons.
- **Charts**: week, month or year, split by source or as a total, with a breakdown table.
- **Forecast**: pick how much history to use (7 days to 1 year) and either a steady average or the recent trend.
- **Sources**: add, rename, reorder or archive sources (archived ones keep their history), change currency, export a CSV.

## Backups

On the Sources tab, under **Your data**:
- **Export backup** opens the share sheet. Choose **Save to Files** and put it in iCloud Drive.
- **Import backup** reads a backup file and merges it in. Use it on a new phone or after clearing Safari.

The app nudges you once 14 days have passed since the last backup.

## Updating the app

After changing `index.html`, bump `VERSION` in `sw.js` (for example `daybook-v2`) and push. Phones pick up the new copy the next time they open it with a signal.
