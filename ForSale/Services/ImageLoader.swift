//
//  ImageLoader.swift
//  ForSale
//
//  Created by costa.monzili on 03/07/2022.
//

import Foundation
import UIKit

typealias ImageTask = Task<UIImage?, Error>

protocol AnyImageLoader {
    func fetchImage(at path: String, for imageView: UIImageView) async throws -> UIImage?
    func cancelFetch(on imageView: UIImageView) async
}

actor ImageLoader: AnyImageLoader {
    static var shared = ImageLoader()
    var session: AnyURLSession = URLSession.shared
    private var cache = NSCache<NSString, UIImage>()
    private var images = [String: LoaderStatus]()
    private var cancellableTasks = [UIImageView: LoaderStatus]()

    func fetchImage(at path: String, for imageView: UIImageView) async throws -> UIImage? {
        if let status = images[path] {
            switch status {
            case .fetched(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }

        if let image = try getImageFromCache(for: path) {
            images[path] = .fetched(image)
            return image
        }

        let task: ImageTask = Task {
            guard let url = URL(string: path) else { return UIImage(named: "placeholder-image") }
            let (data, _) = try await session.data(from: url)
            try Task.checkCancellation()
            guard let image = UIImage(data: data) else { return UIImage(named: "placeholder-image") }
            cache.setObject(image, forKey: NSString(string: path))
            return image
        }

        images[path] = .inProgress(task)
        cancellableTasks[imageView] = .inProgress(task)
        guard let image = try? await task.value else { return UIImage(named: "placeholder-image") }

        images[path] = .fetched(image)
        cancellableTasks.removeValue(forKey: imageView)
        return image
    }

    private func getImageFromCache(for path: String) throws -> UIImage? {
        guard let image = cache.object(forKey: NSString(string: path)) else { return nil }
        return image
    }

    func cancelFetch(on imageView: UIImageView) async {
        guard case let .inProgress(task) = cancellableTasks.removeValue(forKey: imageView) else { return }
        task.cancel()
    }

    private enum LoaderStatus {
        case inProgress(ImageTask)
        case fetched(UIImage)
    }
}
