//
//  ImageCache.swift
//  SonMat
//

import SwiftUI
import CryptoKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    private let cacheDirectory: URL

    private init() {
        cacheDirectory = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache", isDirectory: true)
        try? FileManager.default.createDirectory(
            at: cacheDirectory, withIntermediateDirectories: true)
    }

    // MARK: - Memory tier

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func insert(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }

    // MARK: - Disk tier

    func imageFromDisk(for url: URL) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(cacheKey(for: url))
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    func saveToDisk(_ image: UIImage, for url: URL) {
        Task.detached(priority: .background) { [weak self] in
            guard let self,
                  let data = image.jpegData(compressionQuality: 0.85) else { return }
            let fileURL = self.cacheDirectory.appendingPathComponent(self.cacheKey(for: url))
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    // MARK: - Cache management

    func clearDiskCache() {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: cacheDirectory, includingPropertiesForKeys: nil) else { return }
        files.forEach { try? FileManager.default.removeItem(at: $0) }
    }

    func diskCacheSize() -> Int64 {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) else { return 0 }
        return files.reduce(0) { total, fileURL in
            let size = (try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
            return total + Int64(size)
        }
    }

    // MARK: - Private

    private func cacheKey(for url: URL) -> String {
        SHA256.hash(data: Data(url.absoluteString.utf8))
            .compactMap { String(format: "%02x", $0) }
            .joined() + ".jpg"
    }
}

struct CachedAsyncImage<Placeholder: View>: View {
    let url: URL?
    let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder()
                    .task { await load() }
            }
        }
    }

    private func load() async {
        guard let url else { return }

        // 1단계: 메모리
        if let cached = ImageCache.shared.image(for: url) {
            uiImage = cached
            return
        }
        // 2단계: 디스크
        if let diskImage = ImageCache.shared.imageFromDisk(for: url) {
            ImageCache.shared.insert(diskImage, for: url)
            uiImage = diskImage
            return
        }
        // 3단계: 네트워크
        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let loaded = UIImage(data: data) else { return }
        ImageCache.shared.insert(loaded, for: url)
        ImageCache.shared.saveToDisk(loaded, for: url)
        uiImage = loaded
    }
}
