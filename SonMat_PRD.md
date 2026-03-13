# 손맛 (SonMat)

## Product Requirements Document (PRD)

*Version 1.1 — MVP (Revised)*

| Field | Value |
|---|---|
| **Product Name** | 손맛 (SonMat) |
| **Platform** | iOS only (Native SwiftUI) |
| **Version** | 1.1 (MVP — Revised) |
| **Primary Language** | Korean (한국어) |
| **Author** | sueaty.cho |
| **Date** | March 2026 |

---

## 1. Overview

손맛 (SonMat) is a lightweight native iOS app that allows a single content owner (you, the admin) to publish and manage a personal collection of recipes. Viewers on iOS can browse, search by dish name, filter by category, and read detailed cooking instructions through a clean, intuitive interface. The app is read-only for end users; all content management happens through the Supabase dashboard.

The app is built natively with SwiftUI (Swift), targeting iOS 18.0 and above. The primary language for all user-facing content and UI is Korean. English localization is planned for a future phase.

---

## 2. Goals & Objectives

- Provide a simple, beautiful, Korean-native interface for browsing a personal recipe collection on iOS.
- Build a polished, native iOS experience using SwiftUI for maximum platform integration and performance.
- Enable fast search by dish name with full Korean character support (including partial syllable matching).
- Allow category-based browsing through horizontal filter chips.
- Present each recipe in a clear, easy-to-follow detail format with per-step images and instructions.
- Collect user behavior analytics to understand how viewers engage with recipes.
- Persist fetched data locally via SwiftData so viewers always see the last-fetched content, even offline.
- Keep the architecture simple and maintainable for a solo developer/admin.
- Ship an MVP in approximately 6 weeks.

---

## 3. Target Audience

**Viewers:** Korean-speaking friends, family, followers, or anyone you share the app with who wants to cook your recipes. The app targets iOS users. All UI copy, labels, and content will be in Korean.

**Admin (You):** The sole content creator who adds, edits, and removes recipes via the Supabase dashboard.

---

## 4. Localization Strategy

**MVP (v1.0):** Korean only. All UI strings, placeholders, empty states, error messages, and accessibility labels will be written in Korean. Xcode's `String Catalog` (.xcstrings) localization system will be set up from the start so that adding languages later is straightforward. App Store listing (title, description, keywords) will target Korean users.

**Future (v2.0+):** English localization will be added by providing translated strings in the String Catalog. The data model already stores text as plain strings, so bilingual recipe content can be supported by adding locale-specific fields or a translations table in Supabase.

---

## 5. User Stories

| # | Role | User Story | Acceptance Criteria |
|---|---|---|---|
| US-1 | Viewer | As a viewer, I want to see a list of all available recipes so I can browse what's available. | Recipe list loads with thumbnail, title, category chip, and cook time. All UI text is in Korean. |
| US-2 | Viewer | As a viewer, I want to search recipes by dish name so I can quickly find what I'm looking for. | Search bar filters results in real-time. Supports Korean character input and partial matching. |
| US-3 | Viewer | As a viewer, I want to filter recipes by category using horizontal chips so I can browse by type. | Tapping a category chip filters the list; tapping again or tapping "전체" resets to show all. |
| US-4 | Viewer | As a viewer, I want to tap a recipe to see its full details so I can follow the cooking instructions. | Detail page shows hero image, ingredients, step-by-step instructions with per-step images, prep time, and servings. |
| US-5 | Viewer | As a viewer, I want to see a welcoming empty state when no recipes are available so I know the app is working and content is coming. | When the recipe list is empty, a friendly Korean `ContentUnavailableView` is shown with a welcoming message. |
| US-6 | Viewer | As a viewer, I want to see previously loaded recipes even when I'm offline so I can still browse content. | When the network is unavailable, the app displays the last-fetched recipes from local SwiftData storage. |
| US-7 | Admin | As the admin, I want to add new recipes via Supabase dashboard so that viewers can see my latest dishes. | Recipes added in Supabase appear in the app when the list screen reappears (`onAppear`). |
| US-8 | Admin | As the admin, I want to edit or delete existing recipes so I can keep the content accurate. | Changes in Supabase reflect in the app upon next screen appearance. |
| US-9 | Admin | As the admin, I want to see how users interact with the app so I can improve recipes and content. | Analytics dashboard shows screen views, search queries, recipe popularity, and session data. |
| US-10 | Viewer | As a viewer, I want to access the app's privacy policy so I know how my data is handled. | A privacy policy screen or link is accessible from the app, written in Korean. |

