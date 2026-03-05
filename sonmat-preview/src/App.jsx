import { useState, useRef, useEffect } from "react";

const COLORS = {
  bg: "#FAFAF8",
  card: "#FFFFFF",
  text: "#1A1A1A",
  textSecondary: "#6B6B6B",
  textTertiary: "#9E9E9E",
  accent: "#D4603A",
  accentLight: "#FDF0EB",
  accentDark: "#B8482A",
  chipBg: "#F0EFEC",
  chipActive: "#1A1A1A",
  chipActiveText: "#FFFFFF",
  border: "#EEEDE9",
  searchBg: "#F0EFEC",
  heroOverlay: "rgba(0,0,0,0.25)",
  statusBar: "#FAFAF8",
  tabBar: "#FFFFFF",
  tabInactive: "#BABABA",
  green: "#4CAF50",
  separator: "#F0EFEC",
};

const FONTS = {
  display: "'GmarketSansMedium', 'Gmarket Sans', sans-serif",
  body: "'GmarketSansMedium', 'Gmarket Sans', sans-serif",
};

const CATEGORIES = ["전체", "한식", "양식", "일식", "중식", "디저트", "음료"];

const RECIPES = [
  {
    id: 1,
    title: "된장찌개",
    description: "구수한 된장과 신선한 채소로 만든 전통 된장찌개. 밥 한 공기가 뚝딱 사라지는 엄마의 손맛을 담았습니다.",
    category: "한식",
    prepTime: 15,
    cookTime: 25,
    servings: 2,
    thumb: "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?w=400&h=400&fit=crop",
    hero: "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?w=800&h=600&fit=crop",
    ingredients: [
      "된장 2큰술",
      "두부 1/2모",
      "감자 1개",
      "양파 1/2개",
      "애호박 1/3개",
      "청양고추 1개",
      "대파 1대",
      "다진 마늘 1작은술",
      "멸치육수 2컵",
    ],
    steps: [
      { n: 1, text: "멸치육수를 준비하고 냄비에 붓고 끓입니다.", img: null },
      { n: 2, text: "감자, 양파, 애호박을 먹기 좋은 크기로 썰어 준비합니다.", img: "https://images.unsplash.com/photo-1466637574441-749b8f19452f?w=800&h=500&fit=crop" },
      { n: 3, text: "육수가 끓으면 된장을 풀어 넣고 감자를 먼저 넣습니다.", img: null },
      { n: 4, text: "감자가 반쯤 익으면 두부, 양파, 애호박을 넣습니다.", img: "https://images.unsplash.com/photo-1547592180-85f173990554?w=800&h=500&fit=crop" },
      { n: 5, text: "다진 마늘과 청양고추를 넣고 5분간 더 끓입니다.", img: null },
      { n: 6, text: "대파를 송송 썰어 올리고 불을 끕니다.", img: null },
    ],
  },
  {
    id: 2,
    title: "크림 파스타",
    description: "부드러운 크림 소스와 탱글한 면발의 조화. 베이컨과 버섯의 풍미가 가득한 홈메이드 크림 파스타입니다.",
    category: "양식",
    prepTime: 10,
    cookTime: 20,
    servings: 2,
    thumb: "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=400&fit=crop",
    hero: "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800&h=600&fit=crop",
    ingredients: [
      "스파게티 200g",
      "베이컨 4줄",
      "양송이버섯 5개",
      "양파 1/2개",
      "생크림 200ml",
      "파마산 치즈 3큰술",
      "버터 1큰술",
      "소금, 후추 약간",
    ],
    steps: [
      { n: 1, text: "끓는 물에 소금을 넣고 스파게티를 삶습니다.", img: null },
      { n: 2, text: "베이컨과 양파를 잘게 썰어 버터에 볶습니다.", img: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&h=500&fit=crop" },
      { n: 3, text: "양송이버섯을 넣고 함께 볶습니다.", img: null },
      { n: 4, text: "생크림을 붓고 중불에서 졸입니다.", img: null },
      { n: 5, text: "삶은 면을 넣고 소스와 잘 버무립니다.", img: "https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=800&h=500&fit=crop" },
      { n: 6, text: "파마산 치즈와 후추를 뿌려 마무리합니다.", img: null },
    ],
  },
  {
    id: 3,
    title: "연어 포케 보울",
    description: "신선한 연어와 아보카도, 다양한 채소를 담은 하와이안 포케 보울. 건강하고 맛있는 한 그릇 식사입니다.",
    category: "일식",
    prepTime: 20,
    cookTime: 5,
    servings: 1,
    thumb: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=400&fit=crop",
    hero: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&h=600&fit=crop",
    ingredients: [
      "회용 연어 150g",
      "밥 1공기",
      "아보카도 1/2개",
      "오이 1/3개",
      "당근 1/4개",
      "에다마메 한 줌",
      "간장 2큰술",
      "참기름 1작은술",
      "와사비 약간",
    ],
    steps: [
      { n: 1, text: "연어를 한 입 크기로 깍둑썰기 합니다.", img: null },
      { n: 2, text: "간장, 참기름, 와사비를 섞어 양념장을 만듭니다.", img: null },
      { n: 3, text: "연어에 양념장을 넣고 가볍게 버무립니다.", img: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800&h=500&fit=crop" },
      { n: 4, text: "그릇에 밥을 담고 채소와 연어를 올립니다.", img: null },
    ],
  },
  {
    id: 4,
    title: "마라탕",
    description: "얼얼하고 화끈한 마라 소스에 각종 채소와 고기를 넣어 끓인 정통 마라탕. 중독성 있는 매운맛을 즐겨보세요.",
    category: "중식",
    prepTime: 15,
    cookTime: 30,
    servings: 2,
    thumb: "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=400&fit=crop",
    hero: "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800&h=600&fit=crop",
    ingredients: [
      "마라 소스 3큰술",
      "소고기 150g",
      "청경채 2포기",
      "팽이버섯 1봉",
      "두부 1/2모",
      "당면 50g",
      "치킨 스톡 3컵",
    ],
    steps: [
      { n: 1, text: "당면을 미지근한 물에 불려 둡니다.", img: null },
      { n: 2, text: "냄비에 기름을 두르고 마라 소스를 볶아 향을 냅니다.", img: null },
      { n: 3, text: "치킨 스톡을 붓고 끓입니다.", img: null },
      { n: 4, text: "소고기, 두부, 채소, 당면을 넣고 끓입니다.", img: "https://images.unsplash.com/photo-1555126634-323283e090fa?w=800&h=500&fit=crop" },
    ],
  },
  {
    id: 5,
    title: "바스크 치즈케이크",
    description: "겉은 카라멜처럼 그을리고 속은 부드럽고 촉촉한 바스크 치즈케이크. 초보자도 쉽게 만들 수 있는 디저트입니다.",
    category: "디저트",
    prepTime: 15,
    cookTime: 35,
    servings: 6,
    thumb: "https://images.unsplash.com/photo-1508737027454-e6454ef45adb?w=400&h=400&fit=crop",
    hero: "https://images.unsplash.com/photo-1508737027454-e6454ef45adb?w=800&h=600&fit=crop",
    ingredients: [
      "크림치즈 400g",
      "설탕 120g",
      "달걀 3개",
      "생크림 200ml",
      "박력분 1큰술",
      "바닐라 에센스 약간",
    ],
    steps: [
      { n: 1, text: "크림치즈를 실온에 두어 부드럽게 합니다.", img: null },
      { n: 2, text: "크림치즈에 설탕을 넣고 잘 섞습니다.", img: null },
      { n: 3, text: "달걀을 하나씩 넣으며 섞습니다.", img: "https://images.unsplash.com/photo-1495147466023-ac5c588e2e94?w=800&h=500&fit=crop" },
      { n: 4, text: "생크림, 박력분, 바닐라를 넣고 섞습니다.", img: null },
      { n: 5, text: "220°C 오븐에서 35분간 구워 완성합니다.", img: null },
    ],
  },
  {
    id: 6,
    title: "아이스 말차 라떼",
    description: "진한 말차와 고소한 우유의 완벽한 조화. 카페 못지않은 비주얼과 맛의 홈카페 말차 라떼입니다.",
    category: "음료",
    prepTime: 5,
    cookTime: 0,
    servings: 1,
    thumb: "https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400&h=400&fit=crop",
    hero: "https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=800&h=600&fit=crop",
    ingredients: [
      "말차 가루 2작은술",
      "뜨거운 물 30ml",
      "우유 200ml",
      "얼음 적당량",
      "시럽 1큰술 (선택)",
    ],
    steps: [
      { n: 1, text: "말차 가루에 뜨거운 물을 넣고 잘 풀어줍니다.", img: null },
      { n: 2, text: "컵에 얼음을 가득 채웁니다.", img: null },
      { n: 3, text: "차가운 우유를 붓고 말차를 천천히 올립니다.", img: "https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=800&h=500&fit=crop" },
    ],
  },
];

// iPhone frame component
const IPhoneFrame = ({ children, statusBarColor = COLORS.statusBar }) => (
  <div
    style={{
      width: 393,
      height: 852,
      borderRadius: 48,
      background: "#000",
      padding: 4,
      position: "relative",
      boxShadow:
        "0 50px 100px rgba(0,0,0,0.25), 0 20px 60px rgba(0,0,0,0.2), inset 0 0 0 1px rgba(255,255,255,0.1)",
      flexShrink: 0,
    }}
  >
    {/* Inner frame */}
    <div
      style={{
        width: "100%",
        height: "100%",
        borderRadius: 44,
        overflow: "hidden",
        position: "relative",
        background: COLORS.bg,
      }}
    >
      {/* Status Bar */}
      <div
        style={{
          height: 54,
          background: statusBarColor,
          display: "flex",
          alignItems: "flex-end",
          justifyContent: "space-between",
          padding: "0 32px 8px",
          position: "relative",
          zIndex: 100,
        }}
      >
        <span style={{ fontSize: 15, fontWeight: 600, fontFamily: FONTS.body, color: COLORS.text }}>
          9:41
        </span>
        {/* Dynamic Island */}
        <div
          style={{
            position: "absolute",
            top: 12,
            left: "50%",
            transform: "translateX(-50%)",
            width: 126,
            height: 36,
            background: "#000",
            borderRadius: 20,
          }}
        />
        <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
          <svg width="17" height="12" viewBox="0 0 17 12" fill="none">
            <rect x="0" y="3" width="3" height="9" rx="1" fill={COLORS.text} />
            <rect x="4.5" y="2" width="3" height="10" rx="1" fill={COLORS.text} />
            <rect x="9" y="0" width="3" height="12" rx="1" fill={COLORS.text} />
            <rect x="13.5" y="0" width="3" height="12" rx="1" fill={COLORS.text} opacity="0.3" />
          </svg>
          <svg width="15" height="12" viewBox="0 0 15 12" fill={COLORS.text}>
            <path d="M7.5 2.5C9.4 2.5 11.1 3.3 12.3 4.5L13.7 3.1C12.1 1.5 10 0.5 7.5 0.5C5 0.5 2.9 1.5 1.3 3.1L2.7 4.5C3.9 3.3 5.6 2.5 7.5 2.5ZM7.5 6.5C8.6 6.5 9.6 6.9 10.4 7.6L11.8 6.2C10.6 5.1 9.1 4.5 7.5 4.5C5.9 4.5 4.4 5.1 3.2 6.2L4.6 7.6C5.4 6.9 6.4 6.5 7.5 6.5ZM9.5 10L7.5 12L5.5 10C6.1 9.4 6.8 9 7.5 9C8.2 9 8.9 9.4 9.5 10Z" />
          </svg>
          <svg width="27" height="12" viewBox="0 0 27 12" fill="none">
            <rect x="0" y="0" width="23" height="12" rx="3" stroke={COLORS.text} strokeWidth="1" />
            <rect x="1.5" y="1.5" width="17" height="9" rx="1.5" fill={COLORS.green} />
            <rect x="24" y="3.5" width="3" height="5" rx="1" fill={COLORS.text} />
          </svg>
        </div>
      </div>
      {/* Content */}
      <div style={{ height: "calc(100% - 54px)", overflow: "hidden", position: "relative" }}>
        {children}
      </div>
    </div>
  </div>
);

// Tab bar
const TabBar = ({ activeTab, onTabChange }) => (
  <div
    style={{
      position: "absolute",
      bottom: 0,
      left: 0,
      right: 0,
      height: 88,
      background: COLORS.tabBar,
      borderTop: `0.5px solid ${COLORS.border}`,
      display: "flex",
      alignItems: "flex-start",
      justifyContent: "space-around",
      paddingTop: 8,
      paddingBottom: 34,
      zIndex: 50,
    }}
  >
    {[
      {
        label: "홈",
        icon: (active) => (
          <svg width="24" height="24" fill={active ? COLORS.accent : COLORS.tabInactive} viewBox="0 0 24 24">
            <path d="M3 12.5L12 3l9 9.5v8.5a1 1 0 01-1 1h-5v-6h-6v6H4a1 1 0 01-1-1V12.5z" />
          </svg>
        ),
      },
      {
        label: "정보",
        icon: (active) => (
          <svg width="24" height="24" fill={active ? COLORS.accent : COLORS.tabInactive} viewBox="0 0 24 24">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z" />
          </svg>
        ),
      },
    ].map((tab, i) => (
      <button
        key={i}
        onClick={() => onTabChange(i)}
        style={{
          background: "none",
          border: "none",
          cursor: "pointer",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          gap: 2,
          padding: 0,
        }}
      >
        {tab.icon(activeTab === i)}
        <span
          style={{
            fontSize: 10,
            fontFamily: FONTS.body,
            color: activeTab === i ? COLORS.accent : COLORS.tabInactive,
            fontWeight: activeTab === i ? 600 : 400,
          }}
        >
          {tab.label}
        </span>
      </button>
    ))}
  </div>
);

// Category chips
const CategoryChips = ({ selected, onSelect }) => (
  <div
    style={{
      display: "flex",
      gap: 8,
      overflowX: "auto",
      padding: "0 20px 12px",
      scrollbarWidth: "none",
    }}
  >
    {CATEGORIES.map((cat) => (
      <button
        key={cat}
        onClick={() => onSelect(cat)}
        style={{
          background: selected === cat ? COLORS.chipActive : COLORS.chipBg,
          color: selected === cat ? COLORS.chipActiveText : COLORS.text,
          border: "none",
          borderRadius: 20,
          padding: "7px 16px",
          fontSize: 13,
          fontFamily: FONTS.body,
          fontWeight: 500,
          cursor: "pointer",
          whiteSpace: "nowrap",
          flexShrink: 0,
          transition: "all 0.2s ease",
        }}
      >
        {cat}
      </button>
    ))}
  </div>
);

// Recipe card
const RecipeCard = ({ recipe, onClick }) => (
  <button
    onClick={onClick}
    style={{
      display: "flex",
      gap: 14,
      padding: "14px 20px",
      background: "none",
      border: "none",
      cursor: "pointer",
      width: "100%",
      textAlign: "left",
      borderBottom: `0.5px solid ${COLORS.separator}`,
    }}
  >
    <img
      src={recipe.thumb}
      alt={recipe.title}
      style={{
        width: 80,
        height: 80,
        borderRadius: 14,
        objectFit: "cover",
        flexShrink: 0,
      }}
    />
    <div style={{ flex: 1, display: "flex", flexDirection: "column", justifyContent: "center", gap: 6 }}>
      <span
        style={{
          fontSize: 16,
          fontWeight: 600,
          fontFamily: FONTS.body,
          color: COLORS.text,
          lineHeight: 1.3,
        }}
      >
        {recipe.title}
      </span>
      <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
        <span
          style={{
            fontSize: 11,
            fontFamily: FONTS.body,
            color: COLORS.accent,
            fontWeight: 600,
            background: COLORS.accentLight,
            padding: "3px 8px",
            borderRadius: 6,
          }}
        >
          {recipe.category}
        </span>
        <span style={{ fontSize: 12, fontFamily: FONTS.body, color: COLORS.textTertiary }}>
          {recipe.prepTime + recipe.cookTime}분
        </span>
      </div>
      <span
        style={{
          fontSize: 13,
          fontFamily: FONTS.body,
          color: COLORS.textSecondary,
          lineHeight: 1.4,
          display: "-webkit-box",
          WebkitLineClamp: 1,
          WebkitBoxOrient: "vertical",
          overflow: "hidden",
        }}
      >
        {recipe.description}
      </span>
    </div>
  </button>
);

// Home screen
const HomeScreen = ({ onSelectRecipe, searchQuery, setSearchQuery, selectedCategory, setSelectedCategory }) => {
  const filtered = RECIPES.filter((r) => {
    const catMatch = selectedCategory === "전체" || r.category === selectedCategory;
    const searchMatch = !searchQuery || r.title.includes(searchQuery);
    return catMatch && searchMatch;
  });

  return (
    <div style={{ height: "100%", display: "flex", flexDirection: "column" }}>
      {/* Header */}
      <div style={{ padding: "6px 20px 4px" }}>
        <h1
          style={{
            fontFamily: FONTS.display,
            fontSize: 26,
            fontWeight: 700,
            color: COLORS.text,
            margin: 0,
            letterSpacing: -0.5,
          }}
        >
          손맛
        </h1>
        <p
          style={{
            fontFamily: FONTS.body,
            fontSize: 13,
            color: COLORS.textTertiary,
            margin: "2px 0 0",
          }}
        >
          정성이 담긴 레시피 모음
        </p>
      </div>

      {/* Search bar */}
      <div style={{ padding: "10px 20px 8px" }}>
        <div
          style={{
            display: "flex",
            alignItems: "center",
            background: COLORS.searchBg,
            borderRadius: 12,
            padding: "10px 14px",
            gap: 8,
          }}
        >
          <svg width="16" height="16" fill={COLORS.textTertiary} viewBox="0 0 24 24">
            <path d="M15.5 14h-.79l-.28-.27A6.47 6.47 0 0016 9.5 6.5 6.5 0 109.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" />
          </svg>
          <input
            type="text"
            placeholder="레시피 검색..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            style={{
              border: "none",
              background: "none",
              outline: "none",
              fontSize: 15,
              fontFamily: FONTS.body,
              color: COLORS.text,
              width: "100%",
            }}
          />
          {searchQuery && (
            <button
              onClick={() => setSearchQuery("")}
              style={{
                background: COLORS.textTertiary,
                border: "none",
                borderRadius: 10,
                width: 20,
                height: 20,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                cursor: "pointer",
                flexShrink: 0,
              }}
            >
              <svg width="10" height="10" fill="#fff" viewBox="0 0 24 24">
                <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z" />
              </svg>
            </button>
          )}
        </div>
      </div>

      {/* Category chips */}
      <CategoryChips selected={selectedCategory} onSelect={setSelectedCategory} />

      {/* Recipe list */}
      <div style={{ flex: 1, overflowY: "auto", paddingBottom: 88 }}>
        {filtered.length > 0 ? (
          filtered.map((recipe) => (
            <RecipeCard key={recipe.id} recipe={recipe} onClick={() => onSelectRecipe(recipe)} />
          ))
        ) : (
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              justifyContent: "center",
              padding: "60px 40px",
              textAlign: "center",
            }}
          >
            <div style={{ fontSize: 48, marginBottom: 16 }}>🍳</div>
            <p
              style={{
                fontFamily: FONTS.body,
                fontSize: 16,
                fontWeight: 600,
                color: COLORS.text,
                margin: "0 0 8px",
              }}
            >
              검색 결과 없음
            </p>
            <p style={{ fontFamily: FONTS.body, fontSize: 14, color: COLORS.textSecondary, margin: 0 }}>
              다른 검색어로 다시 시도해 보세요
            </p>
          </div>
        )}
      </div>
    </div>
  );
};

