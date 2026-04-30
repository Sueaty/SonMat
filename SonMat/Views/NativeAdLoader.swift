//
//  NativeAdLoader.swift
//  SonMat
//

import Foundation
import Observation
import GoogleMobileAds

/// 네이티브 광고를 비동기 로드하는 Observable 클래스.
/// RecipeListView가 소유하며, 광고가 로드되면 SwiftUI가 자동으로 재렌더링한다.
@Observable
final class NativeAdLoader: NSObject, NativeAdLoaderDelegate {

    private(set) var nativeAds: [NativeAd] = []
    private var adLoader: AdLoader?

    /// 네이티브 광고를 최대 count개 요청한다.
    func loadAds(count: Int = 3) {
        guard nativeAds.isEmpty else { return }  // 이미 로드됐으면 재요청 생략

        let multipleAdsOptions = MultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = count

        adLoader = AdLoader(
            adUnitID: AdConfig.nativeAdUnitID,
            rootViewController: nil,
            adTypes: [.native],
            options: [multipleAdsOptions]
        )
        adLoader?.delegate = self
        adLoader?.load(Request())
    }

    // MARK: - NativeAdLoaderDelegate

    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        nativeAds.append(nativeAd)
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        // 광고 로드 실패 시 조용히 무시 — 앱 경험에 영향 없음
    }
}
