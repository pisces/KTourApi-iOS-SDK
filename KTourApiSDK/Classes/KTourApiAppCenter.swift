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

public enum KTourContentType: Int {
    case
    Tour    = 76,
    Cultual = 78,
    Event   = 85,
    Leisure = 75,
    Stay    = 80,
    Shop    = 79,
    Food    = 82,
    Traffic = 77
};

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
    
    private var areaCodeDict: Dictionary<String, Int>?
    private var sigunguCodeDictGroup: Dictionary<Int, Dictionary<String, Int>> = Dictionary()
    
    // ================================================================================================
    //  Overridden: NSObject
    // ================================================================================================
    
    override init() {
        if let serviceKey: String = NSBundle.mainBundle().objectForInfoDictionaryKey(kKTourApiServiceKey) as? String {
            self.serviceKey = serviceKey.stringByRemovingPercentEncoding
        } else {
            #if DEBUG
                print("KTourApiServiceKey does not exist in info plist file!")
            #endif
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
    
    public func areaCode(name aName: String?, sigunguName: String?, completion: (areaCode: Int, sigunguCode: Int) -> Void) {
        if aName == nil || sigunguName == nil {
            completion(areaCode: 0, sigunguCode: 0)
            return
        }
        
        func errorState() {
            completion(areaCode: 0, sigunguCode: 0)
        }
        
        if let areaCodeDict = areaCodeDict {
            let areaCode = areaCodeDict[aName!]!
            
            if let sigunguCodeDict = sigunguCodeDictGroup[areaCode] {
                let sigunguCode = sigunguCodeDict[sigunguName!]!
                
                completion(areaCode: areaCode, sigunguCode: sigunguCode)
                
            } else {
                call(path: KTourApiPath.AreaCode,
                     params: KTourApiParameterSet.AreaCode(numOfRows: 100, pageNo: 1, areaCode: String(format: "%d", areaCode)),
                     completion: { (result: KTourApiResult<KTourApiResultItem.Area>?, error:NSError?) in
                        if error == nil {
                            if let items = result?.items {
                                var sigunguCodeDict = Dictionary<String, Int>()
                                
                                for item in items {
                                    sigunguCodeDict[item.name!] = item.code
                                }
                                
                                self.sigunguCodeDictGroup[areaCode] = sigunguCodeDict
                                self.areaCode(name: aName, sigunguName: sigunguName, completion: completion)
                            } else {
                                errorState()
                            }
                        } else {
                            errorState()
                        }
                })
            }
        } else {
            call(path: KTourApiPath.AreaCode,
                params: KTourApiParameterSet.AreaCode(numOfRows: 100, pageNo: 1, areaCode: nil),
                completion: { (result: KTourApiResult<KTourApiResultItem.Area>?, error:NSError?) in
                    if error == nil {
                        if let items = result?.items {
                            self.areaCodeDict = Dictionary<String, Int>()
                            
                            for item in items {
                                self.areaCodeDict![item.name!] = item.code
                            }
                            
                            self.areaCode(name: aName, sigunguName: sigunguName, completion: completion)
                        } else {
                            errorState()
                        }
                    } else {
                        errorState()
                    }
            })
        }
    }
    
    public func call<T: KTourApiParameterSet, Y: AbstractJSONModel>(path aPath: KTourApiPath,
                     params: T?,
                     completion: ((result: KTourApiResult<Y>?, error: NSError?) -> Void)?) -> NSURLSessionDataTask {
        return call(path: aPath, params: params, completion: completion, each: nil)
    }
    
    public func call<T: KTourApiParameterSet, Y: AbstractJSONModel>(path aPath: KTourApiPath,
                     params: T?,
                     completion: ((result: KTourApiResult<Y>?, error: NSError?) -> Void)?,
                     each: ((model: AbstractModel) -> Void)?) -> NSURLSessionDataTask {
        return HTTPActionManager.sharedInstance().doActionWithRequestObject(
            requestObjectWithPath(aPath, params: params, completion: completion),
            success: {(result: AnyObject?) -> Void in
                if (result != nil && completion != nil) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let model: KTourApiResult = KTourApiResult<Y>(object: result, each: each)
                        
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
        }).sessionDataTask
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