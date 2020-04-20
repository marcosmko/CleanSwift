//
//  TableScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

protocol TableDisplayLogic: DisplayLogic {
    func display(viewModel: TableModel.GetPosts.ViewModel)
    func display(viewModel: TableModel.UpdatePosts.ViewModel)
}

open class TableScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: Scene<TInteractor, TInteractorProtocol, TRouter, TRouterProtocol>, CollectionSceneProtocol, TableDisplayLogic, UITableViewDelegate {
    
    @IBOutlet public private(set) var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.sectionHeaderHeight = UITableView.automaticDimension
            tableView.estimatedSectionHeaderHeight = CGFloat.leastNonzeroMagnitude
            tableView.sectionFooterHeight = UITableView.automaticDimension
            tableView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
        }
    }
    
    public lazy var collection = TableViewDataSource(tableView: self.tableView, dataSourcePrefetching: self, delegate: self)
    public var pageSize: Int = -1 {
        didSet {
            self.collection.pageSize = self.pageSize
            (self.interactor as? TableDataSource)?.pageSize = self.pageSize
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.pageSize = 25
        self.tableView.dataSource = self.collection
        
        self.checkOverridesRefresh(type: type(of: self))
        self.checkIsInfiniteScroll()
        self.setup(collection: self.collection)
        self.refresh()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            if height != headerView.frame.height {
                headerView.frame.size.height = height
                self.tableView.tableHeaderView = headerView
                if #available(iOS 11.0, *) {
                    self.tableView.performBatchUpdates({})
                } else {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    open func setup(collection: TableViewDataSource) {
    }
    
    open func refresh() {
        self.collection.clear()
        (self.interactor as? TableInteractorProtocol)?.reload(request: TableModel.SetClear.Request())
    }
    
    private func checkOverridesRefresh(type: TableScene.Type) {
        let originalMethod = class_getInstanceMethod(type, Selector(("refresh")))
        if originalMethod != nil {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: Selector(("refresh")), for: UIControl.Event.valueChanged)
            self.tableView.refreshControl = refreshControl
        }
    }
    
    private func checkIsInfiniteScroll() {
        if self.interactor is TableInteractorProtocol {
            if #available(iOS 10.0, *) {
                self.tableView.prefetchDataSource = self.collection
            } else {
                self.tableView.delegate = self
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if #available(iOS 10.0, *) { } else {
            if (scrollView.contentOffset.y) >= (scrollView.contentSize.height - 2 * scrollView.frame.size.height) {
                (self.interactor as? TableInteractorProtocol)?.fetch(request: TableModel.GetPosts.Request())
            }
        }
    }
    
    open func beginRefreshing() {
        self.tableView.refreshControl?.beginRefreshing()
    }
    
    open func endRefreshing() {
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func display(viewModel: TableModel.GetPosts.ViewModel) {
        self.collection.insert(sections: viewModel.sections)
    }
    
    func display(viewModel: TableModel.UpdatePosts.ViewModel) {
        self.collection.update(sections: viewModel.sections)
    }
    
}

extension TableScene: TableViewDataSourcePrefetching {
    
    func tableViewPrefetch() {
        (self.interactor as? TableInteractorProtocol)?.fetch(request: TableModel.GetPosts.Request())
    }
    
}
