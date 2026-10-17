# SimplyCardTracker

Offline Flutter app for keeping track of debit, stored-value, and credit cards. Local-first, with manual Google Drive backup and restore.

## Product principle: snapshots, not transactions
This is **not** an expense tracker. The user never logs purchases. They open the app occasionally (for example after getting a credit card bill, or after checking their bank app) and tell it what is currently true. Every feature should keep that low-friction, no-daily-habit, no-guilt spirit (the user is AuDHD). Do not add transaction logging, monthly in/out totals, "changed this month" deltas, streaks, reminders to log, or anything that implies a habit.

### Credit cards
- Card facts: name, last four digits, credit limit, available limit, annual fee (yes/no).
- Credit limit and available limit are both typed by the user (a snapshot from the bank app). Neither is calculated from bills. Bills don't include recent swipes, and installment conversions keep occupying the limit, so a calculation would disagree with the bank app.
- Each card has at most one **current bill**: amount due, due date, paid/unpaid. When the next statement arrives, the user overwrites it. The card shows its current unpaid bill.
- No past-bills history and no "All Bills" screen. Deliberately dropped as noise. A possible later idea: "total paid since the card was created", only if the user asks for it.
- No promo/perk notes field.
- Dashboard goals: total credit limit, total available limit, number of cards, number with no annual fee.

### Debit and stored-value cards (bank debit, train reload cards, amusement park cards)
- One card type for all of these, with a label/icon to tell them apart (not built yet).
- The user taps the balance, edits it, confirms. The balance is a plain field on the card.
- **No history.** History entries and the "Fix an update" screen were dropped entirely. If history is ever added, store only the **new amount and a timestamp** (plus an optional note) and derive the change from the previous entry, so editing or deleting can never leave numbers inconsistent.
- Dashboard goal: total current money across all these cards (per currency), plus the number of cards.

### Data model decisions
- Totals are **per currency**. Never sum PHP and USD together.
- A card's type (credit vs debit/stored-value) cannot be edited after creation. To change it, delete the card and create a new one. Every destructive action shows a confirm alert (for example, "This also deletes its data").
- Derive, don't store: "overdue" = unpaid and past due date, computed from the due date and the current time (pass `now` in, never call `DateTime.now()` inside the entity). "Used credit" = credit limit minus available limit.
- `BillStatus` is a plain enum (`unpaid`, `paid`). Use a sealed class only if statuses ever carry different data.
- `CardEntity` is an `abstract` class with `CreditCardEntity` and `DebitCardEntity` subclasses. Don't make it `sealed` unless a screen needs an exhaustive `switch` over mixed card types.

## Working rules
- **Ask before modifying anything.** Never create, edit, or delete files, or run installs, builds, or codegen, without my explicit OK first. Reading and analysis are fine.
- The Claude Design prototype is a **reference only**, not a spec. My design differs slightly, and the prototype includes transaction-style UI that does **not** belong in this app: monthly in/out tiles, a "Money in and out" list, a "Changed this month" tile, and the history and "Fix an update" screens.
  - Prototype: https://claude.ai/artifact/XYQq2efZFB51f8gkCc9iq6
  - Main layout is **A** (side-swipe carousel with the card raised). **B** (wallet stack) is the "all cards" list view.
- Act as a senior Flutter engineer mentoring me. I'm a 7-year native iOS developer (SwiftUI, MVVM/MVVM-C) learning Dart and Flutter. Explain with SwiftUI analogies, give the why and the trade-offs, and recommend rather than list every option.

## Architecture decisions
- Layered MVVM with repositories. Feature-first folders under `lib/features/`, shared code in `lib/core/` and `lib/data/`. Shared value types (for example `Currency`) live in `lib/core/domain/`, one concept per file, with no `enums/` folder.
- State management: **Riverpod** (Notifier/AsyncNotifier act as ViewModels). Immutable state classes.
- Navigation: `go_router`. No coordinators. The tab shell and placeholder screens do not need Riverpod.
- Persistence: **drift** (SQLite). No domain layer or use cases until a screen needs one.
- Keep it small. Don't add Clean Architecture ceremony or abstractions for hypothetical needs.
- Dependency order: domain entities (plain Dart), then `go_router` and the tab shell, then Riverpod when the first screen needs state, then drift, then `freezed` last or never. Until then, write `copyWith`, `==` and `hashCode` by hand (planned for the branch after the base container). Add `intl` only when the first screen displays money or dates.
- Entities use `final` fields and `const` constructors. State changes go through `copyWith` so Riverpod sees a new object.
- IDs are `String` (UUID), generated in the app before saving.
- Persistence: if bills get their own drift table, give it a `cardId` foreign key. That is storage only and does not imply any screen that lists bills.

