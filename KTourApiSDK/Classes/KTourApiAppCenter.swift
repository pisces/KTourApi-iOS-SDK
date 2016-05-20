//
//  KTourApiAppCenter.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/17/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import PSFoundation
import w3action

public enum KTourApiLanguageType: String {
    case
    Chs = "ChsService",
    Cht = "ChtService",
    Eng = "EngService",
    Ger = "GerService",
    Fre = "FreService",
    Jpn = "JpnService",
    Rus = "RusService",
    Spn = "SpnService"
}

public enum KTourApiPath: String {
    case
    AreaCode            = "areaCode",
    AreaBasedList       = "areaBasedList",
    CategoryCode        = "categoryCode",
    DetailCommon        = "detailCommon",
    DetailImage         = "detailImage",
    DetailInfo          = "detailInfo",
    DetailIntro         = "detailIntro",
    LocationBasedList   = "locationBasedList",
    SearchFestival      = "searchFestival",
    SearchKeyword       = "searchKeyword",
    SearchStay          = "searchStay"
}

public func KTourApiPathGetAll() -> Array<KTourApiPath> {
    return [KTourApiPath.AreaCode,
            KTourApiPath.CategoryCode,
            KTourApiPath.AreaBasedList,
            KTourApiPath.LocationBasedList,
            KTourApiPath.SearchFestival,
            KTourApiPath.SearchKeyword,
            KTourApiPath.SearchStay]
}

public class KTourApiAppCenter: NSObject {
    let kKTourApiServiceKey: String = "KTourApiServiceKey"
    let kKTourApiBasePath: String = "http://api.visitkorea.or.kr/openapi/service/rest"
    let kKTourApiParamsDataType = "_type"
    let kKTourApiParamsMobileApp = "MobileApp"
    let kKTourApiParamsMobileOS = "MobileOS"
    let kKTourApiParamsServiceKey = "ServiceKey"
    
    // ================================================================================================
    //  Overridden: NSObject
    // ================================================================================================
    
    override init() {
        if let serviceKey: String = (NSBundle.mainBundle().objectForInfoDictionaryKey(kKTourApiServiceKey) as! String) {
            self.serviceKey = serviceKey.stringByRemovingPercentEncoding
        } else {
            print("KTourApiServiceKey does not exist in info plist file!")
        }
    }
    
    // ================================================================================================
    //  Public
    // ================================================================================================
    
    static public func defaultCenter() -> KTourApiAppCenter {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: KTourApiAppCenter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = KTourApiAppCenter()
        }
        return Static.instance!
    }
    
    public func call<T: KTourApiParameterSet, Y: AbstractJSONModel>(path aPath: KTourApiPath,
                     params: T?,
                     completion: ((result: KTourApiResult<Y>?, error: NSError?) -> Void)?) {
        HTTPActionManager.sharedInstance().doActionWithRequestObject(
            requestObjectWithPath(aPath, params: params, completion: completion),
            success: {(result: AnyObject?) -> Void in
                if (result != nil && completion != nil) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let model: KTourApiResult = KTourApiResult<Y>(object: result)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            if (model.resultCode == KTourApiResultCode.NORMAL_CODE) {
                                completion!(result: model, error: nil)
                            } else {
                                completion!(result: model, error: NSError(domain: KTourApiGetErrorDomain(model.resultCode), code: model.resultCode.rawValue, userInfo: nil))
                            }
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
    
    private func requestObjectWithPath<T: KTourApiParameterSet, Y: AbstractJSONModel>(path: KTourApiPath,
                                       params: T?,
                                       completion: ((result: Y?, error: NSError?) -> Void)?) -> HTTPRequestObject {
        let url: String = kKTourApiBasePath + "/" + languageType.rawValue + "/" + path.rawValue
        
        let _params = params != nil ? NSMutableDictionary(dictionary: params!.dictionary) : NSMutableDictionary()
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