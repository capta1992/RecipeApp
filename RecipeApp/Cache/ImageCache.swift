//
//  ImageCache.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/17/25.
//

import UIKit

actor ImageCache {
    
    static let shared = ImageCache()
    private init() {}
    
    /// In-memory
    private var inMemory = NSCache<NSString, UIImage>()
    
    /// We'll store images in the Caches directory on disk
    private var diskPath: URL = {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDir = paths[0]
        let folder = cacheDir.appendingPathComponent("RecipeImages", isDirectory: true)
        // Create directory if not exist
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder
    }()
    
    /// Return a UIImage for the given URL, from memory/disk if possible, otherwise download
    func fetchImage(from url: URL, service: RecipeServiceProtocol) async throws -> UIImage {
        let key = url.absoluteString as NSString
        
        // 1) Check in-memory
        if let inMem = inMemory.object(forKey: key) {
            return inMem
        }
        
        // 2) Check disk
        let hashName = sha256(url.absoluteString)
        let diskFile = diskPath.appendingPathComponent(hashName)
        if FileManager.default.fileExists(atPath: diskFile.path) {
            if let data = try? Data(contentsOf: diskFile),
               let image = UIImage(data: data) {
                inMemory.setObject(image, forKey: key)
                return image
            }
        }
        
        // 3) Download fresh
        let data = try await service.downloadImage(at: url)
        guard let image = UIImage(data: data) else {
            throw RecipeError.malformedData
        }
        
        // 4) Write to disk
        do {
            try data.write(to: diskFile)
        } catch {
            throw RecipeError.diskCacheFailed
        }
        
        // 5) Store in memory
        inMemory.setObject(image, forKey: key)
        return image
    }
    
    /// Basic hashing to produce a disk filename
    private func sha256(_ str: String) -> String {
        // We can use CryptoKit or do a simpler approach
        // For brevity, let's do a naive approach or a quick hash
        return String(str.hashValue) // not a real cryptographic approach
    }
}
