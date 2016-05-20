//
//  KTourApiParameterSet.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/17/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

import PSFoundation

public class KTourApiParameterSet: AbstractModel {
    public enum ArrangeType: String {
        case
        None        = "",
        Title       = "A",
        ViewDate    = "B",
        ModifyDate  = "C",
        RegistDate  = "D"
    }
    
    override public func format(value: AnyObject!, forKey key: String!) -> AnyObject! {
        if isBoolean(key: key) {
            return String(value) == "Y"
        }
        
        return super.format(value, forKey: key)
    }
    
    override public func unformat(value: AnyObject!, forKey key: String!) -> AnyObject! {
        if isBoolean(key: key) {
            return (value as! Bool) ? "Y" : "N"
        }
        
        return super.unformat(value, forKey: key)
    }
    
    internal func isBoolean(key aKey: String!) -> Bool {
        return false
    }
    
    public class Common: KTourApiParameterSet {
        public var numOfRows: Int = 0
        public var pageNo: Int = 0
        public var arrange: String?
        public var listYN: String?
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(listYN: String? = nil, arrange: ArrangeType = ArrangeType.None, numOfRows: Int, pageNo: Int) {
            super.init()
            
            self.listYN = listYN
            self.arrange = arrange.rawValue
            self.numOfRows = numOfRows
            self.pageNo = pageNo
        }
    }
    
    public class AreaCode: Common {
        public var areaCode: String?
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(listYN: String? = nil, arrange: ArrangeType = ArrangeType.None, numOfRows: Int, pageNo: Int, areaCode: String?) {
            super.init(listYN: listYN, arrange: arrange, numOfRows: numOfRows, pageNo: pageNo)
            
            self.areaCode = areaCode
        }
    }
    
    public class CategoryCode: Common {
        public var contentTypeId: String?
        public var cat1: String?
        public var cat2: String?
        public var cat3: String?
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(listYN: String? = nil, arrange: ArrangeType = ArrangeType.None, numOfRows: Int, pageNo: Int, contentTypeId: String?, cat1: String?, cat2: String?, cat3: String?) {
            super.init(listYN: listYN, arrange: arrange, numOfRows: numOfRows, pageNo: pageNo)
            
            self.contentTypeId = contentTypeId
            self.cat1 = cat1
            self.cat2 = cat2
            self.cat3 = cat3
        }
    }
    
    public class Content: KTourApiParameterSet {
        public var contentId: Int = 0
        public var contentTypeId: String?
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(contentId: Int, contentTypeId: String? = nil) {
            super.init()
            
            self.contentId = contentId
            self.contentTypeId = contentTypeId
        }
    }
    
    public class DetailCommon: Content {
        public var defaultYN: Bool = false
        public var firstImageYN: Bool = false
        public var areacodeYN: Bool = false
        public var catcodeYN: Bool = false
        public var addrinfoYN: Bool = false
        public var mapinfoYN: Bool = false
        public var overviewYN: Bool = false
        public var transGuideYN: Bool = false
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(contentId: Int, contentTypeId: String? = nil, defaultYN: Bool = true, firstImageYN: Bool = true, areacodeYN: Bool = true, catcodeYN: Bool = true, addrinfoYN: Bool = true, mapinfoYN: Bool = true, overviewYN: Bool = true, transGuideYN: Bool = true) {
            super.init(contentId: contentId, contentTypeId: contentTypeId)
            
            self.defaultYN = defaultYN
            self.firstImageYN = firstImageYN
            self.areacodeYN = areacodeYN
            self.catcodeYN = catcodeYN
            self.addrinfoYN = addrinfoYN
            self.mapinfoYN = mapinfoYN
            self.overviewYN = overviewYN
            self.transGuideYN = transGuideYN
        }
        
        override func isBoolean(key aKey: String!) -> Bool {
            return "defaultYN" == aKey || "firstImageYN" == aKey || "areacodeYN" == aKey || "catcodeYN" == aKey || "addrinfoYN" == aKey || "mapinfoYN" == aKey || "overviewYN" == aKey || "transGuideYN" == aKey
        }
    }
    
    public class DetailInfo: Content {
        public var detailYN: Bool = false
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(contentId: Int, contentTypeId: String!, detailYN: Bool = true) {
            super.init(contentId: contentId, contentTypeId: contentTypeId)
            
            self.detailYN = detailYN
        }
        
        override func isBoolean(key aKey: String!) -> Bool {
            return "detailYN" == aKey
        }
    }
    
