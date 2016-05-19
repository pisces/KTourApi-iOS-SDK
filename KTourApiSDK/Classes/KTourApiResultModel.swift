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
    
    override init(object: AnyObject?) {
        super.init(object: object)
    }
    
    override public func setProperties(object: AnyObject?) {
        super.setProperties(object)
        
        if let dict: NSDictionary = object as! NSDictionary {
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
    
    var numOfRows: Int = 0
    var pageNo: Int = 0
    var totalCount: Int = 0
    var resultCode: KTourApiResultCode = KTourApiResultCode.UNKNOWN_ERROR
    var resultMsg: String?
    public var items: Array<T>?
}

public class KTourApiResultItem: AbstractJSONModel {
    public class Code: KTourApiResultItem {
        var rnum: Int = 0
        var name: String?
    }
    
    public class Area: Code {
        var code: Int = 0
    }
    
    public class Category: Code {
        var code: String?
    }
    
    public class POIBase: KTourApiResultItem {
        var contentid: Int = 0
        var contentidtype: Int = 0
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
        
        var mapx: Float?
        var mapy: Float?
        var areacode: Int = 0
        var dist: Int = 0
        var masterid: Int = 0
        var mlvel: Int?
        var readcount: Int = 0
        var sigungucode: Int = 0
        var addr1: String?
        var addr2: String?
        var cat1: String?
        var cat2: String?
        var cat3: String?
        var tel: String?
        var title: String?
        var firstiamge: String?
        var firstiamge2: String?
        var zipcode: String?
        var createdtime: NSDate?
        var modifiedtime: NSDate?
    }
    
    public class FestivalPOI: POI {
        var eventstartdate: NSDate?
        var eventenddate: NSDate?
    }
    
    public class StayPOI: POI {
        var hanok: Bool = false
        var benikia: Bool = false
        var goodstay: Bool = false
    }
    
    public class POIDetail: POI {
        var dongcode: Int = 0
        var overview: String?
    }
    
    public class POIDetailInfo: POIBase {
        var fldgubun: Int = 0
        var serialnum: Int = 0
        var infoname: String?
        var infotext: String?
    }
    
    public class POIDetailIntro: POIBase {
        var firstmenu: String?
        var infocenterfood: String?
        var opentimefood: String?
        var parkingfood: String?
        var reservationfood: String?
        var restdatefood: String?
        var smoking: String?
        var treatmenu: String?
    }
    
    public class POIDetailImage: POIBase {
        var imagename: String?
        var originimgurl: String?
        var serialnum: String?
        var smallimageurl: String?
    }
}