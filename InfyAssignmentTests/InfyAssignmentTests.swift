//
//  InfyAssignmentTests.swift
//  InfyAssignmentTests
//
//  Created by Rohit Kumar on 04/07/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import XCTest
@testable import InfyAssignment
import AlamofireImage

class InfyAssignmentTests: XCTestCase {
    
    var collection : BasePayload!
    
    override func setUp() {
        let bundle = Bundle(for: InfyAssignmentTests.self)
        let url = bundle.url(forResource: "response", withExtension: "json")
        guard let data: Data = NSData(contentsOf: url!) as Data? else {return}
        do{
            collection = try
                JSONDecoder().decode(BasePayload.self, from: data)
            print(collection.rows?.count ?? 0)
        }catch let jsonErr{
            print("Error occured during json serialisation: ", jsonErr)
        }
    }
    
    func testIsIndexEven(){
        let vc = ViewController()
        let n = 6
        
        XCTAssertTrue(vc.isIndexEven(index:n))
    }
    
    func testResponseHasExpectedItemCount(){
        
        XCTAssert(collection.rows?.count == 14, "Collection didnt have 14 rows")
        for obj  in collection.rows! {
            XCTAssert((obj?.title != nil), "Nil title found for index - \(String(describing: obj))")
            XCTAssert(obj?.description != nil, "Nil description found for index - \(String(describing: obj))")
            XCTAssert(obj?.imageHref != nil, "Nil imageHref found for index - \(String(describing: obj))")
        }
    }
    
    func testURLResponse(){
        
        let expectation = self.expectation(description: "loading")
        Service.sharedInstance.fetchingData { (data) in
            self.collection = data
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(self.collection.rows?.count == 14, "Collection didnt have 14 rows")
        for obj  in collection.rows! {
            XCTAssert((obj?.title != nil), "Nil title found for index - \(String(describing: obj))")
            XCTAssert(obj?.description != nil, "Nil description found for index - \(String(describing: obj))")
            XCTAssert(obj?.imageHref != nil, "Nil imageHref found for index - \(String(describing: obj))")
            
            testURLLoadsImageForURL(urlString: obj?.imageHref)
        }
    }
    
    func testURLLoadsImageForURL(urlString: String?) {
        if let str: String = urlString{
            let expectation = self.expectation(description: "Image from http did load")
            let imageURL: URL = URL(string: str)!
            
            let viewer = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
            viewer.af_setImage(withURL: imageURL,
                               imageTransition: .crossDissolve(0.5),
                               runImageTransitionIfCached: true,
                               completion: { response in
                                expectation.fulfill()
                                
            })
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssert((viewer.image != nil), "Image not loaded for url - \(String(describing: str))")
        }else{
            XCTFail("No image URL Found")
        }
    }
}