    public class DetailImage: Content {
        public var imageYN: Bool = false
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(contentId: Int, contentTypeId: String!, imageYN: Bool = true) {
            super.init(contentId: contentId, contentTypeId: contentTypeId)
            
            self.imageYN = imageYN
        }
        
        override func isBoolean(key aKey: String!) -> Bool {
            return "imageYN" == aKey
        }
    }
    
    public class DetailIntro: Content {
        public var introYN: Bool = false
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(contentId: Int, contentTypeId: String!, introYN: Bool = true) {
            super.init(contentId: contentId, contentTypeId: contentTypeId)
            
            self.introYN = introYN
        }
        
        override func isBoolean(key aKey: String!) -> Bool {
            return "introYN" == aKey
        }
    }
    
    public class AreaBasedList: CategoryCode {
        public var areaCode: String?
        public var sigunguCode: String?
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(listYN: String? = nil, arrange: ArrangeType = ArrangeType.None, numOfRows: Int, pageNo: Int, contentTypeId: String?, cat1: String?, cat2: String?, cat3: String?, areaCode: String?,  sigunguCode: String?) {
            super.init(listYN: listYN, arrange: arrange, numOfRows: numOfRows, pageNo: pageNo, contentTypeId: contentTypeId, cat1: cat1, cat2: cat2, cat3: cat3)
            
            self.areaCode = areaCode
            self.sigunguCode = sigunguCode
        }
    }
    
    public class LocationBasedList: Common {
        public var mapX: Float = 0.0
        public var mapY: Float = 0.0
        public var radius: Int = 0
        public var contentTypeId: String?
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(listYN: String? = nil, arrange: ArrangeType = ArrangeType.None, numOfRows: Int, pageNo: Int, contentTypeId: String?, mapX: Float, mapY: Float, radius: Int = 1000) {
            super.init(listYN: listYN, arrange: arrange, numOfRows: numOfRows, pageNo: pageNo)
            
            self.contentTypeId = contentTypeId
            self.mapX = mapX
            self.mapY = mapY
            self.radius = radius
        }
    }
    
    public class SearchFestival: Common {
        public var areaCode: String?
        public var sigunguCode: String?
        public var eventEndDate: NSDate?
        public var eventStartDate: NSDate?
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(listYN: String? = nil, arrange: ArrangeType = ArrangeType.None, numOfRows: Int, pageNo: Int, eventStartDate: NSDate?, eventEndDate: NSDate?, areaCode: String?,  sigunguCode: String?) {
            super.init(listYN: listYN, arrange: arrange, numOfRows: numOfRows, pageNo: pageNo)
            
            self.eventStartDate = eventStartDate
            self.eventEndDate = eventEndDate
            self.areaCode = areaCode
            self.sigunguCode = sigunguCode
        }
    }
    
    public class SearchKeyword: CategoryCode {
        public var areaCode: String?
        public var sigunguCode: String?
        public var keyword: String?
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(listYN: String? = nil, arrange: ArrangeType = ArrangeType.None, numOfRows: Int, pageNo: Int, keyword: String?, contentTypeId: String?, cat1: String?, cat2: String?, cat3: String?, areaCode: String?,  sigunguCode: String?) {
            super.init(listYN: listYN, arrange: arrange, numOfRows: numOfRows, pageNo: pageNo, contentTypeId: contentTypeId, cat1: cat1, cat2: cat2, cat3: cat3)
            
            self.keyword = keyword
            self.areaCode = areaCode
            self.sigunguCode = sigunguCode
        }
    }
    
    public class SearchStay: Common {
        public var hanOk: Bool = false
        public var benikia: Bool = false
        public var goodStay: Bool = false
        public var areaCode: String?
        public var contentTypeId: String?
        public var sigunguCode: String?
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public init(listYN: String? = nil, arrange: ArrangeType = ArrangeType.None, numOfRows: Int, pageNo: Int, hanOk: Bool = false, benikia: Bool = false, goodStay: Bool = false, contentTypeId: String?, areaCode: String?,  sigunguCode: String?) {
            super.init(listYN: listYN, arrange: arrange, numOfRows: numOfRows, pageNo: pageNo)
            
            self.hanOk = hanOk
            self.benikia = benikia
            self.goodStay = goodStay
            self.contentTypeId = contentTypeId
            self.areaCode = areaCode
            self.sigunguCode = sigunguCode
        }
    }
}