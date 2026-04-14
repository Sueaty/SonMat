# SonMat (손맛) — Development Progress

## Status Legend
- [ ] Not started
- [~] In progress
- [x] Complete

---

## Phase 0: Design
- [x] Interactive design mockup — all screens in `sonmat-preview/src/App.jsx`
- [x] Color palette, typography (GmarketSans), component specs defined in PRD §6.0

## Phase 1: Xcode Project Setup
- [x] Create Xcode project (SwiftUI App lifecycle)
- [x] Set deployment target to iOS 18.0 (set to 18.5)
- [x] Add Swift packages: `supabase-swift` (PostgREST, Storage), `firebase-ios-sdk` (FirebaseAnalytics)
- [x] Set up MVVM folder structure (Models/, Persistence/, ViewModels/, Views/)
- [x] Configure SwiftData model container (RecipeCache + StepCache)

## Phase 2: Data Models & Navigation
- [x] Define `Recipe` struct (Codable + CodingKeys for snake_case)
- [x] Define `Step` struct (Codable + CodingKeys)
- [x] Create SwiftData `@Model` classes for `Recipe` and `Step` (RecipeCache, StepCache)
- [x] Create mock/sample data (3 Korean recipes with steps)
- [x] Set up `NavigationStack` navigation shell (TabView with Info tab deferred to Phase 11)

## Phase 3: Home Screen UI (mock data)
- [x] Recipe card view (thumbnail, title, category chip, cook time)
- [x] `NSCache`-based image cache layer
- [x] Disk image cache layer (`FileManager`, 3-tier memory → disk → network) — Issue #10
- [x] `ContentUnavailableView` welcoming empty state (Korean)
- [x] Recipe list screen wired to mock data
- [x] GmarketSans Medium font bundled and registered via CoreText

## Phase 4: Search
- [x] `.searchable` modifier on home screen
- [x] Real-time Korean text filtering
- [x] Korean partial syllable/jamo matching
- [x] "검색 결과 없음" no-results state

## Phase 5: Category Filter Chips
- [x] Horizontal `ScrollView` chip row
- [x] "전체" chip always first, selected by default
- [x] Dynamically populate chips from data categories
- [x] Category filter + search work together

## Phase 6: Recipe Detail Screen (mock data)
- [x] Hero image
- [x] Title, category, prep time, cook time, servings
- [x] Description
- [x] Ingredients list
- [x] Numbered steps with optional per-step images
- [x] `NavigationLink` from recipe card to detail

## Phase 7: Supabase Backend Setup
- [x] Write `supabase/migrations/001_create_tables.sql` — recipes + steps schema
- [x] Write `supabase/migrations/002_rls_policies.sql` — public read, authenticated write
- [x] Write `supabase/seed.sql` — 5 Korean recipes (된장찌개, 김치볶음밥, 잡채, 파전, 비빔밥)
- [x] Write `SonMat/Config/SupabaseConfig.swift` — placeholder config (fill in credentials after setup)
- [x] **MANUAL:** Create Supabase project at app.supabase.com (region: Northeast Asia - Seoul)
- [x] **MANUAL:** SQL Editor → run `001_create_tables.sql`
- [x] **MANUAL:** SQL Editor → run `002_rls_policies.sql`
- [x] **MANUAL:** SQL Editor → run `seed.sql`
- [x] **MANUAL:** Storage → create `recipe-images` bucket (public read)
- [x] **MANUAL:** Storage → create `step-images` bucket (public read)
- [x] **MANUAL:** Settings → API → fill in `SupabaseConfig.swift` with project URL + anon key
- [x] **MANUAL:** Add `SonMat/Config/SupabaseConfig.swift` to Xcode project target

## Phase 8: API Integration & SwiftData Persistence
- [x] Initialize `supabase-swift` client (`SonMat/Services/SupabaseService.swift`)
- [x] Repository layer: fetch recipes from Supabase
- [x] Repository layer: fetch steps for a recipe
- [x] Replace mock data with live data in ViewModels
- [x] `.task`-triggered data fetching
- [x] Save fetched data to SwiftData on success
- [x] Display cached data + show `.alert()` on failure (Korean messages)
- [x] Load images from Supabase Storage URLs via cache layer

## Phase 9: Firebase Analytics
- [ ] **MANUAL:** Set up Firebase iOS project at console.firebase.google.com
- [ ] **MANUAL:** Download `GoogleService-Info.plist` and add to Xcode target
- [x] Add `firebase-ios-sdk` via SPM
- [x] Initialize `FirebaseApp.configure()` in `SonMatApp.init` (guarded: only runs if plist present)
- [x] Implement: `screen_view` (recipe_list, recipe_detail)
- [x] Implement: `recipe_list_loaded`
- [x] Implement: `search_performed` (800ms debounce)
- [x] Implement: `category_filter_tapped`
- [x] Implement: `recipe_viewed`
- [x] Implement: `recipe_scroll_depth` (25/50/75/100% via `onScrollGeometryChange`)
- [x] Implement: `session_start` / `session_end` (via `scenePhase` in App)
- [ ] **MANUAL:** Verify events in Firebase console (DebugView)

## Phase 10: Accessibility & QA
- [x] Korean accessibility labels on all interactive elements
- [ ] VoiceOver audit — manual: Settings > Accessibility > VoiceOver on device
- [x] Dynamic Type text scaling
- [x] Color contrast review (WCAG AA) — textTertiary updated #9E9E9E→#6E6E6E (4.9:1); accent white text 3.78:1 accepted (design trade-off)
- [ ] Test on multiple screen sizes (SE → Pro Max) — manual: test on Simulator SE 3rd gen, 16, 16 Plus

## Phase 11: Polish
- [x] Wrap `ContentView` in `TabView` with two tabs: "홈" (`RecipeListView`) and "정보" (`InfoView`)
- [x] Build `InfoView` — app icon, version, privacy policy link, contact info
- [ ] Final UI polish and edge case handling
- [ ] Performance profiling

## Phase 12: App Store Submission
- [x] Create Korean privacy policy HTML — `appstore/privacy-policy/index.html`
- [x] Prepare Korean App Store listing draft — `appstore/listing.md`
- [ ] **MANUAL:** Enable GitHub Pages on SonMat repo (Settings → Pages → Source: Deploy from branch `main`, folder `/docs`) → verify https://sueaty.github.io/SonMat/privacy/ loads
- [ ] **MANUAL:** Prepare App Store screenshots (see `appstore/listing.md` for sizes and order)
- [ ] **MANUAL:** App Store Connect → create new app, fill in listing from `appstore/listing.md`, upload screenshots and build
- [ ] **MANUAL:** Submit to App Store review

---

## Decisions & Notes
<!-- Record key technical decisions and deviations from PRD here -->
