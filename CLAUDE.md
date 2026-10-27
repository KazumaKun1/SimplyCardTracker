# SimplyCardTracker

Offline Flutter app for keeping track of debit, stored-value, and credit cards. Local-first, with manual Google Drive backup and restore.

## Product principle: snapshots, not transactions
This is **not** an expense tracker. The user never logs purchases. They open the app occasionally (for example after getting a credit card bill, or after checking their bank app) and tell it what is currently true. Every feature should keep that low-friction, no-daily-habit, no-guilt spirit (the user is AuDHD). Do not add transaction logging, monthly in/out totals, "changed this month" deltas, streaks, reminders to log, or anything that implies a habit.

### Credit cards
- Card facts: name, last four digits (required for credit cards), credit limit, available limit, annual fee (yes/no). Plus the shared identity fields (bank, network, tier) and card color, see "Card identity" and "Card look" below.
- Credit limit and available limit are both typed by the user (a snapshot from the bank app). Neither is calculated from bills. Bills don't include recent swipes, and installment conversions keep occupying the limit, so a calculation would disagree with the bank app.
- Each card has at most one **current bill**: amount due, due date, paid/unpaid. When the next statement arrives, the user overwrites it. The card shows its current unpaid bill.
- No past-bills history and no "All Bills" screen. Deliberately dropped as noise. A possible later idea: "total paid since the card was created", only if the user asks for it.
- No promo/perk notes field.
- Tab summary goals (the summary at the top of the Credit tab, not a separate dashboard screen): total credit limit, total available limit, number of cards, number with no annual fee.

### Debit and stored-value cards (bank debit, train reload cards, amusement park cards)
- One card type for all of these, with a label/icon to tell them apart (not built yet).
- Last four digits are **optional** (many stored-value cards have none, and the user shouldn't invent digits).
- The user taps the balance, edits it, confirms. The balance is a plain field on the card.
- **No history.** History entries and the "Fix an update" screen were dropped entirely. If history is ever added, store only the **new amount and a timestamp** (plus an optional note) and derive the change from the previous entry, so editing or deleting can never leave numbers inconsistent.
- Tab summary goal (the summary at the top of the Debit tab, not a separate dashboard screen): total current money across all these cards (per currency), plus the number of cards.

### Data model decisions
- Totals are **per currency**. Never sum PHP and USD together.
- A card's type (credit vs debit/stored-value) cannot be edited after creation. To change it, delete the card and create a new one. Every destructive action shows a confirm alert (for example, "This also deletes its data").
- Derive, don't store: "overdue" = unpaid and past due date, computed from the due date and the current time (pass `now` in, never call `DateTime.now()` inside the entity). "Used credit" = credit limit minus available limit.
- `BillStatus` is a plain enum (`unpaid`, `paid`). Use a sealed class only if statuses ever carry different data.
- `CardEntity` is an `abstract` class with `CreditCardEntity` and `DebitCardEntity` subclasses. Don't make it `sealed` unless a screen needs an exhaustive `switch` over mixed card types. Type-specific UI goes through a slot (`BaseCard`'s `footer` widget), not a `switch` on the subclass.

### Card identity (bank, name, network, tier)
- `bankName`, `cardName` and `tier` are `String?` on `CardEntity`. The UI shows each only when it is non-empty.
- `network` is a `PaymentNetwork?` (sealed, `payment_network.dart`): a built-in `Network` enum case (with suggested `tiers`) or a user-created `CustomNetwork`. `tier` stays free text, suggested from `network.tiers`. Users will add their own banks, networks and tiers later.
- With drift: the entity keeps the typed network and a data-layer mapper converts it. Store built-ins by enum `name` (never the index) and custom ones in a `custom_networks` table by foreign key. Decide the delete rule for a custom network that cards use (block it, or clear it with a confirm alert). Unknown names fall back to null so an old backup can't crash the app.
- Banks start as a plain string plus a suggestion list the user can type past. Add a banks table only if rename-once or favorites are wanted.
- **No payment-network logos**, and no imitation of brand marks. The app has a tipping jar, so trademark exposure matters. Show the network name as text.