---

## 6. Features & Screens

### 6.0 Design System

The visual design is defined in `sonmat-preview/src/App.jsx` — an interactive React/Vite mockup that renders all screens inside an iPhone frame. It serves as the canonical design reference for all SwiftUI implementation work.

#### Color Palette

| Role | Hex | Usage |
|---|---|---|
| Background | `#FAFAF8` | App-wide background |
| Card | `#FFFFFF` | Card surfaces (Info screen) |
| Text Primary | `#1A1A1A` | Titles, body copy |
| Text Secondary | `#6B6B6B` | Descriptions, subtitles |
| Text Tertiary | `#9E9E9E` | Timestamps, metadata labels |
| Accent | `#D4603A` | Category badges, step circles, active tab, CTA elements |
| Accent Light | `#FDF0EB` | Accent badge backgrounds |
| Accent Dark | `#B8482A` | App icon gradient endpoint |
| Chip Background | `#F0EFEC` | Inactive category chips, search bar, ingredients card |
| Chip Active | `#1A1A1A` | Selected category chip background |
| Chip Active Text | `#FFFFFF` | Selected category chip label |
| Border / Separator | `#EEEDE9` / `#F0EFEC` | Dividers, card borders |
| Tab Bar | `#FFFFFF` | Bottom tab bar background |
| Tab Inactive | `#BABABA` | Unselected tab icon/label |

#### Typography

| Role | Font | Notes |
|---|---|---|
| Display / Headings | GmarketSans Medium | App title "손맛", section headers |
| Body / UI | GmarketSans Medium | All labels, descriptions, chips, buttons |

GmarketSans is a Korean typeface that reinforces the app's identity. It must be bundled as a custom font resource in the Xcode project.

#### Key Visual Patterns

| Pattern | Description |
|---|---|
| Recipe card | Horizontal layout — 80×80px rounded thumbnail (radius 14), title (16pt semibold), category badge (accent), total time (tertiary), 1-line description (secondary) |
| Category chips | Pill shape (radius 20), 7px vertical / 16px horizontal padding. Inactive: chip background. Active: black background, white text |
| Hero image | Full-width, 300pt tall. Gradient overlay: `rgba(0,0,0,0.35)` top → transparent → `rgba(0,0,0,0.5)` bottom. Back button: 36pt circle, `rgba(255,255,255,0.2)` with blur backdrop |
| Metadata row | Three centered columns (준비 시간 / 조리 시간 / 인분), separated by a hairline border |
| Ingredients card | Rounded card (radius 14), chip-background fill. Each item has a 6pt accent-colored bullet dot |
| Step number | 28pt accent-filled circle, white label (13pt bold) |
| Step image | Full-width minus 40pt left offset, height 180pt, radius 14 |
| Search bar | Radius 12, chip background fill, 16pt search icon (tertiary), circular clear button |
| Tab bar | Height 88pt (including home indicator area), hairline top border |
| App icon (Info screen) | 72×72pt, radius 18, accent-to-accentDark gradient, "손" character in white |

### 6.1 Screen Overview

The app uses a **2-tab bottom navigation bar** (`TabView`). Tab 1 ("홈") contains the Recipe List and Recipe Detail screens via a `NavigationStack`. Tab 2 ("정보") contains the Info / Privacy screen.

| Screen | Tab | Description | Key Elements |
|---|---|---|---|
| Recipe List (Home) | 홈 (Tab 1) | Scrollable list of all recipes. Displays thumbnail, title, category tag, and estimated cook time. Horizontal category filter chips below the search bar. | Search bar, category chips, recipe cards, empty state |
| Search Results | 홈 (Tab 1) | Filtered view of the recipe list based on user's search query. Filters in real-time as user types in Korean. | Search input, filtered cards, "검색 결과 없음" state |
| Recipe Detail | 홈 (Tab 1) | Full recipe view with hero image, description, ingredients list, step-by-step instructions with per-step images, and metadata. | Hero image, ingredient list, numbered steps with images, prep/cook time, servings |
| Info / Privacy | 정보 (Tab 2) | Simple info screen with app icon, version, and a link to the hosted Korean-language privacy policy. | App icon, app version, privacy policy link |

### 6.2 Recipe List (Home Screen)

