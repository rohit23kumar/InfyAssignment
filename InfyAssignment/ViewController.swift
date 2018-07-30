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
    
    let imageCache = NSCache<NSString, UIImage>()
    let cellIdentifier = Constants.k_CELLIDENTIFIER
    fileprivate var basePayload = BasePayload(title: "", rows: [ImageRow()])
    lazy var refreshControl1 :UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .red
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setTableView()
        setNavigationBar()
        loadService()
    }
    
    func setTableView() {
        tableView.register(PictureCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 117
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = refreshControl1
        tableView.refreshControl?.addTarget(self, action: #selector(ViewController.handleRefresh(sender:)), for: UIControlEvents.valueChanged)
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = ColorConstants.kColor_Navigation_Bar_Color
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !Connectivity.isConnectedToInternet {
            let alert = UIAlertController(title: Constants.k_NOT_CONNECTED, message: Constants.k_NOT_CONNECTED_MSG, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: Constants.k_DISMISS, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    @objc func handleRefresh(sender:AnyObject) {
        loadService()
    }
    
    func isIndexEven(index: Int) -> Bool {
        if index%2 == 0 {
            return true
        }else{
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PictureCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PictureCell
        
        if(isIndexEven(index: indexPath.row) == true){
            cell.contentView.backgroundColor = ColorConstants.kColor_Even_Cell_Color
        }else{
            cell.contentView.backgroundColor = ColorConstants.kColor_Odd_Cell_Color
        }
        
        let obj = basePayload.rows![indexPath.item]
        cell.titleLabel.text = obj.title
        cell.descriptionLabel.text = obj.description
        cell.imageURLString = obj.imageHref ?? ""
        cell.imgView.image = #imageLiteral(resourceName: "loading")
        if let imageURL: URL = URL(string: cell.imageURLString) {
            if let imageFromCache: UIImage = self.imageCache.object(forKey: cell.imageURLString as NSString){
                cell.imgView.image = imageFromCache
                tableView.beginUpdates()
                cell.setNeedsLayout()
                tableView.endUpdates()
            }
            else{
                cell.imgView.af_setImage(withURL: imageURL,
                                         imageTransition: .crossDissolve(0.5),
                                         runImageTransitionIfCached: true,
                                         completion:  { response in
                                            if response.result.error != nil{
                                                cell.imgView.image = #imageLiteral(resourceName: "loading")
                                                self.imageCache.setObject(#imageLiteral(resourceName: "loading"), forKey: cell.imageURLString as NSString)
                                            }else{
                                                let imageToCache = response.result.value!
                                                if obj.imageHref == cell.imageURLString{
                                                    self.imageCache.setObject(imageToCache, forKey: cell.imageURLString as NSString)
                                                    cell.imgView.image = imageToCache
                                                    tableView.beginUpdates()
                                                    cell.setNeedsLayout()
                                                    tableView.endUpdates()
                                                }
                                            }
                })
            }
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



