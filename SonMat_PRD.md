# 손맛 (SonMat)

## Product Requirements Document (PRD)

*Version 2.0 — Platform-Agnostic*

| Field | Value |
|---|---|
| **Product Name** | 손맛 (SonMat) |
| **Platform** | Mobile (iOS first, Android planned) |
| **Version** | 2.0 |
| **Primary Language** | Korean (한국어) |
| **Author** | sueaty.cho |
| **Date** | March 2026 |

---

## 1. Overview

손맛 (SonMat) is a lightweight mobile app that allows a single content owner (the admin) to publish and manage a personal collection of recipes. Viewers can browse, search by dish name, filter by category, and read detailed cooking instructions through a clean, intuitive interface. The app is read-only for end users; all content management happens through the Supabase dashboard.

The primary language for all user-facing content and UI is Korean. English localization is planned for a future phase.

---

## 2. Goals & Objectives

- Provide a simple, beautiful, Korean-native interface for browsing a personal recipe collection.
- Enable fast search by dish name with full Korean character support (including partial syllable matching).
- Allow category-based browsing through horizontal filter chips.
- Present each recipe in a clear, easy-to-follow detail format with per-step images and instructions.
- Collect user behavior analytics to understand how viewers engage with recipes.
- Persist fetched data locally so viewers always see the last-fetched content, even offline.
- Keep the architecture simple and maintainable for a solo developer/admin.

---

## 3. Target Audience

**Viewers:** Korean-speaking friends, family, followers, or anyone you share the app with who wants to cook your recipes. All UI copy, labels, and content will be in Korean.

**Admin (You):** The sole content creator who adds, edits, and removes recipes via the Supabase dashboard.

---

## 4. Localization Strategy

**MVP (v1.0):** Korean only. All UI strings, placeholders, empty states, error messages, and accessibility labels will be written in Korean. The localization system should be set up from the start so that adding languages later is straightforward. App Store / Play Store listing will target Korean users.

**Future (v2.0+):** English localization. The data model already stores text as plain strings, so bilingual recipe content can be supported by adding locale-specific fields or a translations table in Supabase.

---

## 5. User Stories

| # | Role | User Story | Acceptance Criteria |
|---|---|---|---|
| US-1 | Viewer | As a viewer, I want to see a list of all available recipes so I can browse what's available. | Recipe list loads with thumbnail, title, category chip, and cook time. All UI text is in Korean. |
| US-2 | Viewer | As a viewer, I want to search recipes by dish name so I can quickly find what I'm looking for. | Search bar filters results in real-time. Supports Korean character input and partial matching. |
| US-3 | Viewer | As a viewer, I want to filter recipes by category using horizontal chips so I can browse by type. | Tapping a category chip filters the list; tapping again or tapping "전체" resets to show all. |
| US-4 | Viewer | As a viewer, I want to tap a recipe to see its full details so I can follow the cooking instructions. | Detail page shows hero image, ingredients, step-by-step instructions with per-step images, prep time, and servings. |
| US-5 | Viewer | As a viewer, I want to see a welcoming empty state when no recipes are available so I know the app is working and content is coming. | When the recipe list is empty, a friendly Korean empty state is shown with a welcoming message. |
| US-6 | Viewer | As a viewer, I want to see previously loaded recipes even when I'm offline so I can still browse content. | When the network is unavailable, the app displays the last-fetched recipes from local storage. |
| US-7 | Admin | As the admin, I want to add new recipes via Supabase dashboard so that viewers can see my latest dishes. | Recipes added in Supabase appear in the app when the list screen reappears. |
| US-8 | Admin | As the admin, I want to edit or delete existing recipes so I can keep the content accurate. | Changes in Supabase reflect in the app upon next screen appearance. |
| US-9 | Admin | As the admin, I want to see how users interact with the app so I can improve recipes and content. | Analytics dashboard shows screen views, search queries, recipe popularity, and session data. |
| US-10 | Viewer | As a viewer, I want to access the app's privacy policy so I know how my data is handled. | A privacy policy screen or link is accessible from the app, written in Korean. |
| US-11 | Viewer | As a viewer, I want to see recommended Coupang products for recipe ingredients so I can quickly purchase what I need. | A horizontally-scrollable product section appears on the detail screen (when products exist) with thumbnails, names, and tappable affiliate links. The section includes the required Coupang Partners disclosure text. |

