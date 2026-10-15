# SimplyCardTracker

Offline Flutter app for keeping track of debit, stored-value, and credit cards. Local-first, with manual Google Drive backup and restore.

## Product principle: snapshots, not transactions
This is **not** an expense tracker. The user never logs purchases. They open the app occasionally (for example after getting a credit card bill, or after checking their bank app) and tell it what is currently true. Every feature should keep that low-friction, no-daily-habit, no-guilt spirit (the user is AuDHD). Do not add transaction logging, monthly in/out totals, streaks, reminders to log, or anything that implies a habit.

### Credit cards
- Card facts and bill cycle: name, credit limit, available limit, due date, annual fee (yes/no), promo/perk notes, bill paid/unpaid.
- Dashboard goals: total credit limit, total available limit, number of cards, number with no annual fee.
- "Available limit" is a snapshot the user types from their bank app, not calculated.

### Debit and stored-value cards (bank debit, train reload cards, amusement park cards)
- One card type for all of these, with a label/icon to tell them apart.
- The user taps the balance, edits it, confirms. This saves a history entry such as "4,000 -> 5,000 (+1,000)".
- History entries can be edited or deleted.
- Dashboard goal: total current money across all these cards.

### Data model decisions
- A history entry stores only the **new amount and a timestamp** (plus an optional note). The change (+1,000) is derived from the previous entry when displayed, so editing or deleting an entry can never leave the numbers inconsistent.
- A card's current balance = its latest history entry.
- Totals are **per currency**. Never sum PHP and USD together.
- Open question: deleting the latest entry should probably revert the balance to the previous one. Confirm with the user before building.

## Working rules
- **Ask before modifying anything.** Never create, edit, or delete files, or run installs, builds, or codegen, without my explicit OK first. Reading and analysis are fine.
- The Claude Design prototype is a **reference only**, not a spec. My design differs slightly, and the prototype includes transaction-style UI (monthly in/out tiles, a "Money in and out" list) that does **not** belong in this app.
  - Prototype: https://claude.ai/artifact/XYQq2efZFB51f8gkCc9iq6
  - Main layout is **A** (side-swipe carousel with the card raised). **B** (wallet stack) is the "all cards" list view.
- Act as a senior Flutter engineer mentoring me. I'm a 7-year native iOS developer (SwiftUI, MVVM/MVVM-C) learning Dart and Flutter. Explain with SwiftUI analogies, give the why and the trade-offs, and recommend rather than list every option.

## Architecture decisions
- Layered MVVM with repositories. Feature-first folders under `lib/features/`, shared code in `lib/core/` and `lib/data/`.
- State management: **Riverpod** (Notifier/AsyncNotifier act as ViewModels). Immutable state classes.
- Navigation: `go_router`. No coordinators.
- Persistence: **drift** (SQLite). No domain layer or use cases until a screen needs one.
- Keep it small. Don't add Clean Architecture ceremony or abstractions for hypothetical needs.

## Data rules
- Money is stored as **integer centavos**, never `double`. Each card has a currency code (PHP and USD).
- Never store full card numbers. Last four digits only.

## Backup and restore (Google Drive)
- Uses the hidden `drive.appdata` scope.
- Back up a clean copy of the SQLite file (flush the write-ahead log or use `VACUUM INTO`).
- Restore replaces all existing data: download to a temp file, run `PRAGMA integrity_check`, check the schema version, close the DB, keep the old file as a fallback, swap, reopen. Roll back on any failure.

## Design tokens
- iOS-flavored. Light theme is cream `#faf6f0` with white cards. Dark theme is black with warm gray cards.
- Accent blue `#0065be` (light) / `#0091ff` (dark).
- Spacing scale 4/8/12/16/24/32. Card radius 18, control radius 12. Minimum tap target 44px.

## Commands
- Run: `flutter run`
- Test: `flutter test`
- Analyze: `flutter analyze`
- Codegen (once `build_runner` is added): `dart run build_runner build --delete-conflicting-outputs`

## Distribution constraints
- No iPhone available. Test on the simulator and keep the app crash-free and complete for App Review (guideline 2.1).
- Google Play needs 12 testers for 14 consecutive days before production access.
