//
//  ContentView.swift
//  SonMat
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = RecipeListViewModel()
    @State private var isDataLoaded = false

    var body: some View {
        ZStack {
            TabView {
                NavigationStack {
                    RecipeListView(viewModel: viewModel)
                }
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .accessibilityLabel("홈 탭")

                NavigationStack {
                    InfoView()
                }
                .tabItem {
                    Label("정보", systemImage: "info.circle.fill")
                }
                .accessibilityLabel("정보 탭")
            }
            .tint(.accent)
            .opacity(isDataLoaded ? 1 : 0)

            if !isDataLoaded {
                SplashView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isDataLoaded)
        .task {
            async let minimumDelay: Void = Task.sleep(for: .seconds(2))
            while !viewModel.isLoading { await Task.yield() }
            while viewModel.isLoading  { await Task.yield() }
            try? await minimumDelay
            isDataLoaded = true
        }
    }
}

#Preview {
    ContentView()
}
