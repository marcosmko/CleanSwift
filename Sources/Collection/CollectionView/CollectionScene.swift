//
//  CollectionScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

open class CollectionScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: Scene<TInteractor, TInteractorProtocol, TRouter, TRouterProtocol> {
    
    @IBOutlet public var collectionView: UICollectionView!
    
    public lazy var collectionDataSource = CollectionViewDataSource(collectionView: self.collectionView)
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self.collectionDataSource
    }
    
}
