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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier: String = "UITableViewCell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        
        cell!.textLabel?.text = items[indexPath.row].dictionary.description
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func call(path aPath: KTourApiPath) -> Void {
        switch aPath {
        case KTourApiPath.AreaCode:
            KTourApiAppCenter.defaultCenter().call(
                path: aPath,
                params: KTourApiParameterSet.AreaCode(numOfRows: 10, pageNo: 1, areaCode: nil),
                completion: {(result: KTourApiResult<KTourApiResultItem.Area>?, error:NSError?) -> Void in
                    if error == nil {
                        if let items: Array<KTourApiResultItem> = result!.items! {
                            self.items.appendContentsOf(items)
                            self.tableView.reloadData()
                        }
                    }
            })
        case KTourApiPath.CategoryCode:
            KTourApiAppCenter.defaultCenter().call(
                path: aPath,
                params: KTourApiParameterSet.CategoryCode(,
                completion: {(result: KTourApiResult<KTourApiResultItem.Area>?, error:NSError?) -> Void in
                    if error == nil {
                        if let items: Array<KTourApiResultItem> = result!.items! {
                            self.items.appendContentsOf(items)
                            self.tableView.reloadData()
                        }
                    }
            })
        default:
            break
        }
    }
}