---

## 6. Features & Screens

### 6.0 Design System

The visual design is defined in the canonical reference:
- **Pencil design file:** `SonMat.pen` — created in Pencil with all screens (Home, Detail, Empty State, Info).

#### Color Palette

| Role | Hex | Usage |
|---|---|---|
| Background | `#F7F5F0` | App-wide background |
| Card | `#FFFFFF` | Card surfaces |
| Text Primary | `#2B2520` | Titles, body copy |
| Text Secondary | `#6B6158` | Descriptions, subtitles |
| Text Tertiary | `#9C9488` | Timestamps, metadata labels |
| Accent | `#C4533A` | Category badges, step circles, active chip, CTA elements |
| Accent Light | `#FDF0EB` | Accent badge backgrounds |
| Accent Dark | `#A8412B` | App icon gradient endpoint |
| Chip Background | `#EFEBE4` | Inactive category chips, search bar, ingredients card |
| Chip Active | `#C4533A` | Selected category chip background (accent color) |
| Chip Active Text | `#FFFFFF` | Selected category chip label |
| Border / Separator | `#E8E4DC` / `#EFEBE4` | Dividers, card borders |
| Tab Bar | `#FFFFFF` | Bottom tab bar background |
| Tab Inactive | `#BABABA` | Unselected tab icon/label |

#### Typography

| Role | Font | Notes |
|---|---|---|
| Display / Headings | GmarketSans Medium | App title "손맛", section headers |
| Body / UI | GmarketSans Medium | All labels, descriptions, chips, buttons |

GmarketSans is a Korean typeface that reinforces the app's identity. It must be bundled as a custom font resource.

All multiline text (descriptions, step instructions) uses a consistent line height of 1.4× (`lineSpacing: 5pt` in SwiftUI).

#### Key Visual Patterns

| Pattern | Description |
|---|---|
| Recipe card | Flat style — no card background, 14pt vertical padding, bottom border separator. Horizontal layout — 100x100px rounded thumbnail (radius 14), title (16pt semibold), category badge (accent on accent-light), total time (tertiary), 2-line description (secondary). 20pt horizontal margins |
| Category chips | Pill shape (radius 20), 7px vertical / 16px horizontal padding. Inactive: chip background. Active: accent background, white text |
| Hero image | Full-width, 300pt tall. Gradient overlay: `rgba(0,0,0,0.13)` top -> transparent -> `rgba(0,0,0,0.67)` bottom. Back/bookmark buttons: 36pt circle, `rgba(255,255,255,0.2)` with blur backdrop, positioned below safe area (y: 62pt) |
| Metadata row | Card background, corner radius 16, three evenly distributed columns (space-around) with icons (timer/flame/person), bottom 1px border |
| Ingredients card | Rounded card (radius 16), accent-light fill. Each item has an 8pt accent-colored bullet dot, 12pt vertical / 16pt horizontal padding, 1px border separator |
| Step number | 28pt accent-filled circle, white label (13pt bold) |
| Step image | Full-width minus 40pt left offset, aspect ratio 7:4, radius 14 |
| Search bar | Radius 12, chip background fill, 16pt search icon (tertiary), circular clear button |
| Tab bar | Height 88pt (including home indicator area), hairline top border. Two tabs: "홈" (Home) and "정보" (Info) |
| App icon (Info screen) | 72x72pt, radius 18, accent-to-accentDark gradient, "손" character in white |

### 6.1 Screen Overview

The app uses a **2-tab bottom navigation bar**. Tab 1 ("홈") contains the Recipe List and Recipe Detail screens. Tab 2 ("정보") contains the Info / Privacy screen.

