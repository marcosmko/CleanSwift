//
//  CollectionScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

open class CollectionScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: Scene<TInteractor, TInteractorProtocol, TRouter, TRouterProtocol>, CollectionSceneProtocol {
    
    @IBOutlet public var collectionView: UICollectionView!
    
    public lazy var collection = CollectionViewDataSource(collectionView: self.collectionView)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self.collection
        self.checkOverridesRefresh(type: type(of: self))
        self.setup(collection: self.collection)
        self.refresh()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
            self.collectionView.refreshControl = refreshControl
        }
    }
    
    open func beginRefreshing() {
        self.collectionView.refreshControl?.beginRefreshing()
    }
    
    open func endRefreshing() {
        self.collectionView.refreshControl?.endRefreshing()
    }
    
}
