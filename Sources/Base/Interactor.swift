//
//  Interactor.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 10/08/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation
import UIKit.UIViewController

public protocol InteractorProtocol: AnyObject {
    init(viewController: UIViewController)
    func didLoad()
}

public protocol DataStore: AnyObject {
}

open class Interactor<TPresenter: PresenterProtocol, TPresenterProtocol> {
    
    open var screen: String { "" }
    
    public let presenter: TPresenterProtocol
    
    public required init(viewController: UIViewController) {
        precondition(TPresenter.self is TPresenterProtocol, "\(TPresenter.self) must inherit from \(TPresenterProtocol.self)")
        self.presenter = TPresenter(viewController: viewController) as! TPresenterProtocol
        precondition(self is InteractorProtocol, "\(type(of: self)) must inherit from \(InteractorProtocol.self)")
        precondition(self is DataStore, "\(type(of: self)) must inherit from \(DataStore.self)")
    }
    
    open func didLoad() {
    }
    
}
