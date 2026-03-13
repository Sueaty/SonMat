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
            NavigationStack {
                RecipeListView(viewModel: viewModel)
            }
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