## Card look (color, gradient, pattern)
- `colorKey` is a `String`: the name of a `CardSwatch` case. Default `'teal'` (`CardEntity.defaultColorKey` must match `CardSwatch.defaultSwatch`). Store the key, never the enum index or an ARGB int. Never rename a `CardSwatch` case, because its name is the stored key (adding is safe). `fromKey` falls back to the default for unknown keys.
- Fill is shade 800 (light) / 900 (dark); the gradient runs 800 to 900. White text must reach 4.5:1, so yellow, lime and amber stay out. Orange is a deliberate exception (minimum 3.0: fine for large text, tight for small lines). `card_swatch_test.dart` enforces this for every swatch in both modes. Never loosen or delete it to make a swatch pass: change the swatch or record the exception in the test.
- Never tone a color down with alpha. It blends with the background, so contrast changes with the theme. Use opaque shades.
- Text and icons on a card are always white. `BaseCard` does this once (`_WhiteForeground`: `Theme` override of `textTheme` and `iconTheme`, plus `DefaultTextStyle.merge`). A `Theme` override alone does not recolor plain unstyled `Text`.
- Pattern: two large, faint, filled circles, static. Keep patterns calm for sensory-sensitive users: no stripes, grids or dense repeated dots, low contrast, no motion. Offer "none" if a pattern setting is ever added.
- Cards use `Material` elevation 10: black shadow in light mode, swatch-colored glow plus a 1px `shade700` rim in dark mode. This differs from the generic card shadow on purpose.
- Later, on its own branch: pattern and gradient settings and the color picker sheet. Store presets as string keys (`patternKey`, `gradientKey`) with defaults and fallbacks. The gradient's shade pair stays fixed per swatch (it protects contrast).

## Working rules
- **Ask before modifying anything.** Never create, edit, or delete files, or run installs, builds, or codegen, without my explicit OK first. Reading and analysis are fine.
- The Claude Design prototype is a **reference only**, not a spec. My design differs slightly, and the prototype includes transaction-style UI that does **not** belong in this app: monthly in/out tiles, a "Money in and out" list, a "Changed this month" tile, and the history and "Fix an update" screens.
  - Prototype: https://claude.ai/artifact/XYQq2efZFB51f8gkCc9iq6
  - Main layout is **A** (side-swipe carousel with the card raised). **B** (wallet stack) is the "all cards" list view.
- Act as a senior Flutter engineer mentoring me. I'm a 7-year native iOS developer (SwiftUI, MVVM/MVVM-C) learning Dart and Flutter. Explain with SwiftUI analogies, give the why and the trade-offs, and recommend rather than list every option.

## Architecture decisions
- Layered MVVM with repositories. Feature-first folders under `lib/features/`, shared code in `lib/core/` and `lib/data/`. Shared value types (for example `Currency`) live in `lib/core/domain/`, one concept per file, with no `enums/` folder. Extension methods live in `lib/core/extensions/`.
- State management: **Riverpod** (Notifier/AsyncNotifier act as ViewModels). Immutable state classes. Until a screen needs shared state, plain `setState`.
- Navigation: `go_router`. No coordinators. The tab shell and placeholder screens do not need Riverpod.
- Persistence: **drift** (SQLite). No domain layer or use cases until a screen needs one.
- Keep it small. Don't add Clean Architecture ceremony or abstractions for hypothetical needs.
- Order of arrival: entities, `go_router` + tab shell, `intl`, then Riverpod, then drift, then `freezed` last or never. Add `uuid` with the add-card flow.
- Selected card: the Add button lives in `AppShell`, above the tab screens, so it can't read a screen's `State`. When the Add sheet is built (debit: update a balance; credit: add a bill; then a card list with the current selection preselected), move the selection into a Riverpod provider per tab. Store the selected card's **id**, not its index (indexes shift when cards are added, deleted or sorted).
- Entities use `final` fields and `const` constructors. State changes go through `copyWith` so Riverpod sees a new object.
- IDs are `String` (UUID), generated in the app before saving. Hardcoded test data (`test_data/card_data.dart`) uses literal IDs like `'debit-1'` instead.
- If bills get their own drift table, give it a `cardId` foreign key. That is storage only and does not imply any screen that lists bills.

