//
//  ViewController.swift
//  InfyAssignment
//
//  Created by Rohit Kumar on 04/07/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UITableViewController {
    
    let cellIdentifier = "cellIdentifier"
    fileprivate var basePayload = BasePayload(title: "", rows: [ImageRow()])
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(PictureCell.self, forCellReuseIdentifier: cellIdentifier)
        
        Service.sharedInstance.fetchingData { (data) in
            self.basePayload = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                self.activityIndiator.stopAnimating()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PictureCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PictureCell
        let obj = basePayload.rows![indexPath.item]
        cell.backgroundColor = UIColor.clear
        cell.titleLabel.text = obj.title
        cell.descriptionLabel.text = obj.description
        let str : String = obj.imageHref ?? ""
        cell.imgView.image = #imageLiteral(resourceName: "loading")
        if let imageURL: URL = URL(string: str) {
            if let imageFromCache: UIImage = self.imageCache.object(forKey: str as NSString){
                cell.imgView.image = imageFromCache
                return cell
            }
            
            cell.imgView.af_setImage(withURL: imageURL,
                                     imageTransition: .crossDissolve(0.5),
                                     runImageTransitionIfCached: true,
                                     completion:  { response in
                                        if response.result.error != nil{
                                            print(response.result.error)
                                            cell.imgView.image = #imageLiteral(resourceName: "loading")
                                        }else{
                                            let imageToCache = response.result.value!
                                            if obj.imageHref == str{
                                                cell.imgView.image = imageToCache
                                            }
                                            self.imageCache.setObject(response.result.value!, forKey: str as NSString)
                                            
                                        }
                                        
            })
        }
        return cell
    }
    
    func loadImage(url : URL) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basePayload.rows!.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class PictureCell: UITableViewCell {
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "titleLabel Loading...."
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        return titleLabel
    }()
    let descriptionLabel : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "descriptionLabel Loading...."
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        descriptionLabel.font = UIFont(name: "Helvetica Neue", size: 8.0)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    var imgView : UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "loading"))
        imgView.clipsToBounds = true
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        
        return imgView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubViews()
        
    }
    
    func setupSubViews(){
        
        addSubview(imgView)
        sendSubview(toBack: imgView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imgView]))
        addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : descriptionLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : descriptionLabel]))
        
        
        addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : titleLabel, "v1" : descriptionLabel]))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
}
