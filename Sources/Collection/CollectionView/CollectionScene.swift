//
//  CollectionScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

open class CollectionScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: GenericCollectionScene<TInteractor, TInteractorProtocol, TRouter, TRouterProtocol, UICollectionView, CollectionViewDataSource> {
    
    @IBOutlet public override var collectionView: UICollectionView! {
        get { super.collectionView }
        set { super.collectionView = newValue }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self.collection
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension GenericCollectionScene: CollectionDataSourcePrefetching {
    
    func prefetch() {
        (self.interactor as? CollectionInteractorProtocol)?.fetch(request: CollectionModel.Get.Request(reload: false))
    }
    
}