## Data rules
- Money is stored as **integer minor units**, never `double`. Money fields are named with a `Minor` suffix (`creditLimitMinor`, `currentAmountMinor`, `amountDueMinor`).
- `Currency` is an enum (`php`, `usd`) with `code`, `symbol` and `decimals`. The conversion factor is `10^decimals` using integer math, never a hardcoded 100. Store the currency **code string** in the database, never the enum index. Supporting more countries later means growing this list or replacing it with a lookup table.
- Parse and format money in one helper (`parseMinor` / `formatMinor`) with unit tests. Parse by rounding, never truncating (`1.15 * 100` is `114.99999999999999`). Handle `15`, `0.10`, `.5`, `15.`, grouping commas, empty and invalid input.
- Never store full card numbers. Last four digits only.

## Backup and restore (Google Drive)
- Uses the hidden `drive.appdata` scope.
- Back up a clean copy of the SQLite file (flush the write-ahead log or use `VACUUM INTO`).
- Restore replaces all existing data: download to a temp file, run `PRAGMA integrity_check`, check the schema version, close the DB, keep the old file as a fallback, swap, reopen. Roll back on any failure.

## Design tokens
- iOS-flavored. Light theme is cream `#faf6f0` with white cards. Dark theme is black with warm gray cards.
- Accent blue `#0065be` (light) / `#0091ff` (dark).
- Spacing scale 4/8/12/16/24/32. Card radius 18, control radius 12. Minimum tap target 44px (the prototype's Tokens board says 48; undecided).
- Source of truth: the prototype's `project/ds/simply/tokens.json` (read it with the Artifact `read` action on the prototype URL, paths `project/ds/simply/tokens.json` and `project/Tokens.dc.html`). Don't guess hex values; read them from there.
- Theme lives in `lib/core/theme/app_theme.dart` as `lightTheme` and `darkTheme`: `ColorScheme.fromSeed(...)` plus `copyWith` overrides for the tokens. Widgets read `Theme.of(context).colorScheme`, never hardcoded hex.

### Color mapping (light / dark)
| Token | Flutter role | Light | Dark |
|---|---|---|---|
| surface | `surface` | `#faf6f0` | `#000000` |
| surface-raised | `surfaceContainer` | `#ffffff` | `#232019` |
| gray-tint (selected pill highlight) | `surfaceContainerHighest` | `#e8e8e9` | `#383631` |
| ink | `onSurface` | `#000000` | `#ffffff` |
| ink-secondary | `onSurfaceVariant` | `#707075` | `#8e8e93` |
| separator | `outlineVariant` | `#e4e1dd` | `#323235` |
| accent | `primary` | `#0065be` | `#0091ff` |
| on-accent | `onPrimary` | `#ffffff` | `#ffffff` |
| destructive | `error` | `#e30005` | `#ff4245` |

- Dark-mode filled buttons use the deeper `#0065be` fill (white text only passes contrast on it), so override `FilledButtonThemeData` for dark. `#0091ff` is for tappable text and icons.
- `green`, `amber`, `pink` and their tints (Paid, Due soon, chips) have no `ColorScheme` role. Put them in a `ThemeExtension` when the first chip needs them.
- Other radii: chip 8, sheet 34, pill 999. Light-mode cards add a soft shadow (`0 1px 4px rgba(0,0,0,.06)`); dark cards use the warm fill alone.
- Red is only for delete actions. Every color is paired with a word or sign, never color alone.
- Ignore the prototype's "money in / money out" color usage (green +, ink −). That is transaction-style UI and does not belong in this app.
- Verify the M3 `Card` default color (`surfaceContainerLow`) against `surfaceContainer` when the first card is built.

## Commands
- Run: `flutter run`
- Test: `flutter test`
- Analyze: `flutter analyze`
- Codegen (once `build_runner` is added): `dart run build_runner build --delete-conflicting-outputs`

## Distribution constraints
- No iPhone available. Test on the simulator and keep the app crash-free and complete for App Review (guideline 2.1).
- Google Play needs 12 testers for 14 consecutive days before production access.
