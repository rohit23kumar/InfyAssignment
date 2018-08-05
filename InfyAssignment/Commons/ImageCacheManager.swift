//
//  ImageCacheManager.swift
//  InfyAssignment
//
//  Created by Rohit Kumar on 05/08/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheManager {
    let imageCache = NSCache<NSString, UIImage>()
    
    /// This will check for image existance in cache.
    public func checkImageCacheExistance(fromURL imageURL: String) -> Bool {
        if let _: UIImage = imageCache.object(forKey: imageURL as NSString) {
            return true
        } else {
            return false
        }
    }
    
    /// This will fetch image data from cache
    ///
    /// - Parameter imagePath: url of the image to fetch.
    /// - Returns: Returns the image
    public func fetchImageFromCache(imagePath : String) -> UIImage {
        let imageFromCache: UIImage = imageCache.object(forKey: imagePath as NSString)!
        return imageFromCache
    }
    
    
    /// This function will save image into cachce
    ///
    /// - Parameters:
    ///   - imageURL: Image path refernce URL
    ///   - image: Image to save
    public func saveImageIntoCache(imageURL : String, withImageData image: UIImage) {
        imageCache.setObject(image, forKey: imageURL as NSString)
    }
}
