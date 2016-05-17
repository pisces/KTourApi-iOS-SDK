//
//  KTourApiAppCenter.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/17/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import w3action

enum KTourApiLanguageType: String {
    case Chs = "ChsService", Cht = "ChtService"
}

enum KTourApiPath: String {
    case AreaCode = "areaCode",
    LocationBasedList = "locationBasedList"
}

class KTourApiAppCenter: NSObject {
    let kKTourApiServiceKey: String = "KTourApiServiceKey"
    let kKTourApiBasePath: String = "http://api.visitkorea.or.kr/openapi/service/rest"
    let kKTourApiParamsDataType = "_type"
    let kKTourApiParamsMobileApp = "MobileApp"
    let kKTourApiParamsMobileOS = "MobileOS"
    let kKTourApiParamsServiceKey = "ServiceKey"
    
    typealias TourApiCallCompleteHandler = (result: KTourApiResultModel?, error: NSError?) -> Void
    
    // ================================================================================================
    //  Overridden: NSObject
    // ================================================================================================
    
    override init() {
        serviceKey = NSBundle.mainBundle().objectForInfoDictionaryKey(kKTourApiServiceKey) as! String;
        
        if serviceKey == nil {
            #if DEBUG
                print("KTourApiServiceKey does not exist in info plist file!")
            #endif
        } else {
            serviceKey = serviceKey?.stringByRemovingPercentEncoding
        }
    }
    
    // ================================================================================================
    //  Public
    // ================================================================================================
    
    static func defaultCenter() -> KTourApiAppCenter {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: KTourApiAppCenter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = KTourApiAppCenter()
        }
        return Static.instance!
    }
    
    public func call(path: KTourApiPath, params: NSDictionary?, completion: TourApiCallCompleteHandler?) {
        HTTPActionManager.sharedInstance().doActionWithRequestObject(
            requestObjectWithPath(path, params: params, completion: completion),
            success: {(result: AnyObject?) -> Void in
                if (result != nil && completion != nil) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let model: KTourApiResultModel = KTourApiResultModel(object: result)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            completion!(result: model, error: nil)
                        }
                    }
                }
            }, error: {(error: NSError?) -> Void in
                if (completion != nil) {
                    completion!(result: nil, error: error)
                }
        })
    }
    
    // ================================================================================================
    //  private
    // ================================================================================================
    
    private func requestObjectWithPath(path: KTourApiPath, params: NSDictionary?, completion: TourApiCallCompleteHandler?) -> HTTPRequestObject {
        let url: String = kKTourApiBasePath + "/" + languageType.rawValue + "/" + path.rawValue
        
        let _params = params != nil ? NSMutableDictionary(dictionary: params!) : NSMutableDictionary()
        _params[kKTourApiParamsDataType] = DataTypeJSON
        _params[kKTourApiParamsMobileApp] = bundleName
        _params[kKTourApiParamsMobileOS] = "IOS"
        _params[kKTourApiParamsServiceKey] = serviceKey
        
        let object: HTTPRequestObject = HTTPRequestObject()
        object.param = _params as [NSObject: AnyObject]?
        object.action = ["url": url,
                         "method": HTTPRequestMethodGet,
                         "contentType": ContentTypeApplicationXWWWFormURLEncoded,
                         "dataType": DataTypeJSON,
                         "timeout": (10),
                         "async": (true)]
        return object
    }
    
    // ================================================================================================
    //  getter/setter
    // ================================================================================================
    
    public var languageType: KTourApiLanguageType = KTourApiLanguageType.Chs
    public private(set) var serviceKey: String?
    
    private var bundleName: String {
        get {
            return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
        }
    }
}