| Screen | Tab | Description | Key Elements |
|---|---|---|---|
| Recipe List (Home) | 홈 (Tab 1) | Scrollable list of all recipes. Displays thumbnail, title, category tag, and estimated cook time. Horizontal category filter chips below the search bar. | Search bar, category chips, recipe cards, empty state |
| Search Results | 홈 (Tab 1) | Filtered view of the recipe list based on user's search query. Filters in real-time as user types in Korean. | Search input, filtered cards, "검색 결과 없음" state |
| Recipe Detail | 홈 (Tab 1) | Full recipe view with hero image, description, ingredients list, step-by-step instructions with per-step images, and metadata. | Hero image, ingredient list, numbered steps with images, prep/cook time, servings |
| Info / Privacy | 정보 (Tab 2) | Simple info screen with app icon, version, and a link to the hosted Korean-language privacy policy. | App icon, app version, privacy policy link, terms of service, contact |

### 6.2 Recipe List (Home Screen)

The home screen displays a vertically scrollable list of recipe cards. Each card includes a thumbnail image, recipe title, category tag, and estimated total time. The layout consists of the following top-to-bottom structure:

1. **Search Bar** — Pinned at the top. Placeholder text: "레시피 검색..." (Search recipes...).
2. **Category Filter Chips** — Horizontally scrollable row of chips below the search bar. The first chip is always "전체" (All), which is selected by default and shows all recipes. The remaining category chips are dynamically populated from the categories present in the database. Tapping a chip filters the list; tapping "전체" resets to show all. Search and category filter work together (i.e., search within the selected category).
3. **Recipe Card List** — Vertically scrollable cards. Data is fetched automatically each time the screen appears. Images load asynchronously with a placeholder and an in-memory cache layer. If the list is empty, show a friendly Korean empty state with a welcoming message (e.g., "아직 레시피가 없습니다. 곧 맛있는 요리가 추가될 예정이에요!").

### 6.3 Search

Search is integrated directly into the home screen. As the user types, the recipe list filters in real-time (client-side) by matching the query against recipe titles. The search must support Korean character input correctly, including partial syllable/jamo matching if feasible. The search is case-insensitive. When the query is cleared, the full list is restored. Category chip filtering and search work together.

### 6.4 Recipe Detail Screen

Tapping a recipe card navigates to the detail screen, which presents the full recipe in a scrollable layout:

1. **Hero Image** — A large, full-width photo of the finished dish.
2. **Title & Metadata** — Dish name (요리명), category, prep time (준비 시간), cook time (조리 시간), and servings (인분).
3. **Description** — A short paragraph introducing the dish.
4. **Ingredients (재료)** — A bulleted list of all ingredients with quantities.
5. **Coupang Products (추천 상품)** — *(Conditional: only shown when the recipe has linked products.)* A horizontally-scrollable row of product cards. Each card shows a 130×130 thumbnail and the product name. Tapping a card opens the Coupang affiliate link in an external browser. A header row displays "추천 상품" with a "Coupang" badge. Below the product row, the required Coupang Partners disclosure text is shown: "쿠팡 파트너스 활동의 일환으로, 이에 따른 일정액의 수수료를 제공받습니다."
6. **Steps (조리 방법)** — Numbered step-by-step instructions. Each step displays its step number, an optional image (if provided), and the instruction text.

---

## 7. Data Model (Supabase)

### 7.1 `recipes` Table

All column names use **snake_case**. Client-side models should map to platform-appropriate naming conventions (e.g., camelCase).

| Column | Type | Description |
|---|---|---|
| id | UUID (PK) | Unique identifier for the recipe |
| title | text | Name of the dish (Korean) |
| description | text | Short summary of the dish (Korean) |
| image_url | text (URL) | URL to the full-size hero image in Supabase Storage (~1200px wide, JPEG, ≤1.5MB) |
| thumbnail_url | text (URL) | URL to the thumbnail image in Supabase Storage (~400px wide, JPEG, ≤500KB) |
| category | text | Category tag (free-text, defined by admin; displayed as filter chips) |
| prep_time | integer | Preparation time in minutes |
| cook_time | integer | Cooking time in minutes |
| servings | integer | Number of servings |
| ingredients | text[] | PostgreSQL text array of ingredients with quantities (Korean). Each element is one ingredient line (e.g., "소금 1큰술"). |
| coupang_products | jsonb, nullable | JSON array of Coupang affiliate products. Each element: `{"name": "...", "thumbnail_url": "...", "product_url": "..."}`. NULL when no products are linked. |
| created_at | timestamptz | Date/time the recipe was created |
| updated_at | timestamptz | Date/time the recipe was last updated |

