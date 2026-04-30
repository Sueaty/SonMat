//
//  SonMatApp.swift
//  SonMat
//
//  Created by 조수정 on 3/6/26.
//

import SwiftUI
import SwiftData
import CoreText
import FirebaseCore
import GoogleMobileAds
import AppTrackingTransparency

@main
struct SonMatApp: App {
    @Environment(\.scenePhase) private var scenePhase

    init() {
        if let url = Bundle.main.url(forResource: "GmarketSansMedium", withExtension: "otf") {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
        }
        // AdMob SDK 초기화 (앱 시작 시 즉시 호출 필요)
        MobileAds.shared.start()
    }

    /// ATT(앱 추적 투명성) 권한을 최초 1회만 요청한다.
    /// iOS 14+ 요구 사항이며, 개인화 광고 여부를 결정한다.
    private func requestTrackingPermissionIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: "hasRequestedTracking") else { return }
        UserDefaults.standard.set(true, forKey: "hasRequestedTracking")
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1))  // 앱 UI가 준비된 후 팝업 표시
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RecipeCache.self,
            StepCache.self,
            SavedRecipeCache.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:
                AnalyticsService.logSessionStart()
                requestTrackingPermissionIfNeeded()
            case .background:
                AnalyticsService.logSessionEnd()
            default: break
            }
        }
    }
}
