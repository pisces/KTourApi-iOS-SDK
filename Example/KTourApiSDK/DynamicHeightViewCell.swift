//
//  DynamicHeightViewCell.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class DynamicHeightViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?

    static func create() -> DynamicHeightViewCell? {
        let views: Array = NSBundle.mainBundle().loadNibNamed(String(self), owner: nil, options: nil)
        
        for view in views {
            if view.isKindOfClass(self) {
                return view as? DynamicHeightViewCell
            }
        }
        
        return nil
    }
}
