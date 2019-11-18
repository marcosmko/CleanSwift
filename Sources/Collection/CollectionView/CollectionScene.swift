//
//  CollectionScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

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

open class CollectionScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: Scene<TInteractor, TInteractorProtocol, TRouter, TRouterProtocol> {
    
    @IBOutlet public var collectionView: UICollectionView!
    
    public lazy var collection = CollectionViewDataSource(collectionView: self.collectionView)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self.collection
        self.checkOverridesRefresh(type: type(of: self))
        self.setup(collection: self.collection)
        self.refresh()
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    open func setup(collection: CollectionViewDataSource) {
    }
    
    open func refresh() {
    }
    
    private func checkOverridesRefresh(type: CollectionScene.Type) {
        let originalMethod = class_getInstanceMethod(type, Selector(("refresh")))
        if originalMethod != nil {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: Selector(("refresh")), for: UIControl.Event.valueChanged)
            collectionView.refreshControl = refreshControl
        }
    }
    
    open func beginRefreshing() {
        self.collectionView.refreshControl?.beginRefreshing()
    }
    
    open func endRefreshing() {
        self.collectionView.refreshControl?.endRefreshing()
    }
    
}
