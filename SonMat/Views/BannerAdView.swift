//
//  BannerAdView.swift
//  SonMat
//
//  배너 광고 — RecipeDetailView 조리 방법 섹션 이후에 배치.
//  광고 로드 실패 시 뷰가 자동으로 숨겨져 레이아웃 영향 없음.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = AdConfig.bannerAdUnitID
        banner.delegate = context.coordinator
        return banner
    }

    func updateUIView(_ banner: BannerView, context: Context) {
        guard !context.coordinator.hasLoaded else { return }
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else { return }
        banner.rootViewController = root
        context.coordinator.hasLoaded = true
        banner.load(Request())
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, BannerViewDelegate {
        var hasLoaded = false

        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            bannerView.isHidden = false
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            bannerView.isHidden = true  // 광고 없으면 공간 차지하지 않음
        }
    }
}