> **Note on `ingredients` as `text[]`:** This keeps the admin workflow simple. Migrating to a separate table later is straightforward: create the table, run a one-time script to split array entries into rows, update client models, then drop the column.

### 7.2 `steps` Table

| Column | Type | Description |
|---|---|---|
| id | UUID (PK) | Unique identifier for the step |
| recipe_id | UUID (FK -> recipes.id) | Foreign key linking this step to its parent recipe |
| step_number | integer | Order/sequence number (1-based) |
| image_url | text (URL), nullable | Optional image for this step |
| instruction | text | Text instruction for this step (Korean) |

Steps are fetched alongside the recipe and ordered by `step_number` ascending.

---

## 8. Image Handling

### 8.1 Image Specifications

All images should be in **JPEG** format for optimal balance of quality and file size for food photography.

| Image Type | Width | Max File Size | Usage |
|---|---|---|---|
| Hero (full-size) | ~1200px | ≤1.5MB | Recipe detail hero image, step images |
| Thumbnail | ~400px | ≤500KB | Recipe list card thumbnails |

The admin should prepare two variants of each hero image: full-size and thumbnail. Step images only need the full-size variant.

### 8.2 Storage Naming Convention (Supabase Storage)

| Bucket | Path Pattern | Example |
|---|---|---|
| `recipe-images` | `{recipe-id}_hero.jpg` | `a1b2c3d4_hero.jpg` |
| `recipe-images` | `{recipe-id}_thumb.jpg` | `a1b2c3d4_thumb.jpg` |
| `step-images` | `{recipe-id}_step_{n}.jpg` | `a1b2c3d4_step_1.jpg` |

### 8.3 Client-Side Image Caching

Each platform should implement an in-memory image cache so that images are not re-downloaded on every scroll or screen transition. Disk caching can be added later if needed.

---

## 9. App Behavior

### 9.1 Data Refresh

The app does **not** use pull-to-refresh. Data is fetched automatically from Supabase every time the recipe list screen appears.

| Trigger | Behavior |
|---|---|
| Recipe list screen appears | Fetch latest recipes from Supabase. On success, update local cache and display. On failure, display cached data and show error message. |
| Recipe detail screen appears | Fetch steps for the selected recipe. On success, update local cache and display. On failure, display cached data and show error message. |
| App returns from background | No automatic refetch. Data refreshes on next screen appearance. |

### 9.2 Error Handling

| Error Scenario | Behavior |
|---|---|
| Network request fails | Show error message: "데이터를 불러올 수 없습니다. 인터넷 연결을 확인해주세요." Display cached data if available. |
| API returns an error | Show error message with description. Display cached data if available. |
| Image fails to load | Show a placeholder image (neutral food icon or gray box). No error message — silent fallback. |
| Empty response (no recipes) | Show welcoming empty state (not an error). |

### 9.3 Local Persistence (Offline Support)

To ensure viewers always see content — even when offline — the app persists fetched recipes and steps locally.

| Behavior | Details |
|---|---|
| On successful fetch | Overwrite local records with the latest data from Supabase. |
| On failed fetch | Display the most recent locally stored data. Show an error message informing the viewer that data may not be current. |
| First launch (no cache) | If the fetch fails and no local data exists, show the welcoming empty state. |

### 9.4 Authentication

No viewer authentication is required. The app uses the **Supabase anonymous (anon) key** for all read operations. Row Level Security (RLS) is configured to allow public read access and restrict write/update/delete to the admin's authenticated Supabase account.

---

## 10. Admin & Content Management (Supabase)

All content management is handled through the Supabase dashboard. No custom admin UI is needed.

| Component | Details |
|---|---|
| Database Tables | `recipes` and `steps`. Steps stored in a separate table with FK to recipes. |
| Storage Buckets | `recipe-images` (hero/thumbnail) and `step-images` (per-step images). Both public read. |
| Row Level Security | Read: open to all (anon key). Write/Update/Delete: restricted to admin (authenticated). |

