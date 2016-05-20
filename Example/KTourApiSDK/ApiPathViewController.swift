//
//  ApiPathViewController.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import KTourApiSDK

class ApiPathViewController: UITableViewController {
    private var items: Array<KTourApiResultItem> = []
    
    var path: KTourApiPath! {
        get {
            return nil
        }
        
        set(value) {
            self.title = value.rawValue
            
            call(path: value)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 54
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier: String = "DynamicHeightViewCell"
        var cell: DynamicHeightViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? DynamicHeightViewCell
        
        if cell == nil {
            cell = DynamicHeightViewCell.create()
        }
        
        cell!.titleLabel?.text = items[indexPath.row].dictionary.description.stringByReplacingOccurrencesOfString(", ", withString: ",\n")
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item: KTourApiResultItem = items[indexPath.row]
        
        if item .isKindOfClass(KTourApiResultItem.POI.self) {
            let controller: POIViewController = POIViewController(nibName: "POIView", bundle: NSBundle.mainBundle())
            controller.model = item as! KTourApiResultItem.POI
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func call(path aPath: KTourApiPath) -> Void {
        switch aPath {
        case KTourApiPath.AreaCode:
            KTourApiAppCenter.defaultCenter().call(
                path: aPath,
                params: KTourApiParameterSet.AreaCode(numOfRows: 10, pageNo: 1, areaCode: nil),
                completion: {(result: KTourApiResult<KTourApiResultItem.Area>?, error:NSError?) -> Void in
                    self.addItemsWithResult(result, error: error)
            })
        case KTourApiPath.CategoryCode:
            KTourApiAppCenter.defaultCenter().call(
                path: aPath,
                params: KTourApiParameterSet.CategoryCode(numOfRows: 10, pageNo: 1, contentTypeId: nil, cat1: nil, cat2: nil, cat3: nil),
                completion: {(result: KTourApiResult<KTourApiResultItem.Category>?, error:NSError?) -> Void in
                    self.addItemsWithResult(result, error: error)
            })
        case KTourApiPath.AreaBasedList:
            KTourApiAppCenter.defaultCenter().call(
                path: aPath,
                params: KTourApiParameterSet.AreaBasedList(numOfRows: 10, pageNo: 1, contentTypeId: nil, cat1: nil, cat2: nil, cat3: nil, areaCode: nil, sigunguCode: nil),
                completion: {(result: KTourApiResult<KTourApiResultItem.POI>?, error:NSError?) -> Void in
                    self.addItemsWithResult(result, error: error)
            })
        case KTourApiPath.LocationBasedList:
            KTourApiAppCenter.defaultCenter().call(
                path: aPath,
                params: KTourApiParameterSet.LocationBasedList(numOfRows: 10, pageNo: 1, contentTypeId: nil, mapX: 126.981611, mapY: 37.568477),
                completion: {(result: KTourApiResult<KTourApiResultItem.POI>?, error:NSError?) -> Void in
                    self.addItemsWithResult(result, error: error)
            })
        case KTourApiPath.SearchFestival:
            KTourApiAppCenter.defaultCenter().call(
                path: aPath,
                params: KTourApiParameterSet.SearchFestival(numOfRows: 10, pageNo: 1, eventStartDate: nil, eventEndDate: nil, areaCode: nil, sigunguCode: nil),
                completion: {(result: KTourApiResult<KTourApiResultItem.FestivalPOI>?, error:NSError?) -> Void in
                    self.addItemsWithResult(result, error: error)
            })
        case KTourApiPath.SearchKeyword:
            KTourApiAppCenter.defaultCenter().call(
                path: aPath,
                params: KTourApiParameterSet.SearchKeyword(numOfRows: 10, pageNo: 1, keyword: "首尔", contentTypeId: nil, cat1: nil, cat2: nil, cat3: nil, areaCode: nil, sigunguCode: nil),
                completion: {(result: KTourApiResult<KTourApiResultItem.POI>?, error:NSError?) -> Void in
                    self.addItemsWithResult(result, error: error)
            })
        case KTourApiPath.SearchStay:
            KTourApiAppCenter.defaultCenter().call(
                path: aPath,
                params: KTourApiParameterSet.SearchStay(numOfRows: 10, pageNo: 1, contentTypeId: nil, areaCode: nil, sigunguCode: nil),
                completion: {(result: KTourApiResult<KTourApiResultItem.StayPOI>?, error:NSError?) -> Void in
                    self.addItemsWithResult(result, error: error)
            })
        default:
            break
        }
    }
    
    func addItemsWithResult<T: KTourApiResultItem>(result: KTourApiResult<T>?, error: NSError?) -> Void {
        if error == nil {
            if let items: Array<KTourApiResultItem>? = result!.items {
                self.items.appendContentsOf(items!)
                tableView.reloadData()
                tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            }
        }
    }
}