//
//  DemoViewController.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 05/17/2016.
//  Copyright (c) 2016 Steve Kim. All rights reserved.
//

import UIKit
import KTourApiSDK

class DemoViewController: UITableViewController {
    private var paths: Array<KTourApiPath> = KTourApiPathGetAll()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier: String = "UITableViewCell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        cell!.textLabel?.text = paths[indexPath.row].rawValue
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller: ApiPathViewController = ApiPathViewController(nibName: "ApiPathView", bundle: NSBundle.mainBundle())
        controller.path = paths[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

