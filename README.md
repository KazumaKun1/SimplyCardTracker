# SimplyCardTracker

Offline Flutter app for keeping track of debit, stored-value, and credit cards. Local-first, with manual Google Drive backup and restore.

## Snapshots, not transactions

This is **not** an expense tracker. You never log purchases. Open the app occasionally, for example after getting a credit card bill or checking your bank app, and tell it what is currently true. There are no daily habits, streaks, or reminders to log.

## Status

Early development.

- [x] Router, theme, and tab shell
- [ ] Domain entities
- [ ] Riverpod state
- [ ] drift (SQLite) persistence
- [ ] Google Drive backup and restore

## Planned features

**Credit cards**
- Name, last four digits, credit limit, available limit, annual fee
- One current bill per card: amount due, due date, paid or unpaid
- Dashboard: total credit limit, total available limit, number of cards, cards with no annual fee

**Debit and stored-value cards** (bank debit, train reload cards, amusement park cards)
- Optional last four digits
- Tap the balance to edit it
- Dashboard: total money per currency, number of cards

Totals are always per currency. PHP and USD are never summed together.

## Tech stack

- Flutter and Dart
- Riverpod for state management
- go_router for navigation
- drift (SQLite) for local persistence
- Google Drive (hidden `appdata` scope) for manual backup and restore

The architecture is layered MVVM with repositories, organized feature-first under `lib/features/`, with shared code in `lib/core/` and `lib/data/`.

## Getting started

Requires the Flutter SDK (Dart `^3.13.5`) and Xcode for iOS.

```bash
flutter pub get
flutter run
```

```bash
flutter test
flutter analyze
```

## Platform notes

Portrait only, iPhone only. On large screens the content is centered in a 500 px wide column.

## Privacy

All data stays on the device. Only the last four digits of a card are ever stored, never the full number. Backups go to a hidden app-data folder in your own Google Drive.

## License

[MIT](LICENSE)
