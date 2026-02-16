# Expense Tracker Mini-App

A polished FinTech expense tracking application built with **Flutter** and **Riverpod**, demonstrating clean architecture, thoughtful UI/UX, and production-quality code.

---

## Screenshots

The app features four screens:

- **Home** — Spending summary card with category breakdown, 10 most recent transactions, "See All" navigation
- **All Transactions** — Full transaction list with search by merchant and category filter chips
- **Transaction Detail** — Hero amount display with full transaction metadata
- **Add Transaction** — Validated form with native pickers, category selection, and JSON-serialized submission

---

## Tech Stack

| Layer              | Choice                          | Rationale                                                    |
| ------------------ | ------------------------------- | ------------------------------------------------------------ |
| **Framework**      | Flutter 3.35.0                     | Cross-platform, performant, native feel                      |
| **State Mgmt**     | Riverpod (flutter_riverpod)     | Type-safe, testable, scalable — industry best practice       |
| **Navigation**     | GoRouter                        | Declarative, deep-link ready, clean route definitions        |
| **Styling**        | Google Fonts (DM Sans) + Custom | FinTech-grade typography with a curated color system          |


---

## Architecture & Folder Structure

```
lib/
├── main.dart                              # App entry point + ProviderScope
├── core/
│   ├── theme/
│   │   └── app_theme.dart                 # Colors, typography, Material 3 theme
│   └── utils/
│       ├── helpers.dart                   # Formatting, category colors/icons
│       └── router.dart                    # GoRouter route definitions
├── features/
│   ├── home/
│   │   └── screens/
│   │       └── home_screen.dart           # Dashboard — aggregates from other features
│   │   └── widgets/
│   │       └── spending_summary_card.dart 
│   └── transactions/
│       ├── models/
│       │   └── transaction.dart           # Transaction model + fromJson/toJson + enums
│       ├── providers/
│       │   ├── mock_data.dart             # Raw JSON string (simulated API payload)
│       │   └── transaction_provider.dart  # Riverpod state + derived providers
│       ├── screens/
│       │   ├── all_transactions_screen.dart  # Full list + search + filters
│       │   ├── transaction_detail_screen.dart
│       │   └── add_transaction_screen.dart
│       ├── services/
│       │   ├── transaction_api_service.dart  # Mock API service with async fetch/create
│       └── widgets/
│           ├── category_filter_chips.dart
│           ├── transaction_tile.dart
│           └── search_bar_widget.dart
└── shared/
    └── widgets/
        └── app_text_field.dart            # Unified reusable text field component
```

### Key Architectural Decisions

- **Feature-based structure** — Code is organized by feature domain (`home/`, `transactions/`). Each feature is self-contained. The `home` feature imports from `transactions`, but not vice versa — maintaining a one-way dependency graph that scales as new features (budgets, cards, transfers) are added.

- **Mock API service layer** — Transaction data is stored as raw JSON (simulating a real API response). `TransactionApiService` deserializes it via `Transaction.fromJson()` with simulated network latency. The provider consumes the service through `AsyncValue`, giving the UI proper loading, error, and data states. Swapping in a real HTTP client (dio/http) requires zero changes to the UI layer.

- **JSON serialization** — The `Transaction` model includes `fromJson()` factory constructor and `toJson()` method with safe enum parsing via `fromString()` fallbacks. The `createTransaction` flow performs a full serialize → JSON string → deserialize round-trip to validate the conversion pipeline.

- **Shared widget system** — `AppTextField` is a single, highly configurable text field widget used across the entire app (search bar, amount input, merchant input, date picker trigger, multiline notes). This eliminates duplication and ensures consistent styling/behavior.

- **Riverpod state design** — `StateNotifier` wrapping `AsyncValue` for the core transaction list. `Provider` for derived/computed state (`filteredTransactionsProvider`, `totalSpendingProvider`, `categorySpendingProvider`). No business logic in widgets.

- **Immutable models** — `Transaction` is annotated `@immutable` with `copyWith`, `==` override, and `hashCode`, following Dart best practices.

---

## Setup Instructions

### Prerequisites

- Flutter SDK ≥ 3.35.0 ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Dart SDK ≥ 3.2.0 (bundled with Flutter)
- An emulator/simulator or physical device

### Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/Ngorhzee/Expense_tracker
cd expense_tracker

# 2. Install dependencies
flutter pub get or you can use fvm flutter pub get

# 3. Run the app
flutter run
```

### Running on specific platforms

```bash
flutter run -d ios           # iOS Simulator
flutter run -d android       # Android Emulator
```

---

## Features Implemented

### A. Home Screen
- ✅ Spending summary card with total amount and category breakdown bar
- ✅ Displays the 10 most recent transactions (capped for a clean overview)
- ✅ "See All" navigation link and bottom button to the full transaction list
- ✅ Loading spinner on initial data fetch, error state with retry
- ✅ Empty state with helpful copy when no transactions exist

### B. All Transactions Screen
- ✅ Full scrollable list of all transactions
- ✅ Search by merchant name with real-time filtering
- ✅ Filter by category using horizontally scrollable chips (toggle on/off)
- ✅ Pull-to-refresh with animated indicator
- ✅ Filters reset on back navigation to keep home screen clean
- ✅ Empty state when no results match search/filter

### C. Transaction Detail Screen
- ✅ Navigate from any transaction tile → detail view via GoRouter
- ✅ Hero-style amount display with category icon and color
- ✅ Full metadata: date, status (color-coded), category, transaction ID, note
- ✅ Bottom sheet-style detail card with drag handle aesthetic

### D. Add Transaction Screen
- ✅ All form fields use a shared `AppTextField` widget for consistency
- ✅ Regex-validated decimal input (max 2 decimal places) with `$` prefix
- ✅ Visual category picker with icons and animated selection state
- ✅ Native date picker with themed Material overlay
- ✅ Optional note field (multiline)
- ✅ Form validation with inline error messages and snackbar for missing category
- ✅ Submission serializes to JSON via `toJson()`, sends through mock API service
- ✅ Loading state on submit, success snackbar, auto-pop back to previous screen
- ✅ New transaction appears at the top of the list immediately

### E. Technical Requirements
- ✅ **Dart with strong typing** 
- ✅ **Riverpod** state management with `AsyncValue`, derived/computed providers
- ✅ **GoRouter** navigation with named routes and typed extras
- ✅ **JSON serialization** — `fromJson`/`toJson` on model with safe enum parsing
- ✅ **Mock API layer** — async service with simulated latency, decoupled from UI
- ✅ **Reusable components** — shared `AppTextField` handles all text input variants
- ✅ **Responsive design** — flexible layouts with `Expanded`, `Wrap`, `MediaQuery`
- ✅ **Error handling** — form validation, async error states, empty states, snackbar feedback
- ✅ **Clean folder structure** — feature-based architecture with one-way dependencies

---


## License

This project was built as a coding assessment for Softnet Limited.
