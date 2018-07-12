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
    
    func testIsIndexEven(){
        let vc = ViewController()
        let n = 5
        
        XCTAssertFalse(vc.isIndexEven(index:n))
    }
    
}
