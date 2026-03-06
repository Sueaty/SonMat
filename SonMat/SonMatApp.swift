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
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RecipeCache.self,
            StepCache.self,
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
            case .active:   AnalyticsService.logSessionStart()
            case .background: AnalyticsService.logSessionEnd()
            default: break
            }
        }
    }
}
