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
        if let image = getCachedImageFor(key: cacheKey) {
            completion(.success(image.sd_imageData()))
            return
        }
        
        let urlString = networkEnvironment.getUrlPathFor(.getMoviePoster(path))
        guard let url = URL(string: urlString) else {
            completion(.failure(ImageServiceError.notFound))
            return
        }
        
        let downloadToken = downloadService.downloadImage(with: url, options: .highPriority, progress: nil) {
            [weak self] (image, data, error, isFinished) in
            
            guard let image = image else {
                completion(.failure(error ?? ImageServiceError.notFound))
                return
            }
            self?.storeImage(image, for: cacheKey)
            completion(.success(image.sd_imageData()))
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
    
    private func storeImage(_ image: UIImage, for cacheKey: String) {
        cacheService.store(image, forKey: cacheKey)
    }
}
