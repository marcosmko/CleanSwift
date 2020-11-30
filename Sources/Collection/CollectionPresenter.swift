//
//  TablePresenter.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 16/04/20.
//  Copyright © 2020 Undercaffeine. All rights reserved.
//

import Foundation

public protocol CollectionPresenterProtocol: PresenterProtocol {
    func present(response: CollectionModel.Get.Response)
    func present(response: CollectionModel.Update.Response)
    func present(response: CollectionModel.Delete.Response)
    func present(response: CollectionModel.EndRefreshing.Response)
}

open class CollectionPresenter<TDisplayLogic, TEntity>: Presenter<TDisplayLogic> {
    
    public func present(response: CollectionModel.Get.Response) {
        QueueManager.shared.execute(BlockOperation(block: {
            var items: [ViewModel] = []
            
            for item in response.objects {
                items.append(self.prepare(object: item as! TEntity))
            }
            
            let section = Section(viewModel: self.viewModel(), items: items, reload: response.reload)
            (self.viewController as? CollectionDisplayLogic)?.display(
                viewModel: CollectionModel.Get.ViewModel(
                    sections: [section],
                    reload: response.reload,
                    scrollToLast: response.scrollToLast
                )
            )
        }), on: .main)
    }
    
    public func present(response: CollectionModel.Update.Response) {
        QueueManager.shared.execute(BlockOperation(block: {
            var items: [ViewModel] = []
            
            for item in response.objects {
                items.append(self.prepare(object: item as! TEntity))
            }
            
            let section = Section(viewModel: self.viewModel(), items: items)
            (self.viewController as? CollectionDisplayLogic)?.display(
                viewModel: CollectionModel.Update.ViewModel(
                    sections: [section]
                )
            )
        }), on: .main)
    }
    
    public func present(response: CollectionModel.Delete.Response) {
        QueueManager.shared.execute(BlockOperation(block: {
            var items: [ViewModel] = []
            
            for item in response.objects {
                items.append(self.prepare(object: item as! TEntity))
            }
            
            let section = Section(viewModel: self.viewModel(), items: items)
            (self.viewController as? CollectionDisplayLogic)?.display(
                viewModel: CollectionModel.Delete.ViewModel(
                    sections: [section]
                )
            )
        }), on: .main)
    }
    
    public func present(response: CollectionModel.EndRefreshing.Response) {
        QueueManager.shared.execute(BlockOperation(block: {
            for (_, value) in Mirror(reflecting: self).children where value is CollectionDisplayLogic {
                guard let collectionDisplay = value as? CollectionDisplayLogic else { return }
                collectionDisplay.display(viewModel: CollectionModel.EndRefreshing.ViewModel())
            }
        }), on: .main)
    }
    
    open func viewModel() -> ViewModel? {
        return nil
    }
    
    open func prepare(object: TEntity) -> ViewModel {
        preconditionFailure("Should be overwritten.")
    }
    
}
