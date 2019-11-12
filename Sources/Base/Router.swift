//
//  Router.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 10/08/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

@objc
public protocol RouterProtocol: class {
}

public protocol DataPassing: NSObjectProtocol {
    init(dataStore: Any)
}

open class Router<TDataStore>: NSObject {
    
    public var dataStore: TDataStore
    
    public required init(dataStore: Any) {
        precondition(dataStore.self is TDataStore, "\(dataStore.self) must inherit from \(TDataStore.self)")
        self.dataStore = dataStore as! TDataStore
        super.init()
        precondition(self is RouterProtocol, "\(type(of: self)) must inherit from \(RouterProtocol.self)")
        precondition(self is DataPassing, "\(type(of: self)) must inherit from \(DataPassing.self)")
    }
    
}
