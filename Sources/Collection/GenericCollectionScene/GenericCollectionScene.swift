//
//  GenericCollectionScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 17/06/20.
//  Copyright © 2020 Undercaffeine. All rights reserved.
//

import UIKit

public protocol CollectionDisplayLogic: DisplayLogic {
    func display(viewModel: CollectionModel.Get.ViewModel)
    func display(viewModel: CollectionModel.Update.ViewModel)
    func display(viewModel: CollectionModel.Delete.ViewModel)
    func display(viewModel: CollectionModel.EndRefreshing.ViewModel)
}

open class GenericCollectionScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol, TView: NSObject & CollectionView, TCollectionDataSource: GenericCollectionDataSource<TView>>: Scene<TInteractor, TInteractorProtocol, TRouter, TRouterProtocol>, CollectionDisplayLogic {
    
    public internal(set) var collectionView: TView!
    
    public lazy var collection: TCollectionDataSource =
        TCollectionDataSource(
            collection: collectionView,
            dataSourcePrefetching: self,
            delegate: self
    )
    
    public var pageSize: Int = -1 {
        didSet {
            self.collection.pageSize = self.pageSize
            (self.interactor as? CollectionDataSource)?.pageSize = self.pageSize
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.pageSize = 25
        self.setup(collection: self.collection)
        self.checkOverridesRefresh(type: type(of: self))
        self.checkIsInfiniteScroll()
        self.refresh()
    }
    
    private func checkOverridesRefresh(type: NSObject.Type) {
        let originalMethod = class_getInstanceMethod(type, Selector(("refresh")))
        if originalMethod != nil {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: Selector(("refresh")), for: UIControl.Event.valueChanged)
            self.collectionView.refreshControl = refreshControl
        }
    }
    
    private func checkIsInfiniteScroll() {
        if self.interactor is CollectionInteractorProtocol {
            if #available(iOS 10.0, *) {
                self.collectionView.prefetchDataSource(self.collection)
            } else {
                self.collectionView.delegate(self)
            }
        }
    }
    
    open func setup(collection: TCollectionDataSource) {
    }
    
    open func refresh() {
        (self.interactor as? CollectionInteractorProtocol)?.reload(request: CollectionModel.SetClear.Request())
    }
    
    public func display(viewModel: CollectionModel.Get.ViewModel) {
        // TODO: if is infinite scroll, if needs reloading, reload last section
        if !(self.interactor is CollectionInteractorProtocol) && viewModel.reload {
            self.collection.clear()
        }
        self.collection.insert(sections: viewModel.sections, scrollToLast: viewModel.scrollToLast)
    }
    
    public func display(viewModel: CollectionModel.Update.ViewModel) {
        self.collection.update(sections: viewModel.sections)
    }
    
    public func display(viewModel: CollectionModel.Delete.ViewModel) {
        self.collection.remove(sections: viewModel.sections)
    }
    
    public func display(viewModel: CollectionModel.EndRefreshing.ViewModel) {
        self.endRefreshing()
    }
    
    open func beginRefreshing() {
        self.collectionView.refreshControl?.beginRefreshing()
    }
    
    open func endRefreshing() {
        self.collectionView.refreshControl?.endRefreshing()
    }
    
}
