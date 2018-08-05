//
//  PictureCell.swift
//  InfyAssignment
//
//  Created by Rohit Kumar on 19/07/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class PictureCell: UITableViewCell {
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Constants.k_DefaultTitle
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = ColorConstants.kColor_Text_Color
        titleLabel.font = UIFont(name: Constants.k_DefaultFont, size: 20.0)
        return titleLabel
    }()
    let descriptionLabel : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = Constants.k_DefaultDescription
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = ColorConstants.kColor_Text_Color
        descriptionLabel.font = UIFont(name: Constants.k_DefaultFont, size: 14.0)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    var imgView : UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "loading"))
        imgView.backgroundColor = .clear
        imgView.clipsToBounds = true
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var imageViewHeight: NSLayoutConstraint
    var imageViewWidth: NSLayoutConstraint
    var cacheManager = ImageCacheManager()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        imageViewHeight = NSLayoutConstraint(item: imgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        imageViewWidth = NSLayoutConstraint(item: imgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        imageViewHeight = NSLayoutConstraint(item: imgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        imageViewWidth = NSLayoutConstraint(item: imgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(fromImageURL imageURL: String? , completion: @escaping ()->()) {
        
        guard let imagePath = imageURL else {
            return
        }
        if let imageURL: URL = URL(string: imagePath) {
            if cacheManager.checkImageCacheExistance(fromURL: imagePath) {
                let imageData = cacheManager.fetchImageFromCache(imagePath: imagePath)
                displayImage(image: imageData)
                setNeedsLayout()
                completion()
            }
            else{
                self.imgView.af_setImage(withURL: imageURL,
                                         imageTransition: .crossDissolve(0.5),
                                         runImageTransitionIfCached: true,
                                         completion: { response in
                                            if response.result.error != nil{
                                                self.cacheManager.saveImageIntoCache(imageURL: imagePath, withImageData: #imageLiteral(resourceName: "loading"))
                                                self.displayImage(image: self.cacheManager.fetchImageFromCache(imagePath: imagePath))
                                            } else {
                                                if let imageToCache = response.result.value{
                                                    self.cacheManager.imageCache.setObject(imageToCache, forKey: imagePath as NSString)
                                                    self.setNeedsLayout()
                                                    completion()
                                                }
                                            }
                })
            }
        }
    }
    
    /// This will load image from cache
    ///
    /// - Parameter imageURL: path(URL) to load image form cache.
    private func displayImage(image : UIImage) {
        self.imgView.image = image
    }
    
    func setupSubViews(){
        addSubview(imgView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imgView]))

        addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : descriptionLabel]))
        
        addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : titleLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-[v1]-[v2]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imgView, "v1" : titleLabel, "v2" : descriptionLabel]))
        
        addConstraint(imageViewHeight)
        addConstraint(imageViewWidth)
        
    }
    
    override func setNeedsLayout() {
        getSizeOfImageView()
        super.setNeedsLayout()
    }
    
    func getSizeOfImageView() {
        let screen_width = UIScreen.main.bounds.width
        if let ht = imgView.image?.size.height{
            if let wd = imgView.image?.size.width{
                let x =  ht / wd
                let ratio = Double(round(100*x)/100)
                let newHeight = screen_width*CGFloat(ratio)
                imageViewWidth.constant = screen_width
                imageViewHeight.constant = newHeight
                return
            }else{
                return
            }
        }else{
            return
        }
    }
}
