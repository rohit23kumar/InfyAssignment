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
    
    let cellIdentifier = Constants.k_CELLIDENTIFIER
    var basePayload = BasePayload(title: "", rows: [ImageRow()])
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
        ImageCacheManager().restCache()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