### 10.1 Workflow for Adding a Recipe

1. Prepare images: resize the hero photo to two variants — full-size (~1200px, ≤1.5MB) and thumbnail (~400px, ≤500KB). Resize step images to ~1200px wide.
2. Upload images to the appropriate Supabase Storage bucket using the naming convention. Copy the public URLs.
3. In the Supabase Table Editor, insert a new row in `recipes` with the recipe details and image URLs.
4. Insert rows in `steps` for each cooking step, referencing the recipe's ID. Include `step_number`, `instruction`, and optional `image_url`.
5. The recipe will appear in the app the next time the recipe list screen appears.

---

## 11. Analytics

### 11.1 Events to Track

| Event Name | Trigger | Parameters |
|---|---|---|
| screen_view | User navigates to a screen | screen_name |
| recipe_list_loaded | Home screen recipe list finishes loading | recipe_count, load_time_ms |
| search_performed | User submits or pauses typing a search query | query_text, result_count |
| category_filter_tapped | User taps a category chip | category_name |
| recipe_viewed | User opens a recipe detail page | recipe_id, recipe_title |
| recipe_scroll_depth | User scrolls past 25/50/75/100% of the detail page | recipe_id, depth_percent |
| session_start / session_end | App enters foreground / background | session_duration_sec |

### 11.2 Privacy & Compliance

| Requirement | Details |
|---|---|
| Privacy Policy | A Korean-language privacy policy hosted at a stable URL. Accessible from the app's Info screen. |
| Policy Content | Discloses: (1) anonymous usage data is collected, (2) purpose is improving the recipe experience, (3) no PII is collected, (4) data processors (Firebase/Google, Supabase, Coupang Partners). |
| Affiliate Disclosure | The Coupang product section includes the required Coupang Partners disclosure text. The privacy policy page discloses the affiliate relationship and links to Coupang's privacy policy. |
| App Store / Play Store | Privacy policy URL is required for store submission. |
| ATT / IDFA (iOS) | Not required for MVP if analytics SDK does not use IDFA. Review if additional tracking is added. |
| Consent Popup | Not required for anonymous, non-PII analytics under current PIPA guidelines. |

---

## 12. Non-Functional Requirements

- **Performance:** Every screen should load within 2 seconds on a standard connection. Images should lazy-load with in-memory caching.
- **Localization:** All UI text, labels, placeholders, and error messages in Korean. Store listing in Korean.
- **Offline:** Fetched data is persisted locally. When offline, the app displays the last-fetched data. On first launch with no cache and no network, show the welcoming empty state.
- **Accessibility:** Support platform accessibility features: scalable text, screen reader with meaningful Korean labels, sufficient color contrast (WCAG AA minimum), bold text and reduced motion preferences.
- **Platform consistency:** The app should feel fully native on each platform, following the respective platform's design guidelines (HIG for iOS, Material Design for Android).

---

## 13. Future Considerations (Post-MVP)

- English localization (UI and recipe content).
- Favorites / bookmarking for viewers.
- Sorting options (by prep time, date added, popularity).
- Push notifications when a new recipe is published.
- Share recipe via link or social media.
- Dark mode support.
- Recipe rating or comments from viewers.
- Dedicated web admin panel for recipe management.
- Offline mode with full image caching to disk.
- Ingredient quantity adjustment based on serving size.
- Tablet layout with responsive design.

---

## 14. Success Metrics

- Every screen loads and displays content within 2 seconds on a standard connection.
- Search returns relevant results within 300ms of Korean text input.
- Category filter chips correctly filter the recipe list with instant visual feedback.
- Recipe detail page renders completely with all content, per-step images, and ingredients.
- Admin can add a new recipe via Supabase and it appears in the app on next screen appearance.
- When offline, the app displays the last-fetched recipes and steps without crashing.
- Error messages display meaningful Korean descriptions when network requests fail.
- Analytics events fire correctly and data appears in the analytics dashboard.
- All screens pass screen reader audits with meaningful Korean labels.
- Privacy policy is accessible from the Info screen and hosted at a stable URL.
- App receives approval from the store on first submission.
