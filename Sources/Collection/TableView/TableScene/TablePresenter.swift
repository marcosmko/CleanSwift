//
//  TablePresenter.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 16/04/20.
//  Copyright © 2020 Undercaffeine. All rights reserved.
//

import Foundation

public protocol TablePresenterProtocol: CollectionPresenterProtocol {
    func present(response: TableModel.GetPosts.Response)
    func present(response: TableModel.UpdatePosts.Response)
}

open class TablePresenter<TDisplayLogic, TEntity>: Presenter<TDisplayLogic> {
    
    public func present(response: TableModel.GetPosts.Response) {
        QueueManager.shared.execute(BlockOperation(block: {
            var items: [ViewModel] = []
            for item in response.objects {
                items.append(self.prepare(object: item as! TEntity))
            }
            let section = Section(items: items)
            (self.viewController as? TableDisplayLogic)?.display(viewModel: TableModel.GetPosts.ViewModel(sections: [section]))
        }), on: .main)
    }
    
    public func present(response: TableModel.UpdatePosts.Response) {
        QueueManager.shared.execute(BlockOperation(block: {
            var items: [ViewModel] = []
            for item in response.objects {
                items.append(self.prepare(object: item as! TEntity))
            }
            let section = Section(items: items)
            (self.viewController as? TableDisplayLogic)?.display(viewModel: TableModel.UpdatePosts.ViewModel(sections: [section]))
        }), on: .main)
    }
    
    open func prepare(object: TEntity) -> ViewModel {
        preconditionFailure("Should be overwritten.")
    }
    
}
