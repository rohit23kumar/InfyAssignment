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
    lazy var refreshControl1 :UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .red
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(PictureCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsSelection = false 
        tableView.estimatedRowHeight = 117
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = refreshControl1
        tableView.refreshControl?.addTarget(self, action: #selector(ViewController.handleRefresh(sender:)), for: UIControlEvents.valueChanged)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        loadService()
    }
    
    func loadService() {
        imageCache.removeAllObjects()
        Service.sharedInstance.fetchingData { (data) in
            self.basePayload = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = self.basePayload.title
                self.refreshControl?.endRefreshing()
            }
        }
    }
//    #selector(refresh(_:)
    @objc func handleRefresh(sender:AnyObject) {
        loadService()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PictureCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PictureCell
        if indexPath.row%2 == 0 {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        }else{
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
        let obj = basePayload.rows![indexPath.item]
        cell.titleLabel.text = obj.title
        cell.descriptionLabel.text = obj.description
        let str : String = obj.imageHref ?? ""
        cell.imgView.image = #imageLiteral(resourceName: "loading")
        if let imageURL: URL = URL(string: str) {
            if let imageFromCache: UIImage = self.imageCache.object(forKey: str as NSString){
                cell.imgView.image = imageFromCache
                tableView.beginUpdates()
                cell.setNeedsLayout()
                tableView.endUpdates()
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
                                                tableView.beginUpdates()
                                                cell.setNeedsLayout()
                                                tableView.endUpdates()
                                            }
                                        }
            })
        }
        return cell
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
        imgView.backgroundColor = .clear
        imgView.clipsToBounds = true
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        return imgView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubViews()
        
    }
    
    func setupSubViews(){
        
        let screen_width = UIScreen.main.bounds.width
        let x =  (imgView.image?.size.height)! / (imgView.image?.size.width)!
        let ratio = Double(round(100*x)/100)
        let newHeight = screen_width*CGFloat(ratio)
        imgView.frame.size = CGSize(width: screen_width, height: newHeight)
        addSubview(imgView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imgView]))
        
        addSubview(descriptionLabel)
        bringSubview(toFront: descriptionLabel)
        descriptionLabel.numberOfLines = 0
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : descriptionLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : descriptionLabel]))
        
        
        addSubview(titleLabel)
        bringSubview(toFront: titleLabel)
        titleLabel.numberOfLines = 0
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : titleLabel, "v1" : descriptionLabel]))
        
    }
    
    override func setNeedsLayout() {
        
        let screen_width = UIScreen.main.bounds.width
        let x =  (imgView.image?.size.height)! / (imgView.image?.size.width)!
        let ratio = Double(round(100*x)/100)
        let newHeight = screen_width*CGFloat(ratio)
        imgView.frame.size = CGSize(width: screen_width, height: newHeight)
        self.frame.size.height = newHeight
        super.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                fatalError("init(coder:) has not been implemented")
    }
}
