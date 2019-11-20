//
//  CollectionDisplayLogic.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 20/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public protocol CollectionDisplayLogic: DisplayLogic where Self: CollectionSceneProtocol {
    func display(viewModel: CollectionModel.EndRefreshing.ViewModel)
}

public extension CollectionDisplayLogic {
    
    func display(viewModel: CollectionModel.EndRefreshing.ViewModel) {
        self.endRefreshing()
    }
    
}
