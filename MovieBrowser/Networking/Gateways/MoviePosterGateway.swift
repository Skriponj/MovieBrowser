//
//  MoviePosterGateway.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import Foundation
import SDWebImage

protocol MoviePosterGateway {
    func downloadImage(path: String, for cacheKey: String, completion: @escaping (Result<Data?, Error>) -> Void)
    func cancelDownload(for key: String)
}

class AppMoviePosterGateway: MoviePosterGateway {
    
    enum ImageServiceError: Error {
        case notFound
    }
    
    private var downloadService: SDWebImageDownloader
    private var cacheService: SDImageCache
    private var networkEnvironment = NetworkEnvironment()
    private var operations: [String: SDWebImageDownloadToken?] = [:]
    
    init() {
        downloadService = SDWebImageDownloader.shared
        cacheService = SDImageCache.shared
    }
    
    func downloadImage(path: String, for cacheKey: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        queryImageFromCacheForKey(cacheKey) { [weak self] (data) in
            if let imgData = data {
                completion(.success(imgData))
            } else {
                self?.loadImageFromWeb(path: path, for: cacheKey, completion: completion)
            }
        }
    }
    
    private func loadImageFromWeb(path: String, for cacheKey: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        let urlString = networkEnvironment.getUrlPathFor(.getMoviePoster(path))
        guard let url = URL(string: urlString) else {
            completion(.failure(ImageServiceError.notFound))
            return
        }
        
        let downloadToken = downloadService.downloadImage(with: url, options: .highPriority, progress: nil) {
            [weak self] (image, data, error, isFinished) in
            
            guard let imgData = data,
                  let image = image else {
                completion(.failure(error ?? ImageServiceError.notFound))
                return
            }
            self?.storeImage(image, for: cacheKey)
            completion(.success(imgData))
        }
        
        operations[cacheKey] = downloadToken
    }
    
    func cancelDownload(for key: String) {
        guard let operation = operations[key] as? SDWebImageDownloadToken else {
            return
        }
        operation.cancel()
        operations.removeValue(forKey: key)
    }
    
    private func getCachedImageFor(key: String) -> UIImage? {
        return cacheService.imageFromCache(forKey: key)
    }
    
    private func queryImageFromCacheForKey(_ key: String, completion: @escaping (Data?) -> Void) {
        cacheService.queryImage(forKey: key, options: .fromCacheOnly, context: nil) { (image, data, cacheType) in
            completion(data)
        }
    }
    
    private func storeImage(_ image: UIImage, for cacheKey: String) {
        cacheService.store(image, forKey: cacheKey)
    }
}
