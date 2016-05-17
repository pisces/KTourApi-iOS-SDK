//
//  KTourApiResultModel.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/17/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import PSFoundation

class KTourApiResultModel: AbstractJSONModel {
    
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
        if let dict: NSDictionary = object as! NSDictionary {
            if let header = dict["response"]!["header"]! {
                resultCode = header.valueForKey("resultCode") as? String
                resultMsg = header.valueForKey("resultMsg") as? String
            }
            
            if let body = dict["response"]!["body"]! {
                numOfRows = body.valueForKey("numOfRows")!.integerValue
                pageNo = body.valueForKey("pageNo")!.integerValue
                totalCount = body.valueForKey("totalCount")!.integerValue
                
                if let _items: NSDictionary = body["items"] as? NSDictionary {
                    items = self.childWithArray(_items.valueForKey("item") as? Array, classType: KTourApiResultItemModel.self) as? Array
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
    public private(set) var items: Array<KTourApiResultItemModel>?
}

class KTourApiResultItemModel: AbstractJSONModel {
    
    // ================================================================================================
    //  Overridden: AbstractJSONModel
    // ================================================================================================
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(object: AnyObject?) {
        super.init(object: object)
    }
    
    // ================================================================================================
    //  getter/setter
    // ================================================================================================
    
    public private(set) var code: Int = 0
    public private(set) var rnum: Int = 0
    public private(set) var name: String?
}