The home screen displays a vertically scrollable list of recipe cards. Each card includes a thumbnail image, recipe title, category tag, and estimated total time. The layout consists of the following top-to-bottom structure:

1. **Search Bar** — Pinned at the top. Placeholder text: "레시피 검색..." (Search recipes...).
2. **Category Filter Chips** — Horizontally scrollable row of chips below the search bar. The first chip is always "전체" (All), which is selected by default and shows all recipes. The remaining category chips are dynamically populated from the categories present in the database — no fixed category list is defined at this stage. Tapping a chip filters the list; tapping "전체" resets to show all. Search and category filter work together (i.e., search within the selected category).
3. **Recipe Card List** — Vertically scrollable cards within a SwiftUI `List` or `ScrollView`. Data is fetched automatically each time the screen appears (`onAppear` / `.task`). Images load asynchronously via `AsyncImage` with a placeholder and an in-memory `NSCache`-based cache layer. If the list is empty, show a friendly Korean `ContentUnavailableView` with a welcoming message (e.g., "아직 레시피가 없습니다. 곧 맛있는 요리가 추가될 예정이에요!" — "No recipes yet. Delicious dishes are coming soon!").

### 6.3 Search

Search is integrated directly into the home screen via the `.searchable` modifier. As the user types, the recipe list filters in real-time (client-side) by matching the query against recipe titles. The search must support Korean character input correctly, including partial syllable/jamo matching if feasible. The search is case-insensitive. When the query is cleared, the full list is restored. Category chip filtering and search work together (i.e., search within the selected category).

### 6.4 Recipe Detail Screen

Tapping a recipe card navigates to the detail screen, which presents the full recipe in a scrollable layout:

1. **Hero Image** — A large, full-width photo of the finished dish.
2. **Title & Metadata** — Dish name (요리명), category, prep time (준비 시간), cook time (조리 시간), and servings (인분).
3. **Description** — A short paragraph introducing the dish.
4. **Ingredients (재료)** — A bulleted list of all ingredients with quantities.
5. **Steps (조리 방법)** — Numbered step-by-step instructions. Each step displays its stepNumber, an optional image (if provided), and the instruction text.

---

## 7. Data Model

### 7.1 Recipe

Each recipe is stored as a row in the `recipes` table. All Supabase column names use **snake_case** (e.g., `image_url`, `prep_time`). Swift models use `CodingKeys` or the Supabase Swift SDK's `snakeCaseToCamelCase` key decoding strategy to map between conventions.

| Field | DB Column | Type | Description |
|---|---|---|---|
| id | id | UUID | Unique identifier for the recipe |
| title | title | String | Name of the dish (Korean) |
| description | description | String | Short summary of the dish (Korean) |
| imageURL | image_url | String (URL) | URL to the full-size hero image in Supabase Storage (~1200px wide, JPEG, ≤1.5MB) |
| thumbnailURL | thumbnail_url | String (URL) | URL to the thumbnail image in Supabase Storage (~400px wide, JPEG, ≤500KB) |
| category | category | String | Category tag (free-text, defined by admin; displayed as filter chips) |
| prepTime | prep_time | Integer (min) | Preparation time in minutes |
| cookTime | cook_time | Integer (min) | Cooking time in minutes |
| servings | servings | Integer | Number of servings |
| ingredients | ingredients | text\[\] | PostgreSQL text array of ingredients with quantities (Korean). Each array element is one ingredient line (e.g., "소금 1큰술"). Stored as `text[]` for MVP simplicity; can be migrated to a separate `ingredients` table in a future version if relational structure is needed. |
| createdAt | created_at | Timestamp | Date/time the recipe was created |
| updatedAt | updated_at | Timestamp | Date/time the recipe was last updated |

> **Note on `ingredients` as `text[]`:** This approach keeps the Supabase admin workflow simple — just type ingredients as an array in one field. Migrating to a separate table later is straightforward: create the table, run a one-time script to split array entries into rows, update the Swift model, then drop the column.

### 7.2 Step

Each cooking step is stored as a row in the `steps` table, linked to a recipe via foreign key:

| Field | DB Column | Type | Description |
|---|---|---|---|
| id | id | UUID | Unique identifier for the step |
| recipeID | recipe_id | UUID (FK → recipes.id) | Foreign key linking this step to its parent recipe |
| stepNumber | step_number | Integer | Order/sequence number of the step (1-based) |
| imageURL | image_url | String (URL) — nullable | Optional image for this step, hosted in Supabase Storage (~1200px wide, JPEG, ≤1.5MB) |
| instruction | instruction | String | Text instruction for this step (Korean) |