## Data rules
- Money is stored as **integer minor units**, never `double`. Money fields are named with a `Minor` suffix (`creditLimitMinor`, `currentAmountMinor`, `amountDueMinor`).
- `Currency` is an enum (`php`, `usd`) with `code`, `symbol` and `decimals`. The conversion factor is `10^decimals` using integer math, never a hardcoded 100. Store the currency **code string** in the database, never the enum index. Supporting more countries later means growing this list or replacing it with a lookup table.
- Parse and format money in one helper (`parseMinor` / `formatMinor`) with unit tests. Parse by rounding, never truncating (`1.15 * 100` is `114.99999999999999`). Handle `15`, `0.10`, `.5`, `15.`, grouping commas, empty and invalid input.
- A `double` appears only inside the display formatter (`Currency.format`). Never in an entity, a state class, a total or a database column.
- Never store full card numbers. Last four digits only.
- `CardEntity.lastFourDigits` is a nullable `String` (keeps leading zeros). Exactly 4 digits when present. `CreditCardEntity` requires it (`required String super.lastFourDigits`); the UI shows `•••• 1234` only when it is non-null.

## App shell and platform
- Three tabs: Debit, Credit, Settings (`StatefulShellRoute.indexedStack`). `AppShell` draws the floating pill tab bar and the Add button. Add is an icon-only `FloatingActionButton` at bottom-right for one-handed reach, styled by `floatingActionButtonTheme`. When wired, it is context-dependent: it creates a credit or debit card depending on the tab (the card type is chosen once, at creation).
- Portrait only, iPhone only. Locked in `main()` with `SystemChrome.setPreferredOrientations`, iPhone-only device family in Xcode, and the iPhone `Info.plist` orientations. Exclude tablets in Play Console at release. Foldables and large screens can ignore the lock, so `MaterialApp.router`'s `builder` centers everything in a `maxWidth: 500` column.
- Fonts: leave `fontFamily` unset so iOS gets SF and Android gets Roboto. Dynamic Type scaling stays on; clamp it only where a fixed-size container can't grow (the tab bar).
- Accessibility: any custom tappable (a `GestureDetector`) needs `Semantics` (`button`, `selected`, `label`, `onTap`, `excludeSemantics`). Material widgets already provide it. Icon-only buttons need a tooltip or label.
- Screens under the shell use `extendBody: true`, so scrollable content needs bottom padding for the tab bar and the Add button.
- One-handed reach: interactive things in the lower half, read-only content (the tab summary) at the top. The carousel can't slide lower because the page dots, Add button and tab bar sit below it. Shorten the card or use the top area instead.
- Hot restart (`R`), not hot reload, after changing: theme, `main()`, the router, a widget between stateful and stateless, or the fields of an entity (top-level test-data lists aren't rebuilt, so old objects keep a null and crash with "Null is not a subtype of type ...").

## Card screens (carousel) gotchas
- `HorizontalCardContainer` is controlled, like a `@Binding`: the screen owns `selectedIndex` and passes `onSelectedChanged`. Never read `cards.first` when the list may be empty (it takes a `cardTypeLabel` for the empty message).
- `HorizontalCardCarousel` computes its own height from the width it receives, which is what lets it sit inside a scroll view. Never give it unbounded height. Its 30pt vertical room keeps the shadow from being clipped.
- `BaseCard` has a `footer` slot. `DebitCard` and `CreditCard` are footers, despite their names. The shell is `Material` + `Ink` + `InkWell`: the fill sits on the `Material`, never on a decorated `Container`, or the ripple is hidden.
- Haptics: `selectionClick` when the page changes, `lightImpact` on tap. Money amounts use `FittedBox(fit: BoxFit.scaleDown)`.

## Not built yet
- `parseMinor` (with tests).
- `copyWith`, `==` and `hashCode` on entities; `CustomNetwork` needs a `const` constructor and `==` / `hashCode` (by `id`).
- Add button action and sheet; card detail/edit flow (`onTap` is a placeholder).
- Tab summary at the top of each tab; the debit/stored-value label or icon.
- Text styles from `textTheme` roles mapped to the tokens.
- Riverpod, drift, `uuid`, Google Drive backup.
- Pattern and gradient settings, color picker sheet, custom banks/networks/tiers.

## Backup and restore (Google Drive)
- Uses the hidden `drive.appdata` scope.
- Back up a clean copy of the SQLite file (flush the write-ahead log or use `VACUUM INTO`).
- Restore replaces all existing data: download to a temp file, run `PRAGMA integrity_check`, check the schema version, close the DB, keep the old file as a fallback, swap, reopen. Roll back on any failure.

## Design tokens
- iOS-flavored. Light theme is cream with white cards. Dark theme is black with warm gray cards. Accent blue `#0065be` (light) / `#0091ff` (dark).
- Spacing scale 4/8/12/16/24/32. Card radius 20 (as built; the prototype says 18), control radius 12, chip 8, sheet 34, pill 999. Minimum tap target 44px (the prototype's Tokens board says 48; undecided).
- Source of truth: the prototype's `project/ds/simply/tokens.json` (read it with the Artifact `read` action on the prototype URL, paths `project/ds/simply/tokens.json` and `project/Tokens.dc.html`). Don't guess hex values; read them from there.
- Theme lives in `lib/core/theme/app_theme.dart` (`lightTheme`, `darkTheme`): `ColorScheme.fromSeed(...)` plus `copyWith` overrides for the tokens. Widgets read `Theme.of(context).colorScheme`, never hardcoded hex (secondary text uses `onSurfaceVariant`, not `Colors.black12`, which vanishes in dark mode).
- Token to role: surface-raised is `surfaceContainer`, gray-tint (selected pill) is `surfaceContainerHighest`, ink is `onSurface`, ink-secondary is `onSurfaceVariant`, separator is `outlineVariant`, accent is `primary`, destructive is `error`.
- Keep `lightTheme` and `darkTheme` symmetric. Don't give one theme a hand-written `TextStyle` (for example `extendedTextStyle`) the other lacks: switching light and dark then throws "Failed to interpolate TextStyles with different inherit values" and freezes the app. Share a base (`_fabTheme`) and `copyWith` only what differs.
- Dark-mode filled buttons use the deeper `#0065be` fill (white text only passes contrast on it), so override `FilledButtonThemeData` for dark. `#0091ff` is for tappable text and icons. The icon-only Add button only needs about 3:1 (a graphic), so its light fill can be brighter.
- `green`, `amber`, `pink` and their tints (Paid, Due soon, chips) have no `ColorScheme` role. Put them in a `ThemeExtension` when the first chip needs them.
- Light-mode cards add a soft shadow (`0 1px 4px rgba(0,0,0,.06)`); dark cards use the warm fill alone. The colored bank cards are the exception, see "Card look".
- Red is only for delete actions. Every color is paired with a word or sign, never color alone.
- Ignore the prototype's "money in / money out" color usage (green +, ink −). That is transaction-style UI and does not belong in this app.

## Commands
- Run: `flutter run`
- Test: `flutter test` (tests live in `test/`, mirroring `lib/`)
- Analyze: `flutter analyze`
- Codegen (once `build_runner` is added): `dart run build_runner build --delete-conflicting-outputs`

## Distribution constraints
- No iPhone available. Test on the simulator and keep the app crash-free and complete for App Review (guideline 2.1).
- Google Play needs 12 testers for 14 consecutive days before production access.
