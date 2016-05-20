//
//  KTourApiResultModel.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/17/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import PSFoundation

public class KTourApiResult<T: AbstractJSONModel>: AbstractJSONModel {
    // ================================================================================================
    //  Overridden: AbstractJSONModel
    // ================================================================================================
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(object: AnyObject?) {
        super.init(object: object)
    }
    
    override public func setProperties(object: AnyObject?) {
        super.setProperties(object)
        
        if let dict: NSDictionary = (object as! NSDictionary) {
            if let header = dict["response"]!["header"]! {
                if let resultCode = header["resultCode"]! {
                    self.resultCode = KTourApiResultCode(rawValue: resultCode.integerValue)!
                }
                
                resultMsg = header.valueForKey("resultMsg") as? String
                
                if (self.resultCode == KTourApiResultCode.NORMAL_CODE) {
                    parseBody(dictionary: dict)
                }
            }
        }
    }
    
    override public var description: String {
        get {
            var array: Array<String> = []
            
            if self.items != nil {
                for item: AnyObject in self.items! {
                    array.append(item.dictionary.description)
                }
            }
            
            return self.dictionary.description + "\r\n" + array.joinWithSeparator(",\r\n")
        }
    }
    
    // ================================================================================================
    //  Private methods
    // ================================================================================================
    
    func parseBody(dictionary aDict: NSDictionary) -> Void {
        if let body = aDict["response"]!["body"]! {
            if let numOfRows = body["numOfRows"]! {
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
    
    // ================================================================================================
    //  getter/setter
    // ================================================================================================
    
    public var numOfRows: Int = 0
    public var pageNo: Int = 0
    public var totalCount: Int = 0
    public var resultCode: KTourApiResultCode = KTourApiResultCode.UNKNOWN_ERROR
    public var resultMsg: String?
    public var items: Array<T>?
}

public class KTourApiResultItem: AbstractJSONModel {
    public class Code: KTourApiResultItem {
        public var rnum: Int = 0
        public var name: String?
    }
    
    public class Area: Code {
        public var code: Int = 0
    }
    
    public class Category: Code {
        public var code: String?
    }
    
    public class POIBase: KTourApiResultItem {
        public var contentid: Int = 0
        public var contenttypeid: Int = 0
    }
    
    public class POI: POIBase {
        // ================================================================================================
        //  Overridden: AbstractJSONModel
        // ================================================================================================
        
        override public func format(value: AnyObject!, forKey key: String!) -> AnyObject! {
            if (("createdtime" == key || "modifiedtime" == key) && value != nil) {
                let formatter: NSDateFormatter = NSDateFormatter.localizedFormatter();
                formatter.dateFormat = "yyyyMMddHHmmss"
                return formatter.dateFromString(String(value))
            }
            
            return super.format(value, forKey: key)
        }
        
        override public func unformat(value: AnyObject!, forKey key: String!) -> AnyObject! {
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
        
        public var mapx: Float?
        public var mapy: Float?
        public var areacode: Int = 0
        public var dist: Int = 0
        public var masterid: Int = 0
        public var mlvel: Int?
        public var readcount: Int = 0
        public var sigungucode: Int = 0
        public var addr1: String?
        public var addr2: String?
        public var cat1: String?
        public var cat2: String?
        public var cat3: String?
        public var tel: String?
        public var title: String?
        public var firstiamge: String?
        public var firstiamge2: String?
        public var zipcode: String?
        public var createdtime: NSDate?
        public var modifiedtime: NSDate?
    }
    
    public class FestivalPOI: POI {
        public var eventstartdate: NSDate?
        public var eventenddate: NSDate?
    }
    
    public class StayPOI: POI {
        public var hanok: Bool = false
        public var benikia: Bool = false
        public var goodstay: Bool = false
    }
    
    public class POIDetail: POI {
        public var dongcode: Int = 0
        public var overview: String?
    }
    
    public class POIDetailInfo: POIBase {
        public var fldgubun: Int = 0
        public var serialnum: Int = 0
        public var infoname: String?
        public var infotext: String?
    }
    
    public class POIDetailIntro: POIBase {
        public var firstmenu: String?
        public var infocenterfood: String?
        public var opentimefood: String?
        public var parkingfood: String?
        public var reservationfood: String?
        public var restdatefood: String?
        public var smoking: String?
        public var treatmenu: String?
    }
    
    public class POIDetailImage: POIBase {
        public var imagename: String?
        public var originimgurl: String?
        public var serialnum: String?
        public var smallimageurl: String?
    }
}