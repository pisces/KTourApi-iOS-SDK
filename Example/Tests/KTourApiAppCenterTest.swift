//
//  KTourApiAppCenterTest.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/17/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
@testable import KTourApiSDK

class KTourApiAppCenterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultCenter() {
        XCTAssertNotNil(KTourApiAppCenter.defaultCenter())
    }
    
    func testGetServiceKey() {
        XCTAssertNotNil(KTourApiAppCenter.defaultCenter().serviceKey)
        XCTAssertEqual("kKTourApiServiceKey", KTourApiAppCenter.defaultCenter().serviceKey)
    }
    
    func testCallAreaCode() {
        let expectation = expectationWithDescription("testCallAreaCode")
        
        KTourApiAppCenter.defaultCenter().call(
            KTourApiPath.AreaCode,
            params: ["numOfRows": (10), "pageNo": (1)],
            completion: {(result:KTourApiResultModel?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                print("result ->", result!.dictionary)
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
    
    func testCallLocationBasedList() {
        let expectation = expectationWithDescription("testCallLocationBasedList")
        
        KTourApiAppCenter.defaultCenter().call(
            KTourApiPath.LocationBasedList,
            params: ["numOfRows": (10), "pageNo": (1)],
            completion: {(result:KTourApiResultModel?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
}