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
- [x] Set up `NavigationStack` navigation shell

## Phase 3: Home Screen UI (mock data)
- [x] Recipe card view (thumbnail, title, category chip, cook time)
- [x] `NSCache`-based image cache layer
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
- [ ] Hero image
- [ ] Title, category, prep time, cook time, servings
- [ ] Description
- [ ] Ingredients list
- [ ] Numbered steps with optional per-step images
- [ ] `NavigationLink` from recipe card to detail

## Phase 7: Supabase Backend Setup
- [ ] Create Supabase project
- [ ] Define `recipes` table with schema
- [ ] Define `steps` table with FK to recipes
- [ ] Create `recipe-images` storage bucket (public read)
- [ ] Create `step-images` storage bucket (public read)
- [ ] Configure RLS (public read, admin write)
- [ ] Seed 5–10 initial recipes with steps and images

## Phase 8: API Integration & SwiftData Persistence
- [ ] Initialize `supabase-swift` client
- [ ] Repository layer: fetch recipes from Supabase
- [ ] Repository layer: fetch steps for a recipe
- [ ] Replace mock data with live data in ViewModels
- [ ] `onAppear`-triggered data fetching
- [ ] Save fetched data to SwiftData on success
- [ ] Display cached data + show `.alert()` on failure (Korean messages)
- [ ] Load images from Supabase Storage URLs via cache layer

## Phase 9: Firebase Analytics
- [ ] Set up Firebase iOS project
- [x] Add `firebase-ios-sdk` via SPM
- [ ] Implement: `screen_view`
- [ ] Implement: `recipe_list_loaded`
- [ ] Implement: `search_performed`
- [ ] Implement: `category_filter_tapped`
- [ ] Implement: `recipe_viewed`
- [ ] Implement: `recipe_scroll_depth`
- [ ] Implement: `session_start` / `session_end`
- [ ] Verify events in Firebase console

## Phase 10: Accessibility & QA
- [ ] Korean accessibility labels on all interactive elements
- [ ] VoiceOver audit
- [ ] Dynamic Type text scaling
- [ ] Color contrast review (WCAG AA)
- [ ] Test on multiple screen sizes (SE → Pro Max)

## Phase 11: Polish & App Store Submission
- [ ] Final UI polish and edge case handling
- [ ] Performance profiling
- [ ] Create and host Korean privacy policy page
- [ ] Build Info screen with privacy policy link
- [ ] Prepare Korean App Store listing
- [ ] Submit to App Store

---

## Decisions & Notes
<!-- Record key technical decisions and deviations from PRD here -->
