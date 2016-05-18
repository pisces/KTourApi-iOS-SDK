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
        
        KTourApiAppCenter.defaultCenter().languageType = KTourApiLanguageType.Chs
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultCenter() {
        XCTAssertNotNil(KTourApiAppCenter.defaultCenter())
    }
    
    func testGetServiceKey() {
        let serviceKey: String = "JzlmZb9e3Cj5lOzZt3gUg5JXFDv0Oy6VfzYlCjXL6jSJC9tBkF6n5%2BF8Ab5dmU6QZmceUbqpXRa3JMryHM3I%2FQ%3D%3D".stringByRemovingPercentEncoding!
        
        XCTAssertNotNil(KTourApiAppCenter.defaultCenter().serviceKey)
        XCTAssertEqual(serviceKey, KTourApiAppCenter.defaultCenter().serviceKey)
    }
    
    func testCallAreaCode() {
        let expectation = expectationWithDescription("testCallAreaCode")
        
        KTourApiAppCenter.defaultCenter().call(
            path: KTourApiPath.AreaCode,
            params: KTourApiParameterSet.AreaCode(numOfRows: 10, pageNo: 1, areaCode: nil),
            completion: {(result: KTourApiResult<KTourApiResultItem.Area>?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                if result!.items != nil {
                    for item in result!.items! {
                        //                    print("item ->", item.dictionary)
                        
                        XCTAssertNotNil(item)
                        XCTAssertTrue(item.isKindOfClass(KTourApiResultItem.Area.self))
                    }
                }
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
    
    func testCallCategoryCode() {
        let expectation = expectationWithDescription("testCallCategoryCode")
        
        KTourApiAppCenter.defaultCenter().call(
            path: KTourApiPath.CategoryCode,
            params: KTourApiParameterSet.CategoryCode(numOfRows: 10, pageNo: 1, contentTypeId: nil, cat1: nil, cat2: nil, cat3: nil),
            completion: {(result: KTourApiResult<KTourApiResultItem.Area>?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                if result!.items != nil {
                    for item in result!.items! {
//                        print("item ->", item.dictionary)
                        
                        XCTAssertNotNil(item)
                        XCTAssertTrue(item.isKindOfClass(KTourApiResultItem.Area.self))
                    }
                }
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
    
    func testCallAreaBasedList() {
        let expectation = expectationWithDescription("testCallAreaBasedList")
        
        KTourApiAppCenter.defaultCenter().call(
            path: KTourApiPath.AreaBasedList,
            params: KTourApiParameterSet.AreaBasedList(numOfRows: 10, pageNo: 1, contentTypeId: nil, cat1: nil, cat2: nil, cat3: nil, areaCode: nil, sigunguCode: nil),
            completion: {(result: KTourApiResult<KTourApiResultItem.POI>?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                if result!.items != nil {
                    for item in result!.items! {
//                        print("item ->", item.dictionary)
                        
                        XCTAssertNotNil(item)
                        XCTAssertTrue(item.isKindOfClass(KTourApiResultItem.POI.self))
                    }
                }
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
    
    func testCallLocationBasedList() {
        let expectation = expectationWithDescription("testCallLocationBasedList")
        
        KTourApiAppCenter.defaultCenter().call(
            path: KTourApiPath.AreaBasedList,
            params: KTourApiParameterSet.LocationBasedList(numOfRows: 10, pageNo: 1, contentTypeId: nil, mapX: 126.981611, mapY: 37.568477),
            completion: {(result: KTourApiResult<KTourApiResultItem.POI>?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                if result!.items != nil {
                    for item in result!.items! {
//                        print("item ->", item.dictionary)
                        
                        XCTAssertNotNil(item)
                        XCTAssertTrue(item.isKindOfClass(KTourApiResultItem.POI.self))
                    }
                }
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
    
    func testCallSearchFestival() {
        let expectation = expectationWithDescription("testCallSearchFestival")
        
        KTourApiAppCenter.defaultCenter().call(
            path: KTourApiPath.SearchFestival,
            params: KTourApiParameterSet.SearchFestival(numOfRows: 10, pageNo: 1, eventStartDate: nil, eventEndDate: nil, areaCode: nil, sigunguCode: nil),
            completion: {(result: KTourApiResult<KTourApiResultItem.FestivalPOI>?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                if result!.items != nil {
                    for item in result!.items! {
//                        print("item ->", item.dictionary)
                        
                        XCTAssertNotNil(item)
                        XCTAssertTrue(item.isKindOfClass(KTourApiResultItem.FestivalPOI.self))
                    }
                }
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
    
    func testCallSearchKeyword() {
        let expectation = expectationWithDescription("testCallSearchKeyword")
        
        KTourApiAppCenter.defaultCenter().call(
            path: KTourApiPath.SearchKeyword,
            params: KTourApiParameterSet.SearchKeyword(numOfRows: 10, pageNo: 1, keyword: "马斋", contentTypeId: nil, cat1: nil, cat2: nil, cat3: nil, areaCode: nil, sigunguCode: nil),
            completion: {(result: KTourApiResult<KTourApiResultItem.POI>?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                if result!.items != nil {
                    for item in result!.items! {
//                        print("item ->", item.dictionary)
                        
                        XCTAssertNotNil(item)
                        XCTAssertTrue(item.isKindOfClass(KTourApiResultItem.POI.self))
                    }
                }
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
    
    func testCallSearchStay() {
        let expectation = expectationWithDescription("testCallSearchStay")
        
        KTourApiAppCenter.defaultCenter().call(
            path: KTourApiPath.SearchStay,
            params: KTourApiParameterSet.SearchStay(numOfRows: 10, pageNo: 1, contentTypeId: nil, areaCode: nil, sigunguCode: nil),
            completion: {(result: KTourApiResult<KTourApiResultItem.StayPOI>?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                if result!.items != nil {
                    for item in result!.items! {
//                        print("item ->", item.dictionary)
                        
                        XCTAssertNotNil(item)
                        XCTAssertTrue(item.isKindOfClass(KTourApiResultItem.StayPOI.self))
                    }
                }
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
    
    func testCallDetailCommon() {
        let expectation = expectationWithDescription("testCallDetailCommon")
        
        KTourApiAppCenter.defaultCenter().call(
            path: KTourApiPath.DetailCommon,
            params: KTourApiParameterSet.DetailCommon(contentId: 1342755),
            completion: {(result: KTourApiResult<KTourApiResultItem.POIDetail>?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                if result!.items != nil {
                    for item in result!.items! {
//                        print("item ->", item.dictionary)
                        XCTAssertNotNil(item)
                        XCTAssertTrue(item.isKindOfClass(KTourApiResultItem.POIDetail.self))
                    }
                }
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
    
    func testCallDetailIntro() {
        let expectation = expectationWithDescription("testCallDetailInfo")
        
        KTourApiAppCenter.defaultCenter().call(
            path: KTourApiPath.DetailIntro,
            params: KTourApiParameterSet.DetailIntro(contentId: 1342755, contentTypeId: "82"),
            completion: {(result: KTourApiResult<KTourApiResultItem.POIIntro>?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                
                print("result?.sourceObject", result?.sourceObject)
                
                return
                if result!.items != nil {
                    for item in result!.items! {
                        print("item ->", item.dictionary)
                        XCTAssertNotNil(item)
                        XCTAssertTrue(item.isKindOfClass(KTourApiResultItem.POIIntro.self))
                    }
                }
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
}