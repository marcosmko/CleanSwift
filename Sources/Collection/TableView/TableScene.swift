//
//  TableScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

open class TableScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: GenericCollectionScene<TInteractor, TInteractorProtocol, TRouter, TRouterProtocol, UITableView, TableViewDataSource> {
    
    @IBOutlet override public var collectionView: UITableView! {
        get { super.collectionView }
        set {
            super.collectionView = newValue
            collectionView.rowHeight = UITableView.automaticDimension
            collectionView.sectionHeaderHeight = UITableView.automaticDimension
            collectionView.estimatedSectionHeaderHeight = CGFloat.leastNonzeroMagnitude
            collectionView.sectionFooterHeight = UITableView.automaticDimension
            collectionView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
        }
    }
    
    private var heights: [IndexPath: CGFloat] = [:]
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self.collection
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let headerView = collectionView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            if height != headerView.frame.height {
                headerView.frame.size.height = height
                self.collectionView.tableHeaderView = headerView
                self.collectionView.performBatchUpdates({})
            }
        }
    }
    
    public func clearCache() {
        self.heights = [:]
    }
    
    private func checkIsInfiniteScroll() {
        if self.interactor is CollectionInteractorProtocol {
            if #available(iOS 10.0, *) {
                self.collectionView.prefetchDataSource = self.collection
            } else {
                self.collectionView.delegate = self as? UITableViewDelegate
            }
        }
    }
    
    // This will be used for to fetch more rows automatically for iOS < 10
    @objc
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if #available(iOS 10.0, *) { } else {
            if (scrollView.contentOffset.y) >= (scrollView.contentSize.height - 2 * scrollView.frame.size.height) {
                (self.interactor as? CollectionInteractorProtocol)?.fetch(request: CollectionModel.Get.Request(reload: false))
            }
        }
    }
    
    // This will be used to cache cell height
    @objc
    public func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        return self.heights[indexPath] = cell.bounds.height
    }
    
    // This will be used to return pre calculated height
    @objc
    open func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return self.heights[indexPath] ?? UITableView.automaticDimension
    }
    
}
