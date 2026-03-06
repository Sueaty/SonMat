//
//  SonMatApp.swift
//  SonMat
//
//  Created by 조수정 on 3/6/26.
//

import SwiftUI
import SwiftData
import CoreText

@main
struct SonMatApp: App {
    init() {
        if let url = Bundle.main.url(forResource: "GmarketSansMedium", withExtension: "otf") {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
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
    }
}
