//
//  AdConfig.swift
//  SonMat
//

import Foundation

/// AdMob 광고 단위 ID 관리.
/// DEBUG 빌드: Google 공식 테스트 ID 사용 (실제 과금 없음)
/// RELEASE 빌드: AdMob 콘솔에서 발급받은 실제 ID로 교체 필요
enum AdConfig {
    #if DEBUG
    static let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"  // Google 공식 테스트 배너
    static let nativeAdUnitID = "ca-app-pub-3940256099942544/3986624511"  // Google 공식 테스트 네이티브
    #else
    static let bannerAdUnitID = "ca-app-pub-5256069577467700/2426107539"
    static let nativeAdUnitID = "ca-app-pub-5256069577467700/2851500010"
    #endif
}
