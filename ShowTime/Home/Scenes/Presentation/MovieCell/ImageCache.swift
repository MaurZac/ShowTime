//
//  ImageCache.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

