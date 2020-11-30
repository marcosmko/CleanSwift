//
//  CollectionInteractor.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 16/04/20.
//  Copyright © 2020 Undercaffeine. All rights reserved.
//

import Foundation

public protocol CollectionInteractorProtocol: InteractorProtocol {
    func fetch(request: CollectionModel.Get.Request)
    func reload(request: CollectionModel.SetClear.Request)
}

internal protocol CollectionDataSource: class {
    var pageSize: Int { get set }
}

open class CollectionInteractor<TPresenter: CollectionPresenterProtocol, TPresenterProtocol, TEntity: Equatable>: Interactor<TPresenter, TPresenterProtocol>, CollectionDataSource {
    
    private var timestamp: Date = Date()
    private let lock = NSLock()
    private var offset: Int = 0
    private var hasNext: Bool = true
    private var loading: Bool = false
    internal var pageSize: Int = -1
    
    public private(set) var objects: [TEntity] = []
    
    public enum UITimelineError: Error {
        case unknown
    }
    
    internal func clearOnNextLoad() {
        self.lock.lock()
        defer { self.lock.unlock() }
        
        self.offset = 0
        self.hasNext = true
        self.loading = false
        self.timestamp = Date()
    }
    
    public func reload(request: CollectionModel.SetClear.Request) {
        self.clearOnNextLoad()
        self.fetch(request: CollectionModel.Get.Request(reload: true))
    }
    
    public func fetch(request: CollectionModel.Get.Request) {
        QueueManager.shared.execute(BlockOperation(block: {
            self.lock.lock()
            guard !self.loading && self.hasNext else {
                self.lock.unlock() ; return
            }
            self.loading = true
            self.lock.unlock()
            
            do {
                let timestamp = Date()
                let objects: [TEntity] = try self.fetch(offset: self.offset, size: self.pageSize)
                
                self.lock.lock()
                defer { self.lock.unlock() }
                
                if timestamp < self.timestamp { return }
                if self.offset == 0 {
                    self.objects = []
                }
                
                self.hasNext = !objects.isEmpty
                self.objects.append(contentsOf: objects)
                self.offset += self.objects.count
                self.loading = false
                
                (self.presenter as? CollectionPresenterProtocol)?.present(
                    response: CollectionModel.Get.Response(
                        objects: objects,
                        reload: request.reload
                    )
                )
                
                self.didFetchMoreRows()
            } catch {
                self.lock.lock()
                defer { self.lock.unlock() }
                
                debugPrint("\(self.self): \(#function) line: \(#line). \(error.localizedDescription)")
                self.loading = false
            }
            
        }), on: .concurrent)
    }
    
    public func append(objects: [TEntity], scrollToLast: Bool) {
        QueueManager.shared.execute(BlockOperation(block: {
            self.lock.lock()
            defer { self.lock.unlock() }
            
            self.objects.append(contentsOf: objects)
            self.offset = self.objects.count
            
            (self.presenter as? CollectionPresenterProtocol)?.present(
                response: CollectionModel.Get.Response(
                    objects: objects,
                    reload: false,
                    scrollToLast: scrollToLast
                )
            )
        }), on: .concurrent)
    }
    
    public func delete(objects: [TEntity]) {
        QueueManager.shared.execute(BlockOperation(block: {
            self.lock.lock()
            defer { self.lock.unlock() }
            
            var tempObjects: [TEntity?] = self.objects
            
            for objectToRemove in objects {
                for (index, object) in tempObjects.enumerated() where object == objectToRemove {
                    tempObjects.remove(at: index)
                    break
                }
            }
            self.objects = tempObjects.compactMap({ $0 })
            self.offset = tempObjects.count
            
            (self.presenter as? CollectionPresenterProtocol)?.present(
                response: CollectionModel.Delete.Response(
                    objects: objects
                )
            )
        }), on: .concurrent)
    }
    
    open func fetch(offset: Int, size: Int) throws -> [TEntity] {
        preconditionFailure("Should be overwritten.")
    }
    
    open func didFetchMoreRows() {
    }
    
}
