//
//  KTourApiAppCenter.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/17/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import PSFoundation
import w3action

public enum KTourApiErrorDomain: String {
    case
    Unknown = "Unknown error!",
    AreaCodeDoesNotExist = "Area code does not exist!",
    SigunguCodeDoesNotExist = "Sigungu code does not exist!"
}

public enum KTourApiErrorCode: Int {
    case
    Unknown = 20001,
    AreaCodeDoesNotExist = 20002,
    SigunguCodeDoesNotExist = 20003
}

public enum KTourApiLanguageType: String {
    case
    Chs = "ChsService",
    Cht = "ChtService",
    Eng = "EngService",
    Ger = "GerService",
    Fre = "FreService",
    Jpn = "JpnService",
    Kor = "KorService",
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

public func KTourApiErrorCodeEquals(rawValue: Int) -> Bool {
    return rawValue == KTourApiErrorCode.Unknown.rawValue ||
        rawValue == KTourApiErrorCode.AreaCodeDoesNotExist.rawValue ||
        rawValue == KTourApiErrorCode.SigunguCodeDoesNotExist.rawValue
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
    let kKTourApiAreaCodeDict = "KTourApiAreaCodeDictKey"
    let kKTourApiBasePath = "http://api.visitkorea.or.kr/openapi/service/rest"
    let kKTourApiServiceKey = "KTourApiServiceKey"
    let kKTourApiParamsDataType = "_type"
    let kKTourApiParamsMobileApp = "MobileApp"
    let kKTourApiParamsMobileOS = "MobileOS"
    let kKTourApiParamsServiceKey = "ServiceKey"
    let kKTourApiSigunguCodeDictGroup = "KTourApiSigunguCodeDictGroupKey"
    
    public typealias CodeSearchCompletion = (areaCode: Int, sigunguCode: Int, error: NSError?) -> Void
    
    private var areaCodeDict: Dictionary<String, Int>?
    private var sigunguCodeDictGroup: Dictionary<Int, Dictionary<String, Int>> = Dictionary()
    
    // ================================================================================================
    //  Overridden: NSObject
    // ================================================================================================
    
    override init() {
        if let serviceKey: String = NSBundle.mainBundle().objectForInfoDictionaryKey(kKTourApiServiceKey) as? String {
            self.serviceKey = serviceKey.stringByRemovingPercentEncoding
            areaCodeDict = NSUserDefaults.standardUserDefaults().objectForKey(kKTourApiAreaCodeDict) as? Dictionary<String, Int>
            
            if let data = NSUserDefaults.standardUserDefaults().objectForKey(kKTourApiSigunguCodeDictGroup) as? NSData {
                if let sigunguCodeDictGroup = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Dictionary<Int, Dictionary<String, Int>> {
                    self.sigunguCodeDictGroup = sigunguCodeDictGroup
                }
            }
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
    
    public func areaCode(name aName: String?, sigunguName: String?, completion: CodeSearchCompletion) {
        if aName == nil || sigunguName == nil {
            self.errorCompletion(completion)
            return
        }
        
        if let areaCodeDict = areaCodeDict {
            if let areaCode = areaCodeDict[aName!] {
                sigunguCode(areadCode: areaCode, sigunguName: sigunguName, completion: completion)
            } else {
                self.errorCompletion(completion)
            }
        } else {
            call(path: KTourApiPath.AreaCode,
                params: KTourApiParameterSet.AreaCode(numOfRows: 100, pageNo: 1, areaCode: nil),
                completion: { (result: KTourApiResult<KTourApiResultItem.Area>?, error:NSError?) in
                    if error == nil {
                        if let items = result?.items {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                                self.areaCodeDict = Dictionary<String, Int>()
                                
                                for item in items {
                                    self.areaCodeDict![item.name!] = item.code
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.areaCode(name: aName, sigunguName: sigunguName, completion: completion)
                                    NSUserDefaults.standardUserDefaults().setObject(self.areaCodeDict, forKey: self.kKTourApiAreaCodeDict)
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                })
                            })
                        } else {
                            self.errorCompletion(completion)
                        }
                    } else {
                        self.errorCompletion(completion)
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
    
    public func clearCaches() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(kKTourApiAreaCodeDict)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(kKTourApiSigunguCodeDictGroup)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func sigunguCode(areadCode aAreaCode: Int, sigunguName: String?, completion: CodeSearchCompletion) {
        if let sigunguCodeDict = sigunguCodeDictGroup[aAreaCode] {
            completion(areaCode: aAreaCode, sigunguCode: sigunguCodeDict[sigunguName!]!, error: nil)
        } else {
            call(path: KTourApiPath.AreaCode,
                 params: KTourApiParameterSet.AreaCode(numOfRows: 100, pageNo: 1, areaCode: String(format: "%d", aAreaCode)),
                 completion: { (result: KTourApiResult<KTourApiResultItem.Area>?, error:NSError?) in
                    if error == nil {
                        if let items = result?.items {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                                var sigunguCodeDict = Dictionary<String, Int>()
                                
                                for item in items {
                                    sigunguCodeDict[item.name!] = item.code
                                }
                                
                                self.sigunguCodeDictGroup[aAreaCode] = sigunguCodeDict
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.sigunguCode(areadCode: aAreaCode, sigunguName: sigunguName, completion: completion)
                                    
                                    let data = NSKeyedArchiver.archivedDataWithRootObject(self.sigunguCodeDictGroup)
                                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: self.kKTourApiSigunguCodeDictGroup)
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                })
                            })
                        } else {
                            self.errorCompletion(areaCode: aAreaCode, sigunguCode: 0, completion: completion)
                            
                        }
                    } else {
                        self.errorCompletion(areaCode: aAreaCode, sigunguCode: 0, completion: completion)
                    }
            })
        }
    }
    
    // ================================================================================================
    //  private
    // ================================================================================================
    
    private func errorCompletion(completion: CodeSearchCompletion) {
        errorCompletion(areaCode: 0, sigunguCode: 0, completion: completion)
    }
    
    private func errorCompletion(areaCode aAreaCode: Int = 0, sigunguCode: Int = 0, completion: CodeSearchCompletion) {
        var errorCode = KTourApiErrorCode.Unknown
        var errorDomain = KTourApiErrorDomain.Unknown
        if aAreaCode < 1 {
            errorCode = KTourApiErrorCode.AreaCodeDoesNotExist
            errorDomain = KTourApiErrorDomain.AreaCodeDoesNotExist
        } else if sigunguCode < 1 {
            errorCode = KTourApiErrorCode.SigunguCodeDoesNotExist
            errorDomain = KTourApiErrorDomain.SigunguCodeDoesNotExist
        }
        
        completion(areaCode: aAreaCode, sigunguCode: sigunguCode, error: NSError(domain: errorDomain.rawValue, code: errorCode.rawValue, userInfo: nil))
    }
    
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