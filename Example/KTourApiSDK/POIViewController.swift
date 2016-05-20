//
//  POIViewController.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import KTourApiSDK

class POIViewController: UITableViewController {
    var detail: KTourApiResultItem.POIDetail?;
    var intro: KTourApiResultItem.POIDetailIntro?;
    var info: KTourApiResultItem.POIDetailInfo?;
    var image: KTourApiResultItem.POIDetailImage?;
    
    var model: KTourApiResultItem.POI! {
        get {
            return nil
        }
        
        set(value) {
            KTourApiAppCenter.defaultCenter().call(
                path: KTourApiPath.DetailCommon,
                params: KTourApiParameterSet.DetailCommon(contentId: value.contentid),
                completion: {(result: KTourApiResult<KTourApiResultItem.POIDetail>?, error:NSError?) -> Void in
                    self.detail = result?.items?.first
                    self.reloadData()
            })
            
            KTourApiAppCenter.defaultCenter().call(
                path: KTourApiPath.DetailIntro,
                params: KTourApiParameterSet.DetailIntro(contentId: value.contentid, contentTypeId: String(value.contenttypeid)),
                completion: {(result: KTourApiResult<KTourApiResultItem.POIDetailIntro>?, error:NSError?) -> Void in
                    self.intro = result?.items?.first
                    self.reloadData()
            })
            
            KTourApiAppCenter.defaultCenter().call(
                path: KTourApiPath.DetailInfo,
                params: KTourApiParameterSet.DetailInfo(contentId: value.contentid, contentTypeId: String(value.contenttypeid)),
                completion: {(result: KTourApiResult<KTourApiResultItem.POIDetailInfo>?, error:NSError?) -> Void in
                    self.info = result?.items?.first
                    self.reloadData()
            })
            
            KTourApiAppCenter.defaultCenter().call(
                path: KTourApiPath.DetailImage,
                params: KTourApiParameterSet.DetailImage(contentId: value.masterid, contentTypeId: String(value.contenttypeid)),
                completion: {(result: KTourApiResult<KTourApiResultItem.POIDetailImage>?, error:NSError?) -> Void in
                    self.image = result?.items?.first
                    self.reloadData()
            })
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
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier: String = "DynamicHeightViewCell"
        var cell: DynamicHeightViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? DynamicHeightViewCell
        
        if cell == nil {
            cell = DynamicHeightViewCell.create()
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        if indexPath.row == 0 {
            cell!.titleLabel?.text = detail?.dictionary.description != nil ? "Detail\n\n" + (detail?.dictionary.description)! : nil
        } else if indexPath.row == 1 {
            cell!.titleLabel?.text = intro?.dictionary.description != nil ? "Intro\n\n" + (intro?.dictionary.description)! : nil
        } else if indexPath.row == 2 {
            cell!.titleLabel?.text = info?.dictionary.description != nil ? "Info\n\n" + (info?.dictionary.description)! : nil
        } else if indexPath.row == 3 {
            cell!.titleLabel?.text = image?.dictionary.description != nil ? "Images\n\n" +
                (image?.dictionary.description)! : nil
        }
        
        cell?.titleLabel?.text = cell?.titleLabel?.text?.stringByReplacingOccurrencesOfString(", ", withString: ",\n")
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func reloadData() -> Void {
        self.tableView.reloadData()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
    }
}
