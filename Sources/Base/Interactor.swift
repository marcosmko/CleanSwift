//
//  Interactor.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 10/08/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation
import UIKit.UIViewController

public protocol InteractorProtocol: class {
    init(viewController: UIViewController)
}

public protocol DataStore: class {
}

open class Interactor<TPresenter: PresenterProtocol, TPresenterProtocol> {
    
    public let presenter: TPresenterProtocol
    
    public required init(viewController: UIViewController) {
        precondition(TPresenter.self is TPresenterProtocol, "\(TPresenter.self) must inherit from \(TPresenterProtocol.self)")
        self.presenter = TPresenter(viewController: viewController) as! TPresenterProtocol
        precondition(self is InteractorProtocol, "\(type(of: self)) must inherit from \(InteractorProtocol.self)")
        precondition(self is DataStore, "\(type(of: self)) must inherit from \(DataStore.self)")
    }
    
}
