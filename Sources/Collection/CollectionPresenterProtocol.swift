//
//  CollectionPresenterProtocol.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 20/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public protocol CollectionPresenterProtocol: PresenterProtocol {
    func present(response: CollectionModel.EndRefreshing.Response)
}

public extension CollectionPresenterProtocol {
    
    func present(response: CollectionModel.EndRefreshing.Response) {
        QueueManager.shared.execute(BlockOperation(block: {
            for (_, value) in Mirror(reflecting: self).children where value is CollectionDisplayLogic {
                guard let collectionDisplay = value as? CollectionDisplayLogic else { return }
                collectionDisplay.display(viewModel: CollectionModel.EndRefreshing.ViewModel())
            }
        }), on: .main)
    }
    
}
