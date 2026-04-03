# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test

```bash
# Build
xcodebuild -scheme SonMat -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run tests
xcodebuild -scheme SonMat -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run a single test
xcodebuild -scheme SonMat -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:SonMatTests/SonMatTests/testExample test
```

No linter or formatter is configured. No CI/CD pipeline exists.

## Architecture

**MVVM with SwiftUI + Observation framework (iOS 18.0+)**

Data flows in one direction:

```
Supabase (PostgREST API)
  → SupabaseService (singleton, async queries)
    → @Observable ViewModels (RecipeListViewModel, RecipeDetailViewModel)
      → SwiftUI Views
        → SwiftData cache (RecipeCache, StepCache) for offline fallback
```

- **Models** (`Models/`): `Codable` structs with `CodingKeys` mapping Supabase snake_case → Swift camelCase
- **Persistence** (`Persistence/`): `@Model` classes mirror Supabase tables. Each has `init(from:)` and `toRecipe()`/`toStep()` converters
- **ViewModels** (`ViewModels/`): `@Observable` state. RecipeListViewModel owns search filtering (with Korean jamo partial matching) and category chips. RecipeDetailViewModel fetches steps
- **Views** (`Views/`): Root is `ContentView` → `TabView` (홈/저장/정보) → `NavigationStack`. Detail pushed via `NavigationLink(value:)`
- **Services** (`Services/`): `SupabaseService.shared` for API calls, `AnalyticsService` wraps Firebase (gated by GoogleService-Info.plist presence)

## Key Conventions

- **Korean UI**: All user-facing strings are Korean. Localization via String Catalog (.xcstrings)
- **Font**: GmarketSansMedium bundled as .otf. Use `Font.gmarket(_ size:)` extension — never use system fonts for UI text
- **Design tokens**: All colors defined in `Utilities/ColorExtensions.swift` with light/dark mode pairs. Reference design variables by semantic name (`Color.accent`, `Color.textPrimary`, etc.)
- **Images**: Custom `CachedAsyncImage` using `NSCache` — no third-party image library. Image failures are silent (placeholder fallback, no alert)
- **Error handling**: Network failures show SwiftData cache + `.alert()` with Korean message. First launch with no cache shows `ContentUnavailableView`
- **Design file**: `SonMat.pen` is the canonical design reference (read via Pencil MCP tools only, not `Read`/`Grep`)
- **Line spacing**: All multiline text uses `.lineSpacing(5)` / `lineHeight: 1.4` consistently across all screens

## Key Files

| File | Purpose |
|---|---|
| `SonMat_PRD.md` | Product requirements, data model, design system spec |
| `iOS_ARCHITECTURE.md` | iOS-specific implementation details |
| `PROGRESS.md` | Development phase tracker |
| `SonMat.pen` | Canonical design file (Pencil format) |
| `Utilities/ColorExtensions.swift` | Design system colors + `Font.gmarket()` |
| `Config/SupabaseConfig.swift` | Supabase project URL + anon key |

## Dependencies (SPM via Xcode)

- `supabase-swift` — Supabase client (DB, auth, storage)
- `firebase-ios-sdk` — Firebase Analytics
