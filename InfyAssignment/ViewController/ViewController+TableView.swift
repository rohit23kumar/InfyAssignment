//
//  ViewController+TableView.swift
//  InfyAssignment
//
//  Created by Rohit Kumar on 03/08/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import UIKit
extension ViewController{
    
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
        
        //Load Image for the cell
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
    
    
    func isIndexEven(index: Int) -> Bool {
        if index%2 == 0 {
            return true
        }else{
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basePayload.rows!.count
    }
    
    
}
