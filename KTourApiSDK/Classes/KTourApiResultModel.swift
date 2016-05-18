//
//  KTourApiResultModel.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/17/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import PSFoundation

class KTourApiResult<T: AbstractJSONModel>: AbstractJSONModel {
    // ================================================================================================
    //  Overridden: AbstractJSONModel
    // ================================================================================================
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(object: AnyObject?) {
        super.init(object: object)
    }
    
    override func setProperties(object: AnyObject?) {
        super.setProperties(object)
        
        if let dict: NSDictionary = object as! NSDictionary {
            if let header = dict["response"]!["header"]! {
                resultCode = header.valueForKey("resultCode") as? String
                resultMsg = header.valueForKey("resultMsg") as? String
            }
            
            if let body = dict["response"]!["body"]! {
                if let numOfRows = body["numOfRows"]! {
                    print("numOfRows", numOfRows)
                    self.numOfRows = numOfRows.integerValue
                }
                
                if let pageNo = body["pageNo"]! {
                    self.pageNo = pageNo.integerValue
                }
                
                if let totalCount = body["totalCount"]! {
                    self.totalCount = totalCount.integerValue
                }
                
                if let items = body["items"]! {
                    if !items.isEmpty {
                        if let item: AnyObject = items["item"]! {
                            if (item.isKindOfClass(NSArray.self)) {
                                self.items = self.childWithArray(item as? Array, classType: T.self) as? Array
                            } else if (item.isKindOfClass(NSDictionary.self)) {
                                self.items = [T(object: item)]
                            }
                        }
                    }
                }
            }
        }
    }
    
    // ================================================================================================
    //  getter/setter
    // ================================================================================================
    
    public private(set) var numOfRows: Int = 0
    public private(set) var pageNo: Int = 0
    public private(set) var totalCount: Int = 0
    public private(set) var resultCode: String?
    public private(set) var resultMsg: String?
    public private(set) var items: Array<T>?
}

class KTourApiResultItem {
    class Area: AbstractJSONModel {
        public private(set) var rnum: Int = 0
        public private(set) var code: NSString?
        public private(set) var name: String?
    }
    
    class POI: AbstractJSONModel {
        // ================================================================================================
        //  Overridden: AbstractJSONModel
        // ================================================================================================
        
        override func format(value: AnyObject!, forKey key: String!) -> AnyObject! {
            if (("createdtime" == key || "modifiedtime" == key) && value != nil) {
                let formatter: NSDateFormatter = NSDateFormatter.localizedFormatter();
                formatter.dateFormat = "yyyyMMddHHmmss"
                return formatter.dateFromString(String(value))
            }
            
            return super.format(value, forKey: key)
        }
        
        override func unformat(value: AnyObject!, forKey key: String!) -> AnyObject! {
            if (("createdtime" == key || "modifiedtime" == key) && value != nil) {
                let formatter: NSDateFormatter = NSDateFormatter.localizedFormatter();
                formatter.dateFormat = "yyyyMMddHHmmss"
                return formatter.stringFromDate(value as! NSDate)
            }
            
            return super.unformat(value, forKey: key)
        }
        
        // ================================================================================================
        //  getter/setter
        // ================================================================================================
        
        public private(set) var mapx: Float?
        public private(set) var mapy: Float?
        public private(set) var areacode: Int = 0
        public private(set) var contentid: Int = 0
        public private(set) var contentidtype: Int = 0
        public private(set) var dist: Int = 0
        public private(set) var masterid: Int = 0
        public private(set) var mlvel: Int?
        public private(set) var readcount: Int = 0
        public private(set) var sigungucode: Int = 0
        public private(set) var addr1: String?
        public private(set) var addr2: String?
        public private(set) var cat1: String?
        public private(set) var cat2: String?
        public private(set) var cat3: String?
        public private(set) var tel: String?
        public private(set) var title: String?
        public private(set) var firstiamge: String?
        public private(set) var firstiamge2: String?
        public private(set) var zipcode: String?
        public private(set) var createdtime: NSDate?
        public private(set) var modifiedtime: NSDate?
    }
    
    class FestivalPOI: POI {
        public private(set) var eventstartdate: NSDate?
        public private(set) var eventenddate: NSDate?
    }
    
    class StayPOI: POI {
        public private(set) var hanok: Bool = false
        public private(set) var benikia: Bool = false
        public private(set) var goodstay: Bool = false
    }
    
    class POIDetail: POI {
        public private(set) var dongcode: Int = 0
        public private(set) var overview: String?
    }
    
    class POIIntro: AbstractJSONModel {
        public private(set) var contentid: Int = 0
        public private(set) var contenttypeid: String?
        public private(set) var firstmenu: String?
        public private(set) var infocenterfood: String?
        public private(set) var opentimefood: String?
        public private(set) var parkingfood: String?
        public private(set) var reservationfood: String?
        public private(set) var restdatefood: String?
        public private(set) var smoking: String?
        public private(set) var treatmenu: String?
    }
}