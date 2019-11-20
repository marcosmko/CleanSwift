//
//  UICollectionViewExtension.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 20/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

extension UICollectionView {
    
    @available(iOS, introduced: 9)
    override open var refreshControl: UIRefreshControl? {
        get {
            if #available(iOS 10.0, *) {
                return super.refreshControl
            } else {
                for subview in self.subviews where subview is UIRefreshControl {
                    return subview as? UIRefreshControl
                }
                return nil
            }
        }
        set {
            if #available(iOS 10.0, *) {
                super.refreshControl = newValue
            } else {
                self.refreshControl?.removeFromSuperview()
                if let refreshControl = newValue {
                    self.addSubview(refreshControl)
                    self.sendSubviewToBack(refreshControl)
                    self.alwaysBounceVertical = true
                }
            }
        }
    }
    
}
