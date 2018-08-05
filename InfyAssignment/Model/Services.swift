//
//  Services.swift
//  InfyAssignment
//
//  Created by Rohit Kumar on 04/07/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import Foundation
import Alamofire

struct BasePayload: Decodable {
    let title : String
    var rows : [ImageRow?]?
}

struct ImageRow : Decodable{
    var title : String? = ""
    var description : String? = ""
    var imageHref : String? = ""
}


struct Service{
    
    static let sharedInstance = Service()
    func fetchingData(completion:@escaping (BasePayload) -> ()) {
        
        let jsonURLString = Constants.k_jsonURL
        guard let url = URL(string: jsonURLString) else { return  }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            let dataString = String(data: data, encoding: String.Encoding.isoLatin1)
            // Converted to supported string format
            // Unbale to convert the response to String format due to unsupported string content in the response
            if let dataObject = dataString?.data(using: String.Encoding.utf8) {
                do{
                    let webDescription = try
                        JSONDecoder().decode(BasePayload.self, from: dataObject)
                    completion(webDescription)
                }catch let jsonErr{
                    print(Constants.k_jsonSerialisationErrorMsg, jsonErr)
                }
            }
            }.resume()
    }
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        if let networkManager = NetworkReachabilityManager() {
            return networkManager.isReachable
        } else {
            return false
        }
    }
}
