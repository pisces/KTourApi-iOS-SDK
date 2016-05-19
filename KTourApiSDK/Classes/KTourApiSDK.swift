//
//  KTourApiSDK.swift
//  KTourApiSDK
//
//  Created by Steve Kim on 5/17/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//
//

import Foundation

class KTourApiSDK {
    public class var bundle: NSBundle {
        get {
            return NSBundle(path:NSBundle(forClass:self).pathForResource("KTourApiSDK", ofType:"bundle")!)!
        }
    }
}
