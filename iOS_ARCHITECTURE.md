# SonMat iOS — Architecture & Implementation

This document covers iOS-specific implementation details. For product requirements, screens, data model, and design system, see [`SonMat_PRD.md`](SonMat_PRD.md).

---

## Tech Stack

| Layer | Technology | Notes |
|---|---|---|
| UI Framework | SwiftUI | Declarative UI, iOS 18.0+ minimum |
| State Management | `@Observable` (Observation framework) | iOS 17+ modern observation |
| Architecture | MVVM | `Codable` structs for models, `@Observable` ViewModels, SwiftUI Views |
| Backend SDK | `supabase-swift` | REST queries, auth, storage access |
| Image Caching | Custom `NSCache`-based layer | In-memory cache wrapping async image loading |
| Local Persistence | SwiftData | `@Model` classes mirror Supabase schema |
| Navigation | `TabView` + `NavigationStack` | 2-tab bottom bar, drill-down via NavigationStack |
| Analytics | Firebase Analytics (`firebase-ios-sdk`) | Free tier, event tracking |
| Localization | String Catalog (`.xcstrings`) | Korean first, English later |
| Font | GmarketSans Medium | Bundled via CoreText registration |

## Swift Packages

| Package | Purpose |
|---|---|
| `supabase-swift` | Supabase client (DB, auth, storage) |
| `firebase-ios-sdk` | Firebase Analytics |

## Project Structure

```
SonMat/
├── Models/          # Recipe, Step (Codable structs + CodingKeys)
├── Persistence/     # SwiftData @Model classes (RecipeCache, StepCache, SavedRecipeCache)
├── ViewModels/      # @Observable view models
├── Views/           # SwiftUI views
├── Services/        # SupabaseService
├── Config/          # SupabaseConfig (credentials)
└── Resources/       # Fonts, assets
```

## Key Implementation Details

### Data Mapping
- Supabase columns are `snake_case` — Swift models use `CodingKeys` to map to `camelCase`.
- `ingredients` is a PostgreSQL `text[]` — decoded as `[String]` in Swift.

### Navigation
- `TabView` with two tabs: "홈" (`RecipeListView` inside `NavigationStack`) and "정보" (`InfoView`).
- Recipe card taps navigate via `NavigationLink` to `RecipeDetailView`.

### Data Fetching
- `.task` modifier on list/detail screens triggers Supabase fetch on every appearance.
- On success: update SwiftData cache, display fresh data.
- On failure: display SwiftData cache, show `.alert()` with Korean error message.

### Search
- `.searchable` modifier on home screen.
- Client-side real-time filtering with Korean partial syllable/jamo matching.

### Image Loading
- Custom `NSCache`-based cache wrapping `AsyncImage`.
- Image load failure: silent fallback to placeholder (no alert).

### Saved Recipes (Local-Only State)
- `SavedRecipeCache` is a client-only SwiftData `@Model` — it does **not** mirror a Supabase table. It stores only `recipeID: UUID` and `savedAt: Date`.
- This is architecturally distinct from `RecipeCache`/`StepCache`, which are cache mirrors of backend data. `SavedRecipeCache` is purely local user preference state.
- `RecipeDetailView` uses `@Query` to observe saved entries and derives `isSaved` from them. `toggleSave()` either deletes the existing entry or inserts a new one.
- `RecipeListView` queries saved entries sorted by `savedAt` descending and maps them back to `Recipe` objects via `viewModel.recipes`.

### Analytics
- `FirebaseApp.configure()` in `SonMatApp.init`, guarded by plist presence check.
- `recipe_scroll_depth` tracked via `onScrollGeometryChange` (25/50/75/100%).
- `search_performed` fires with 800ms debounce.

### Accessibility
- Korean accessibility labels on all interactive elements.
- Dynamic Type text scaling supported.
- Color contrast: textTertiary adjusted to `#6E6E6E` (4.9:1 ratio). Accent on white is 3.78:1 (design trade-off accepted).

---

## Build Phases

For current build progress, see [`PROGRESS.md`](PROGRESS.md).

| Phase | Summary |
|---|---|
| 0. Design | Interactive mockup in `sonmat-preview/src/App.jsx` |
| 1. Xcode Setup | Project, packages, folder structure, SwiftData container |
| 2. Data Models & Nav | Codable structs, SwiftData models, mock data, NavigationStack shell |
| 3. Home Screen UI | Recipe cards, image cache, empty state, GmarketSans font |
| 4. Search | `.searchable`, Korean filtering, no-results state |
| 5. Category Chips | ScrollView chip row, dynamic categories, combined filtering |
| 6. Recipe Detail | Hero image, metadata, ingredients, steps with images |
| 7. Supabase Backend | Tables, RLS, seed data, storage buckets |
| 8. API Integration | Supabase client, repository layer, SwiftData persistence, error handling |
| 9. Firebase Analytics | Event tracking implementation |
| 10. Accessibility & QA | VoiceOver, Dynamic Type, contrast, screen sizes |
| 11. Polish | TabView, InfoView, edge cases |
| 12. App Store | Privacy policy, listing, screenshots, submission |
