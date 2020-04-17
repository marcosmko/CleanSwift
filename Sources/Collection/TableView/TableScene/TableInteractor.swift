//
//  TableInteractor.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 16/04/20.
//  Copyright © 2020 Undercaffeine. All rights reserved.
//

import Foundation

public protocol TableInteractorProtocol: InteractorProtocol {
    func fetch(request: TableModel.GetPosts.Request)
    func reload(request: TableModel.SetClear.Request)
}

protocol TableDataSource: class {
    var pageSize: Int { get set }
}

open class TableInteractor<TPresenter: TablePresenterProtocol, TPresenterProtocol, TEntity>: Interactor<TPresenter, TPresenterProtocol>, TableDataSource {
    
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
    
    func clearOnNextLoad() {
        self.lock.lock()
        defer { self.lock.unlock() }
        
        self.offset = 0
        self.hasNext = true
        self.loading = false
        self.timestamp = Date()
    }
    
    func update(tag: Int) {
//        DispatchQueue.async {
//            guard let object = self.find(tag) else { return }
//            self.post(action: "update", tag: tag, any: self.prepare(object: object))
//        }
    }
    
    public func reload(request: TableModel.SetClear.Request) {
        self.clearOnNextLoad()
        self.fetch(request: TableModel.GetPosts.Request())
    }
    
    public func fetch(request: TableModel.GetPosts.Request) {
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
                
                self.hasNext = !(objects.count < self.pageSize) || !objects.isEmpty
                self.objects.append(contentsOf: objects)
                self.offset += self.pageSize
                self.loading = false
                
                (self.presenter as? TablePresenterProtocol)?.present(response: TableModel.GetPosts.Response(objects: objects))
            } catch {
                self.lock.lock()
                defer { self.lock.unlock() }
                
                debugPrint("\(self.self): \(#function) line: \(#line). \(error.localizedDescription)")
                self.loading = false
            }
            
        }), on: .concurrent)
    }
    
    open func fetch(offset: Int, size: Int) throws -> [TEntity] {
        preconditionFailure("Should be overwritten.")
    }
    
}
