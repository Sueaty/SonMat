import SwiftUI

// MARK: - SplashView
/// A branded splash screen that displays the 손맛 logo inside an accent gradient
/// rounded rectangle, with a bouncing dot loader. Remains visible until data
/// has finished loading from Supabase, then cross-fades into the main content.
///
/// Usage (in your root App or container view):
/// ```
/// @State private var isDataLoaded = false
///
/// var body: some View {
///     ZStack {
///         MainTabView()           // your main app content
///             .opacity(isDataLoaded ? 1 : 0)
///
///         if !isDataLoaded {
///             SplashView()
///                 .transition(.opacity)
///         }
///     }
///     .animation(.easeInOut(duration: 0.5), value: isDataLoaded)
///     .task {
///         await loadData()        // your Supabase fetch
///         isDataLoaded = true
///     }
/// }
/// ```

struct SplashView: View {

    // MARK: - Design tokens (from PRD §6.0)

    private let backgroundColor = Color(hex: "FAFAF8")
    private let accentColor     = Color(hex: "D4603A")
    private let accentDark      = Color(hex: "B8482A")
    private let textTertiary    = Color(hex: "9E9E9E")

    // MARK: - Animation state

    @State private var dotPhases: [Bool] = [false, false, false]
    @State private var logoAppeared = false

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo icon — gradient rounded rect with "손맛" inside
                logoIcon
                    .scaleEffect(logoAppeared ? 1.0 : 0.85)
                    .opacity(logoAppeared ? 1.0 : 0.0)

                Spacer()

                // Loading indicator
                loadingIndicator
                    .padding(.bottom, 80)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                logoAppeared = true
            }
            startBouncingDots()
        }
    }

    // MARK: - Logo icon

    private var logoIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [accentColor, accentDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)
                .shadow(color: accentColor.opacity(0.3), radius: 16, x: 0, y: 4)

            Text("손맛")
                .font(.custom("GmarketSansMedium", size: 40))
                .foregroundStyle(.white)
                .kerning(-1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("손맛 앱 로고")
    }

    // MARK: - Loading indicator

    private var loadingIndicator: some View {
        VStack(spacing: 10) {
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(accentColor)
                        .frame(width: 6, height: 6)
                        .offset(y: dotPhases[index] ? -8 : 0)
                        .opacity(dotPhases[index] ? 1.0 : 0.4)
                }
            }

            Text("레시피를 불러오는 중...")
                .font(.custom("GmarketSansMedium", size: 12))
                .foregroundStyle(textTertiary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("레시피를 불러오는 중")
    }

    // MARK: - Dot animation

    private func startBouncingDots() {
        for index in 0..<3 {
            let delay = Double(index) * 0.2
            Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
                animateDot(at: index)
            }
        }
    }

    private func animateDot(at index: Int) {
        withAnimation(
            .easeInOut(duration: 0.4)
            .repeatForever(autoreverses: true)
        ) {
            dotPhases[index] = true
        }
    }
}
