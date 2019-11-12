//
//  TableScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

open class TableScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: Scene<TInteractor, TInteractorProtocol, TRouter, TRouterProtocol> {
    
    @IBOutlet public var tableView: UITableView!
    
    public lazy var dataSource = TableViewDataSource(tableView: self.tableView, delegate: self)
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
    }
    
}
