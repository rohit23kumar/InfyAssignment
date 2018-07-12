//
//  InfyAssignmentTests.swift
//  InfyAssignmentTests
//
//  Created by Rohit Kumar on 04/07/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import XCTest
@testable import InfyAssignment

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
        
        XCTAssertFalse(vc.isIndexEven(index:n))
    }
    
    func testResponseHasExpectedItemCount(){
        
        XCTAssert(collection.rows?.count == 14, "Collection didnt have 14 rows")
        for obj  in collection.rows! {
            XCTAssert((obj.title != nil), "Nil title found for index - \(obj)")
            XCTAssert(obj.description != nil, "Nil description found for index - \(obj)")
            XCTAssert(obj.imageHref != nil, "Nil imageHref found for index - \(obj)")
        }
    }
}

