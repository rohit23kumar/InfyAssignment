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
        
        let obj = basePayload.rows?[indexPath.item]
        cell.titleLabel.text = obj?.title
        cell.descriptionLabel.text = obj?.description
        cell.imgView.image = #imageLiteral(resourceName: "loading")
        
        //Load Image for the cell
        cell.loadImage(fromImageURL: obj?.imageHref) {
            tableView.beginUpdates()
            cell.setNeedsLayout()
            tableView.endUpdates()
        }
        return cell
    }
    
    
    func isIndexEven(index: Int) -> Bool {
        return index%2 == 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basePayload.rows?.count ?? 0
    }
}