Steps are fetched alongside the recipe and ordered by `step_number` ascending. The `image_url` field is nullable — not every step requires an image.

---

## 7A. Image Handling Strategy

### 7A.1 Image Specifications

All images should be in **JPEG** format for optimal balance of quality and file size for food photography.

| Image Type | Width | Max File Size | Usage |
|---|---|---|---|
| Hero (full-size) | ~1200px | ≤1.5MB | Recipe detail hero image, step images |
| Thumbnail | ~400px | ≤500KB | Recipe list card thumbnails |

The admin should prepare two variants of each hero image before uploading: a full-size version and a smaller thumbnail. Step images only need the full-size variant (they are only displayed on the detail screen).

### 7A.2 Storage Naming Convention

Images are stored in Supabase Storage with the following naming convention:

| Bucket | Path Pattern | Example |
|---|---|---|
| `recipe-images` | `{recipe-id}_hero.jpg` | `a1b2c3d4_hero.jpg` |
| `recipe-images` | `{recipe-id}_thumb.jpg` | `a1b2c3d4_thumb.jpg` |
| `step-images` | `{recipe-id}_step_{n}.jpg` | `a1b2c3d4_step_1.jpg` |

### 7A.3 Client-Side Image Caching

On the Swift side, a lightweight `NSCache`-based image cache layer wraps `AsyncImage` (or replaces it with a custom async image loader) so that images are not re-downloaded on every scroll or screen transition. The cache is in-memory only for MVP; disk caching can be added later if needed.

---

## 7B. Error Handling Strategy

For the MVP, all network and data errors are presented to the viewer via a **SwiftUI `.alert()` popup** with a Korean-language error description. The alert includes a descriptive message and a dismiss button ("확인").

| Error Scenario | Behavior |
|---|---|
| Network request fails (no connection, timeout) | Show alert: "데이터를 불러올 수 없습니다. 인터넷 연결을 확인해주세요." (Cannot load data. Please check your internet connection.) If locally cached data exists via SwiftData, display it behind the alert. |
| Supabase API returns an error | Show alert with the error description. Display cached data if available. |
| Image fails to load | Show a placeholder image (a neutral food icon or gray box). No alert — silent fallback. |
| Empty response (no recipes) | Show the welcoming `ContentUnavailableView` (not an error alert). |

---

## 7C. Data Refresh Strategy

