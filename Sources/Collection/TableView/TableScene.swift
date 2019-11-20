//
//  TableScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

open class TableScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: Scene<TInteractor, TInteractorProtocol, TRouter, TRouterProtocol>, CollectionSceneProtocol {
    
    @IBOutlet public var tableView: UITableView!
    
    public lazy var collection = TableViewDataSource(tableView: self.tableView, delegate: self)
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.collection
        self.checkOverridesRefresh(type: type(of: self))
        self.setup(collection: self.collection)
        self.refresh()
    }
    
    open func setup(collection: TableViewDataSource) {
    }
    
    open func refresh() {
    }
    
    private func checkOverridesRefresh(type: TableScene.Type) {
        let originalMethod = class_getInstanceMethod(type, Selector(("refresh")))
        if originalMethod != nil {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: Selector(("refresh")), for: UIControl.Event.valueChanged)
            self.tableView.refreshControl = refreshControl
        }
    }
    
    open func beginRefreshing() {
        self.tableView.refreshControl?.beginRefreshing()
    }
    
    open func endRefreshing() {
        self.tableView.refreshControl?.endRefreshing()
    }
    
}
