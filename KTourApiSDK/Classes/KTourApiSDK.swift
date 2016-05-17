//
//  KTourApiSDK.swift
//  Pods
//
//  Created by Steve Kim on 5/17/16.
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