// Detail screen
const DetailScreen = ({ recipe, onBack }) => (
  <div style={{ height: "100%", overflowY: "auto" }}>
    {/* Hero image */}
    <div style={{ position: "relative", width: "100%", height: 300 }}>
      <img
        src={recipe.hero}
        alt={recipe.title}
        style={{ width: "100%", height: "100%", objectFit: "cover" }}
      />
      <div
        style={{
          position: "absolute",
          inset: 0,
          background: "linear-gradient(180deg, rgba(0,0,0,0.35) 0%, transparent 40%, transparent 60%, rgba(0,0,0,0.5) 100%)",
        }}
      />
      <button
        onClick={onBack}
        style={{
          position: "absolute",
          top: 8,
          left: 12,
          width: 36,
          height: 36,
          borderRadius: 18,
          background: "rgba(255,255,255,0.2)",
          backdropFilter: "blur(10px)",
          WebkitBackdropFilter: "blur(10px)",
          border: "none",
          cursor: "pointer",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <svg width="20" height="20" fill="#fff" viewBox="0 0 24 24">
          <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z" />
        </svg>
      </button>
      <div style={{ position: "absolute", bottom: 20, left: 20, right: 20 }}>
        <span
          style={{
            fontSize: 12,
            fontFamily: FONTS.body,
            fontWeight: 600,
            color: "#fff",
            background: COLORS.accent,
            padding: "4px 10px",
            borderRadius: 8,
          }}
        >
          {recipe.category}
        </span>
        <h2
          style={{
            fontFamily: FONTS.display,
            fontSize: 28,
            fontWeight: 700,
            color: "#fff",
            margin: "10px 0 0",
            textShadow: "0 1px 4px rgba(0,0,0,0.3)",
          }}
        >
          {recipe.title}
        </h2>
      </div>
    </div>

    {/* Metadata row */}
    <div
      style={{
        display: "flex",
        justifyContent: "space-around",
        padding: "16px 20px",
        borderBottom: `0.5px solid ${COLORS.separator}`,
      }}
    >
      {[
        { label: "준비 시간", value: `${recipe.prepTime}분` },
        { label: "조리 시간", value: `${recipe.cookTime}분` },
        { label: "인분", value: `${recipe.servings}인분` },
      ].map((item, i) => (
        <div key={i} style={{ textAlign: "center" }}>
          <p style={{ fontFamily: FONTS.body, fontSize: 11, color: COLORS.textTertiary, margin: "0 0 2px" }}>
            {item.label}
          </p>
          <p style={{ fontFamily: FONTS.body, fontSize: 16, fontWeight: 700, color: COLORS.text, margin: 0 }}>
            {item.value}
          </p>
        </div>
      ))}
    </div>

    {/* Description */}
    <div style={{ padding: "16px 20px" }}>
      <p style={{ fontFamily: FONTS.body, fontSize: 14, color: COLORS.textSecondary, lineHeight: 1.7, margin: 0 }}>
        {recipe.description}
      </p>
    </div>

    {/* Ingredients */}
    <div style={{ padding: "4px 20px 16px" }}>
      <h3
        style={{
          fontFamily: FONTS.display,
          fontSize: 18,
          fontWeight: 700,
          color: COLORS.text,
          margin: "0 0 12px",
        }}
      >
        재료
      </h3>
      <div
        style={{
          background: COLORS.chipBg,
          borderRadius: 14,
          padding: "14px 16px",
          display: "flex",
          flexDirection: "column",
          gap: 10,
        }}
      >
        {recipe.ingredients.map((ing, i) => (
          <div
            key={i}
            style={{
              display: "flex",
              alignItems: "center",
              gap: 10,
              borderBottom: i < recipe.ingredients.length - 1 ? `0.5px solid ${COLORS.border}` : "none",
              paddingBottom: i < recipe.ingredients.length - 1 ? 10 : 0,
            }}
          >
            <div
              style={{
                width: 6,
                height: 6,
                borderRadius: 3,
                background: COLORS.accent,
                flexShrink: 0,
              }}
            />
            <span style={{ fontFamily: FONTS.body, fontSize: 14, color: COLORS.text }}>{ing}</span>
          </div>
        ))}
      </div>
    </div>

    {/* Steps */}
    <div style={{ padding: "4px 20px 120px" }}>
      <h3
        style={{
          fontFamily: FONTS.display,
          fontSize: 18,
          fontWeight: 700,
          color: COLORS.text,
          margin: "0 0 16px",
        }}
      >
        조리 방법
      </h3>
      <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
        {recipe.steps.map((step, i) => (
          <div key={i}>
            <div style={{ display: "flex", gap: 12, alignItems: "flex-start" }}>
              <div
                style={{
                  width: 28,
                  height: 28,
                  borderRadius: 14,
                  background: COLORS.accent,
                  color: "#fff",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  fontSize: 13,
                  fontWeight: 700,
                  fontFamily: FONTS.body,
                  flexShrink: 0,
                }}
              >
                {step.n}
              </div>
              <p
                style={{
                  fontFamily: FONTS.body,
                  fontSize: 14,
                  color: COLORS.text,
                  lineHeight: 1.7,
                  margin: 0,
                  paddingTop: 3,
                }}
              >
                {step.text}
              </p>
            </div>
            {step.img && (
              <img
                src={step.img}
                alt={`Step ${step.n}`}
                style={{
                  width: "100%",
                  height: 180,
                  objectFit: "cover",
                  borderRadius: 14,
                  marginTop: 10,
                  marginLeft: 40,
                  maxWidth: "calc(100% - 40px)",
                }}
              />
            )}
          </div>
        ))}
      </div>
    </div>
  </div>
);

// Info screen
const InfoScreen = () => (
  <div style={{ height: "100%", display: "flex", flexDirection: "column" }}>
    <div style={{ padding: "6px 20px 16px" }}>
      <h1
        style={{
          fontFamily: FONTS.display,
          fontSize: 26,
          fontWeight: 700,
          color: COLORS.text,
          margin: 0,
        }}
      >
        정보
      </h1>
    </div>
    <div style={{ flex: 1, padding: "0 20px", paddingBottom: 88 }}>
      {/* App info card */}
      <div
        style={{
          background: COLORS.card,
          borderRadius: 16,
          padding: "24px 20px",
          textAlign: "center",
          marginBottom: 16,
          border: `0.5px solid ${COLORS.border}`,
        }}
      >
        <div
          style={{
            width: 72,
            height: 72,
            borderRadius: 18,
            background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentDark})`,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            margin: "0 auto 12px",
          }}
        >
          <span style={{ fontSize: 32, color: "#fff", fontFamily: FONTS.display, fontWeight: 700 }}>손</span>
        </div>
        <h2 style={{ fontFamily: FONTS.display, fontSize: 20, fontWeight: 700, color: COLORS.text, margin: "0 0 4px" }}>
          손맛
        </h2>
        <p style={{ fontFamily: FONTS.body, fontSize: 13, color: COLORS.textTertiary, margin: 0 }}>
          버전 1.0.0
        </p>
      </div>

      {/* Settings list */}
      <div
        style={{
          background: COLORS.card,
          borderRadius: 16,
          overflow: "hidden",
          border: `0.5px solid ${COLORS.border}`,
        }}
      >
        {[
          { icon: "🔒", label: "개인정보 처리방침", sub: "개인정보 보호 및 처리에 관한 안내" },
          { icon: "📋", label: "이용약관", sub: "서비스 이용 약관 안내" },
          { icon: "✉️", label: "문의하기", sub: "의견이나 건의사항을 보내주세요" },
        ].map((item, i) => (
          <div
            key={i}
            style={{
              display: "flex",
              alignItems: "center",
              padding: "14px 16px",
              gap: 12,
              borderBottom: i < 2 ? `0.5px solid ${COLORS.separator}` : "none",
              cursor: "pointer",
            }}
          >
            <span style={{ fontSize: 20 }}>{item.icon}</span>
            <div style={{ flex: 1 }}>
              <p style={{ fontFamily: FONTS.body, fontSize: 15, fontWeight: 500, color: COLORS.text, margin: 0 }}>
                {item.label}
              </p>
              <p style={{ fontFamily: FONTS.body, fontSize: 12, color: COLORS.textTertiary, margin: "2px 0 0" }}>
                {item.sub}
              </p>
            </div>
            <svg width="16" height="16" fill={COLORS.textTertiary} viewBox="0 0 24 24">
              <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6z" />
            </svg>
          </div>
        ))}
      </div>

      <p
        style={{
          fontFamily: FONTS.body,
          fontSize: 11,
          color: COLORS.textTertiary,
          textAlign: "center",
          margin: "20px 0 0",
        }}
      >
        © 2026 손맛. All rights reserved.
      </p>
    </div>
  </div>
);

// Empty state screen (for preview)
const EmptyStateScreen = () => (
  <div style={{ height: "100%", display: "flex", flexDirection: "column" }}>
    <div style={{ padding: "6px 20px 4px" }}>
      <h1 style={{ fontFamily: FONTS.display, fontSize: 26, fontWeight: 700, color: COLORS.text, margin: 0 }}>
        손맛
      </h1>
      <p style={{ fontFamily: FONTS.body, fontSize: 13, color: COLORS.textTertiary, margin: "2px 0 0" }}>
        정성이 담긴 레시피 모음
      </p>
    </div>
    <div style={{ padding: "10px 20px 8px" }}>
      <div
        style={{
          display: "flex",
          alignItems: "center",
          background: COLORS.searchBg,
          borderRadius: 12,
          padding: "10px 14px",
          gap: 8,
        }}
      >
        <svg width="16" height="16" fill={COLORS.textTertiary} viewBox="0 0 24 24">
          <path d="M15.5 14h-.79l-.28-.27A6.47 6.47 0 0016 9.5 6.5 6.5 0 109.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" />
        </svg>
        <span style={{ fontSize: 15, fontFamily: FONTS.body, color: COLORS.textTertiary }}>레시피 검색...</span>
      </div>
    </div>
    <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center", padding: "0 40px" }}>
      <div style={{ textAlign: "center" }}>
        <div style={{ fontSize: 64, marginBottom: 16 }}>🍲</div>
        <p style={{ fontFamily: FONTS.body, fontSize: 17, fontWeight: 700, color: COLORS.text, margin: "0 0 8px" }}>
          아직 레시피가 없습니다
        </p>
        <p style={{ fontFamily: FONTS.body, fontSize: 14, color: COLORS.textSecondary, margin: 0, lineHeight: 1.6 }}>
          곧 맛있는 요리가 추가될 예정이에요!
        </p>
      </div>
    </div>
  </div>
);

// Screen selector
const ScreenNav = ({ screens, active, onSelect }) => (
  <div style={{ display: "flex", gap: 6, flexWrap: "wrap", justifyContent: "center" }}>
    {screens.map((s) => (
      <button
        key={s.id}
        onClick={() => onSelect(s.id)}
        style={{
          padding: "8px 16px",
          borderRadius: 10,
          border: "none",
          background: active === s.id ? COLORS.chipActive : "#E8E7E3",
          color: active === s.id ? "#fff" : COLORS.text,
          fontFamily: FONTS.body,
          fontSize: 13,
          fontWeight: 500,
          cursor: "pointer",
          transition: "all 0.2s ease",
        }}
      >
        {s.label}
      </button>
    ))}
  </div>
);

export default function SonMatDesign() {
  const [activeScreen, setActiveScreen] = useState("home");
  const [selectedRecipe, setSelectedRecipe] = useState(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("전체");
  const [activeTab, setActiveTab] = useState(0);

  const screens = [
    { id: "home", label: "홈 (Home)" },
    { id: "detail", label: "상세 (Detail)" },
    { id: "empty", label: "빈 화면 (Empty)" },
    { id: "info", label: "정보 (Info)" },
  ];

  const handleSelectRecipe = (recipe) => {
    setSelectedRecipe(recipe);
    setActiveScreen("detail");
  };

  const handleBack = () => {
    setActiveScreen("home");
    setActiveTab(0);
  };

  useEffect(() => {
    if (activeScreen === "info") setActiveTab(1);
    else if (activeScreen !== "detail") setActiveTab(0);
  }, [activeScreen]);

  const renderScreen = () => {
    switch (activeScreen) {
      case "detail":
        return <DetailScreen recipe={selectedRecipe || RECIPES[0]} onBack={handleBack} />;
      case "empty":
        return (
          <>
            <EmptyStateScreen />
            <TabBar activeTab={0} onTabChange={() => { }} />
          </>
        );
      case "info":
        return (
          <>
            <InfoScreen />
            <TabBar activeTab={1} onTabChange={(t) => { setActiveTab(t); if (t === 0) setActiveScreen("home"); }} />
          </>
        );
      default:
        return (
          <>
            <HomeScreen
              onSelectRecipe={handleSelectRecipe}
              searchQuery={searchQuery}
              setSearchQuery={setSearchQuery}
              selectedCategory={selectedCategory}
              setSelectedCategory={setSelectedCategory}
            />
            <TabBar
              activeTab={0}
              onTabChange={(t) => { setActiveTab(t); if (t === 1) setActiveScreen("info"); }}
            />
          </>
        );
    }
  };

  return (
    <div
      style={{
        minHeight: "100vh",
        background: "linear-gradient(135deg, #1a1714 0%, #2a2520 50%, #1a1714 100%)",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        padding: "40px 20px 60px",
        gap: 32,
        fontFamily: FONTS.body,
      }}
    >
      {/* Title */}
      <div style={{ textAlign: "center", maxWidth: 500 }}>
        <p
          style={{
            fontFamily: FONTS.body,
            fontSize: 12,
            fontWeight: 600,
            letterSpacing: 3,
            color: COLORS.accent,
            textTransform: "uppercase",
            margin: "0 0 8px",
          }}
        >
          iOS Design Preview
        </p>
        <h1
          style={{
            fontFamily: FONTS.display,
            fontSize: 36,
            fontWeight: 700,
            color: "#F5F0E8",
            margin: "0 0 8px",
            letterSpacing: -1,
          }}
        >
          손맛 <span style={{ fontSize: 20, fontWeight: 400, color: "#9E9690" }}>SonMat</span>
        </h1>
        <p style={{ fontFamily: FONTS.body, fontSize: 14, color: "#9E9690", margin: 0 }}>
          정성이 담긴 레시피 앱 — A personal recipe collection
        </p>
      </div>

      {/* Screen navigation */}
      <ScreenNav screens={screens} active={activeScreen} onSelect={setActiveScreen} />

      {/* Phone */}
      <IPhoneFrame statusBarColor={activeScreen === "detail" ? "transparent" : COLORS.statusBar}>
        {renderScreen()}
      </IPhoneFrame>

      {/* Design notes */}
      <div
        style={{
          maxWidth: 440,
          padding: "20px 24px",
          background: "rgba(255,255,255,0.04)",
          borderRadius: 16,
          border: "1px solid rgba(255,255,255,0.06)",
        }}
      >
        <p style={{ fontFamily: FONTS.body, fontSize: 12, fontWeight: 600, color: COLORS.accent, margin: "0 0 8px", letterSpacing: 1.5, textTransform: "uppercase" }}>
          Design System
        </p>
        <div style={{ display: "flex", gap: 20, flexWrap: "wrap" }}>
          <div>
            <p style={{ fontSize: 11, color: "#6B6560", margin: "0 0 6px", fontFamily: FONTS.body }}>Colors</p>
            <div style={{ display: "flex", gap: 6 }}>
              {[COLORS.accent, COLORS.accentDark, COLORS.text, COLORS.chipBg, COLORS.bg].map((c, i) => (
                <div
                  key={i}
                  style={{
                    width: 24,
                    height: 24,
                    borderRadius: 6,
                    background: c,
                    border: "1px solid rgba(255,255,255,0.1)",
                  }}
                />
              ))}
            </div>
          </div>
          <div>
            <p style={{ fontSize: 11, color: "#6B6560", margin: "0 0 6px", fontFamily: FONTS.body }}>Typography</p>
            <p style={{ fontSize: 12, color: "#9E9690", margin: 0, fontFamily: FONTS.body }}>
              Gmarket Sans
            </p>
          </div>
          <div>
            <p style={{ fontSize: 11, color: "#6B6560", margin: "0 0 6px", fontFamily: FONTS.body }}>Platform</p>
            <p style={{ fontSize: 12, color: "#9E9690", margin: 0, fontFamily: FONTS.body }}>
              iOS 18+ · SwiftUI · HIG
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}