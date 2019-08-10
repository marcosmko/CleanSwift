//
//  Router.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 10/08/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public protocol RouterProtocol: class {
}

public protocol DataPassing: class {
    init(dataStore: Any)
}

open class Router<TDataStore> {
    
    public let dataStore: TDataStore
    
    public required init(dataStore: Any) {
        precondition(dataStore.self is TDataStore, "\(dataStore.self) must inherit from \(TDataStore.self)")
        self.dataStore = dataStore as! TDataStore
        precondition(self is RouterProtocol, "\(type(of: self)) must inherit from \(RouterProtocol.self)")
        precondition(self is DataPassing, "\(type(of: self)) must inherit from \(DataPassing.self)")
    }
    
}
