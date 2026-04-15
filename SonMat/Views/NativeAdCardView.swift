//
//  NativeAdCardView.swift
//  SonMat
//
//  RecipeCardView와 동일한 레이아웃의 네이티브 광고 카드.
//  NativeAdView(UIKit)를 UIViewRepresentable로 래핑.
//

import SwiftUI
import GoogleMobileAds

// MARK: - SwiftUI 래퍼

struct NativeAdCardView: UIViewRepresentable {
    let nativeAd: NativeAd

    func makeUIView(context: Context) -> SonMatNativeAdView {
        SonMatNativeAdView()
    }

    func updateUIView(_ view: SonMatNativeAdView, context: Context) {
        view.populate(with: nativeAd)
    }
}

// MARK: - UIKit 네이티브 광고 뷰

/// RecipeCardView와 동일한 레이아웃:
/// [미디어 100×100] | 제목(헤드라인) / 광고 뱃지 / 본문(2줄)
final class SonMatNativeAdView: NativeAdView {

    // MARK: - 컬러 헬퍼

    private static func dynamic(light: String, dark: String) -> UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(hexString: dark)
                : UIColor(hexString: light)
        }
    }

    // MARK: - UI 컴포넌트

    private let mediaContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 14
        view.backgroundColor = SonMatNativeAdView.dynamic(light: "EFEBE4", dark: "2C2B28")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var mediaView_: MediaView = {
        let view = MediaView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GmarketSansMedium", size: 16)
            ?? .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = SonMatNativeAdView.dynamic(light: "2B2520", dark: "F2EDE8")
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adBadgeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = SonMatNativeAdView.dynamic(light: "FDF0EB", dark: "3D2318")
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let adBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "광고"
        label.font = UIFont(name: "GmarketSansMedium", size: 11)
            ?? .systemFont(ofSize: 11, weight: .bold)
        label.textColor = SonMatNativeAdView.dynamic(light: "C4533A", dark: "E07550")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GmarketSansMedium", size: 13)
            ?? .systemFont(ofSize: 13)
        label.textColor = SonMatNativeAdView.dynamic(light: "6B6158", dark: "A8A8A8")
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var adChoices_: AdChoicesView = {
        let view = AdChoicesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = SonMatNativeAdView.dynamic(light: "E8E4DC", dark: "3A3936")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: - 레이아웃 설정

    private func setupViewsAndConstraints() {
        backgroundColor = .clear

        // NativeAdView 아울렛 등록 (nativeAd 설정 전에 반드시 먼저 등록)
        mediaView    = mediaView_
        headlineView = headlineLabel
        bodyView     = bodyLabel
        adChoicesView = adChoices_

        // 뷰 계층 구성
        mediaContainer.addSubview(mediaView_)
        adBadgeContainer.addSubview(adBadgeLabel)
        addSubview(mediaContainer)
        addSubview(headlineLabel)
        addSubview(adBadgeContainer)
        addSubview(bodyLabel)
        addSubview(adChoices_)
        addSubview(divider)

        NSLayoutConstraint.activate([
            // 미디어 컨테이너: 왼쪽 100×100, 수직 중앙 정렬
            mediaContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            mediaContainer.widthAnchor.constraint(equalToConstant: 100),
            mediaContainer.heightAnchor.constraint(equalToConstant: 100),

            // 미디어 뷰: 컨테이너를 꽉 채움
            mediaView_.topAnchor.constraint(equalTo: mediaContainer.topAnchor),
            mediaView_.leadingAnchor.constraint(equalTo: mediaContainer.leadingAnchor),
            mediaView_.trailingAnchor.constraint(equalTo: mediaContainer.trailingAnchor),
            mediaView_.bottomAnchor.constraint(equalTo: mediaContainer.bottomAnchor),

            // 헤드라인 레이블
            headlineLabel.topAnchor.constraint(equalTo: mediaContainer.topAnchor, constant: 2),
            headlineLabel.leadingAnchor.constraint(equalTo: mediaContainer.trailingAnchor, constant: 14),
            headlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),

            // 광고 뱃지 컨테이너
            adBadgeContainer.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 6),
            adBadgeContainer.leadingAnchor.constraint(equalTo: mediaContainer.trailingAnchor, constant: 14),

            // 광고 뱃지 레이블 (컨테이너 안쪽 패딩)
            adBadgeLabel.topAnchor.constraint(equalTo: adBadgeContainer.topAnchor, constant: 3),
            adBadgeLabel.bottomAnchor.constraint(equalTo: adBadgeContainer.bottomAnchor, constant: -3),
            adBadgeLabel.leadingAnchor.constraint(equalTo: adBadgeContainer.leadingAnchor, constant: 8),
            adBadgeLabel.trailingAnchor.constraint(equalTo: adBadgeContainer.trailingAnchor, constant: -8),

            // 본문 레이블
            bodyLabel.topAnchor.constraint(equalTo: adBadgeContainer.bottomAnchor, constant: 6),
            bodyLabel.leadingAnchor.constraint(equalTo: mediaContainer.trailingAnchor, constant: 14),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),

            // AdChoices 아이콘: 우상단 (Google 정책 필수)
            adChoices_.topAnchor.constraint(equalTo: topAnchor),
            adChoices_.trailingAnchor.constraint(equalTo: trailingAnchor),

            // 하단 구분선
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    // MARK: - 광고 데이터 주입

    func populate(with nativeAd: NativeAd) {
        guard self.nativeAd == nil else { return }  // 한 번만 설정
        headlineLabel.text = nativeAd.headline
        bodyLabel.text = nativeAd.body
        self.nativeAd = nativeAd  // 마지막으로 설정 (클릭 추적 활성화)
    }
}

// MARK: - UIColor hex 헬퍼 (UIKit 전용)

private extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