The app does **not** use pull-to-refresh. Instead, data is fetched automatically from Supabase every time the recipe list screen appears (using SwiftUI's `.task` or `onAppear` modifier). This ensures viewers always see the latest content without needing to manually trigger a refresh.

| Trigger | Behavior |
|---|---|
| Recipe list screen appears | Fetch latest recipes from Supabase. On success, update SwiftData cache and display. On failure, display cached data and show error alert. |
| Recipe detail screen appears | Fetch steps for the selected recipe. On success, update SwiftData cache and display. On failure, display cached data and show error alert. |
| App returns from background | No automatic refetch. Data refreshes on next screen appearance. |

---

## 7D. Local Persistence (SwiftData)

To ensure viewers always see content — even when offline — the app persists fetched recipes and steps locally using **SwiftData** (iOS 17+).

| Behavior | Details |
|---|---|
| On successful fetch | Overwrite local SwiftData records with the latest data from Supabase. |
| On failed fetch | Display the most recent locally stored data. Show an error alert informing the viewer that data may not be current. |
| First launch (no cache) | If the fetch fails and no local data exists, show the welcoming empty state. |
| Data model | SwiftData `@Model` classes mirror the Supabase schema. Recipes and Steps are stored locally with the same fields. |

---

## 7E. Authentication

No viewer authentication is required. The app uses the **Supabase anonymous (anon) key** for all read operations. There is no sign-up, login, or anonymous auth flow. Row Level Security (RLS) is configured to allow public read access and restrict write/update/delete to the admin's authenticated Supabase account.

---

## 8. Tech Stack

| Layer | Technology | Notes |
|---|---|---|
| Framework | SwiftUI (Swift) | Apple's native declarative UI framework for iOS. First-class platform integration and performance. |
| State Management | Observation framework (`@Observable`) | Apple's modern observation system (iOS 17+). Lightweight, compiler-verified, and integrates seamlessly with SwiftUI. |
| Networking / Backend SDK | supabase-swift | Official Supabase SDK for Swift. Handles REST queries, auth, real-time subscriptions, and storage access. |
| Image Caching | NSCache-based custom cache | Lightweight in-memory image cache wrapping async image loading. Prevents re-downloading images on scroll and screen transitions. |
| Local Persistence | SwiftData | Apple's modern persistence framework (iOS 17+). Stores fetched recipes and steps locally so the app displays last-fetched data when offline. |
| Navigation | TabView + NavigationStack | Bottom tab bar (`TabView`) with two tabs: "홈" (Home) and "정보" (Info). Each tab wraps a `NavigationStack` for drill-down navigation. |
| Backend / Database | Supabase (PostgreSQL) | Open-source Firebase alternative. Hosted Postgres with REST API, auth, and real-time subscriptions. |
| Image Storage | Supabase Storage | S3-compatible object storage integrated with Supabase. CDN for recipe and step images. |
| Analytics | Firebase Analytics | Analytics via the `firebase-ios-sdk` Swift package. Free with generous limits. |
| Architecture | MVVM | Clean separation of concerns. Models (Swift structs with `Codable`), ViewModels (`@Observable` classes), Views (SwiftUI views). |

### 8.1 Key Swift Packages / Frameworks

| Package / Framework | Purpose |
|---|---|
| `supabase-swift` | Supabase client (DB, auth, storage, real-time) |
| `Observation` | State management (`@Observable` macro) |
| `TabView` + `NavigationStack` | Bottom tab bar with two tabs ("홈", "정보"); `NavigationStack` handles drill-down navigation within each tab (built into SwiftUI) |
| `AsyncImage` | Async image loading (built into SwiftUI) |
| `SwiftData` | Local persistence for offline recipe caching (built into iOS 17+) |
| `firebase-ios-sdk` | User behavior analytics (via Swift Package Manager) |
| `String Catalog` (.xcstrings) | i18n/l10n infrastructure (Korean first, English later) |
| `Codable` | JSON serialization for Recipe/Step models (built into Swift) |

---

## 9. Admin & Content Management (Supabase)

All content management for the MVP is handled directly through the Supabase dashboard. No custom admin UI is needed.

| Component | Details |
|---|---|
| Database Tables | `recipes` (all recipe fields) and `steps` (stepNumber, imageURL, instruction, recipe_id FK). Steps are stored in a separate table with a foreign key to recipes for relational integrity. |
| Storage Buckets | `recipe-images` (hero/thumbnail images) and `step-images` (per-step instruction images). Both set to public read access. |
| Row Level Security | Read: open to all (anon key). Write/Update/Delete: restricted to your admin user (authenticated with your Supabase account). |
| Admin Workflow | Use the Supabase Table Editor to add/edit/delete recipes and steps. Upload images via the Storage browser. No custom admin UI needed for MVP. |

### 9.1 Workflow for Adding a Recipe

1. Prepare images: resize the hero photo to two variants — full-size (~1200px wide, JPEG, ≤1.5MB) and thumbnail (~400px wide, JPEG, ≤500KB). Resize any step images to ~1200px wide. Use Preview on Mac or any image editor.
2. Upload images to the appropriate Supabase Storage bucket using the naming convention: `{recipe-id}_hero.jpg`, `{recipe-id}_thumb.jpg`, and `{recipe-id}_step_{n}.jpg`. Copy the public URLs.
3. In the Supabase Table Editor, insert a new row in the `recipes` table with the recipe details, the hero `image_url`, and the `thumbnail_url`.
4. Insert rows in the `steps` table for each cooking step, referencing the recipe's ID as the `recipe_id` foreign key. Include the `step_number`, `instruction` text, and the step `image_url` (if applicable).
5. The recipe will appear in the app the next time the recipe list screen appears.

For future versions, a lightweight web admin panel or an in-app admin mode could streamline this process.

---

## 10. User Behavior Analytics

To understand how viewers interact with the app, Firebase Analytics will be integrated to capture key user events on iOS. This data will help the admin identify popular recipes, common search queries, and engagement patterns.

### 10.1 Recommended Tool

Firebase Analytics via the `firebase-ios-sdk` Swift package. Zero cost, generous limits, and provides a comprehensive dashboard. Mixpanel is a viable alternative if richer funnel analysis is needed later.

### 10.2 Events to Track

| Event Name | Trigger | Parameters |
|---|---|---|
| screen_view | User navigates to a screen | screen_name |
| recipe_list_loaded | Home screen recipe list finishes loading | recipe_count, load_time_ms |
| search_performed | User submits or pauses typing a search query | query_text, result_count |
| category_filter_tapped | User taps a category chip | category_name |
| recipe_viewed | User opens a recipe detail page | recipe_id, recipe_title |
| recipe_scroll_depth | User scrolls past 50% / 100% of the detail page | recipe_id, depth_percent |
| session_start / session_end | App enters foreground / background | session_duration_sec |

### 10.3 Privacy & Compliance

The app must comply with Korea's Personal Information Protection Act (PIPA) and Apple's App Store requirements:

| Requirement | Implementation |
|---|---|
| Privacy Policy | A Korean-language privacy policy hosted as a web page (e.g., on GitHub Pages or Notion). Accessible from the app's Info screen via a tappable link. |
| Policy Content | Discloses: (1) anonymous usage data is collected (screen views, search queries, tap events), (2) purpose is improving the recipe experience, (3) no personally identifiable information (PII) is collected, (4) data is processed via Firebase/Google. |
| App Store | The privacy policy URL is required for App Store submission. |
| ATT / IDFA | Firebase Analytics does not use IDFA by default, so App Tracking Transparency (ATT) prompts are not required for MVP. Review if additional tracking is added later. |
| Consent Popup | Not required for anonymous, non-PII analytics under current PIPA guidelines. The accessible privacy policy constitutes sufficient disclosure. |

---

## 11. Non-Functional Requirements

- **Performance:** Every screen should load within 2 seconds on a standard connection. Images should lazy-load with in-memory caching via a custom `NSCache`-based layer.
- **Localization:** All UI text, labels, placeholders, and error messages in Korean. App Store listing in Korean.
- **Offline / Persistence:** Fetched recipes and steps are persisted locally via SwiftData. When offline, the app displays the last-fetched data. On first launch with no cache and no network, the welcoming empty state is shown.
- **Data Refresh:** Data is fetched from Supabase on every screen appearance (`onAppear` / `.task`). No pull-to-refresh.
- **Error Handling:** Network and API errors are shown via a SwiftUI `.alert()` popup with a Korean error description. Image load failures fall back silently to a placeholder.
- **Scalability:** Supabase's hosted Postgres and storage scale without infrastructure changes.
- **Accessibility:** Actively support iOS accessibility features. This includes: Dynamic Type support for scalable text, full VoiceOver support with meaningful Korean accessibility labels on every interactive element, sufficient color contrast ratios (WCAG AA minimum), and support for system-level bold text and reduced motion preferences.
- **Minimum platform version:** iOS 18.0+. This ensures access to the latest SwiftUI features and covers the majority of active iOS devices.
- **Platform consistency:** The app should feel fully native on iOS. Use SwiftUI's native components and design patterns, following Apple's Human Interface Guidelines.

---

## 12. Milestones & Timeline

The development order prioritizes finalizing the data model and building client-side UI first, before setting up the backend. This allows rapid iteration on the user experience with mock data before wiring up Supabase.

| Phase | Deliverables | Est. Duration | Status |
|---|---|---|---|
| **Phase 0: Design** | Interactive design mockup covering all screens (Home, Detail, Empty State, Info). Establishes color palette, typography (GmarketSans), component specs, and visual patterns. Reference: `sonmat-preview/src/App.jsx`. | 1 day | ✅ Done |
| **Phase 1: Xcode Project Setup** | Create new Xcode project with SwiftUI App lifecycle. Set minimum deployment target to iOS 18.0. Add Swift package dependencies (supabase-swift, firebase-ios-sdk). Set up MVVM folder structure. Configure SwiftData model container. | 1 day | |
| **Phase 2: Data Models & Navigation** | Define Recipe and Step data models as Swift structs with `Codable` and `CodingKeys` for snake_case mapping. Create corresponding SwiftData `@Model` classes for local persistence. Create mock/sample data for local development. Set up `NavigationStack`-based navigation shell. | 2 days | |
| **Phase 3: Home Screen UI** | Build the Recipe List screen with recipe card views (thumbnail, title, category chip, cook time). Build `NSCache`-based image cache layer. Build `ContentUnavailableView` welcoming empty state. All UI text in Korean. Use mock data. | 3 days | |
| **Phase 4: Search** | Implement the search bar with `.searchable` modifier and real-time Korean text filtering. Ensure correct Korean input behavior. Build "검색 결과 없음" (no results) state. | 2 days | |
| **Phase 5: Category Filter Chips** | Build the horizontally scrollable chip row using `ScrollView` with button/capsule styles. Dynamically populate chips from categories in the data. "전체" always first and selected by default. Wire category filter to work in combination with search. | 2 days | |
| **Phase 6: Recipe Detail Screen** | Build the detail screen layout: hero image, title/metadata, description, ingredients list, numbered steps with per-step images. Wire navigation from recipe card tap to detail screen via `NavigationLink`. Use mock data. | 3 days | |
| **Phase 7: Supabase Backend Setup** | Create Supabase project. Define `recipes` and `steps` tables with schema and foreign keys. Create `recipe-images` and `step-images` storage buckets. Configure Row Level Security (public read, admin write). Seed 5–10 initial recipes with step data and images. | 3 days | |
| **Phase 8: API Integration & Persistence** | Initialize `supabase-swift` in the app. Build repository layer to fetch recipes and steps from Supabase. Replace mock data with live data in `@Observable` ViewModels. Implement `onAppear`-triggered data fetching. Wire SwiftData persistence: save fetched data locally, display cached data on failure. Implement `.alert()`-based error handling with Korean messages. Implement image loading from Supabase Storage URLs via the custom cache layer. | 5 days | |
| **Phase 9: Analytics Integration** | Set up Firebase project for iOS. Add `firebase-ios-sdk` via Swift Package Manager. Implement all tracked events (screen_view, search_performed, category_filter_tapped, recipe_viewed, scroll_depth, session tracking). Verify events fire correctly in the Firebase console. | 2 days | |
| **Phase 10: Accessibility & QA** | Add Korean accessibility labels to all interactive elements. Test with VoiceOver. Verify Dynamic Type text scaling behavior. Color contrast review (WCAG AA). Test on multiple screen sizes (iPhone SE to Pro Max). | 2 days | |
| **Phase 11: Polish** | Wrap `ContentView` in `TabView` with two tabs ("홈", "정보"). Build `InfoView` (app icon, version, privacy policy link, contact info). Final UI polish and edge case handling. Performance profiling. | 2 days | |
| **Phase 12: App Store Submission** | Create and host Korean-language privacy policy page. Prepare Korean App Store listing (title, description, screenshots, keywords, privacy policy URL). Submit to App Store. | 1 day | |

**Total estimated duration: ~5–6 weeks** (Phase 0 complete)

---

## 13. Future Considerations (Post-MVP)

The following features are intentionally deferred from the MVP but may be added in future versions:

- English localization (UI and recipe content via String Catalog).
- Favorites / bookmarking for viewers.
- Sorting options (by prep time, date added, popularity based on analytics).
- Push notifications when a new recipe is published (via APNs / Firebase Cloud Messaging).
- Share recipe via link or social media (using `ShareLink`).
- Dark mode support (SwiftUI's native dark mode via `preferredColorScheme` and adaptive colors).
- Recipe rating or comments from viewers.
- Dedicated web admin panel for recipe management.
- Offline mode with full image caching to disk (beyond SwiftData text persistence).
- Ingredient quantity adjustment based on serving size.
- iPad layout with responsive design.
- watchOS companion app for quick recipe reference.
- Widgets for recipe of the day (WidgetKit).

---

## 14. Success Metrics

- Every screen loads and displays content within 2 seconds on a standard connection.
- Search returns relevant results within 300ms of Korean text input.
- Category filter chips correctly filter the recipe list with instant visual feedback.
- Recipe detail page renders completely with all content, per-step images, and ingredients.
- Admin can add a new recipe via Supabase and it appears in the app on the next screen appearance.
- When offline, the app displays the last-fetched recipes and steps from local SwiftData storage without crashing.
- Error alerts display meaningful Korean error descriptions when network requests fail.
- Analytics events fire correctly and data appears in the Firebase dashboard.
- All screens pass VoiceOver audits with meaningful Korean accessibility labels.
- Privacy policy is accessible from the Info screen and hosted at a stable URL.
- App receives approval from the App Store on first submission.
