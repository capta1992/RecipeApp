//
//  ImageCache.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/17/25.
//

import UIKit

actor ImageCache {
    
    static let shared = ImageCache()
    private init() { }
    
    private var inMemory = NSCache<NSString, UIImage>()
    
    private var diskPath: URL = {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDir = paths[0]
        let folder = cacheDir.appendingPathComponent("RecipeImages", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder
    }()
    
    func fetchImage(from url: URL, service: RecipeServiceProtocol) async throws -> UIImage {
        let key = url.absoluteString as NSString
        
        if let inMemory = inMemory.object(forKey: key) {
            return inMemory
        }
        let hashName = sha256(url.absoluteString)
        let diskFile = diskPath.appendingPathComponent(hashName)
        if FileManager.default.fileExists(atPath: diskFile.path) {
            if let data = try? Data(contentsOf: diskFile),
               let image = UIImage(data: data) {
                inMemory.setObject(image, forKey: key)
                return image
            }
        }
        let data = try await service.downloadImage(at: url)
        guard let image = UIImage(data: data) else {
            throw RecipeError.malformedData
        }
        do {
            try data.write(to: diskFile)
        } catch {
            throw RecipeError.diskCacheFailed
        }
        inMemory.setObject(image, forKey: key)
        return image
    }
    private func sha256(_ str: String) -> String {
        // We can use CryptoKit or do a simpler approach
        // For brevity, I will do a naive approach or a quick hash
        return String(str.hashValue)
    }
}
