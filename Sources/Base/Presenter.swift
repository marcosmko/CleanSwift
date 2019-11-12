//
//  Presenter.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 10/08/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

public protocol PresenterProtocol: class {
    init(viewController: UIViewController)
}

open class Presenter<TDisplayLogic> {
    
    private weak var _viewController: UIViewController?
    public var viewController: TDisplayLogic {
        return self._viewController as! TDisplayLogic
    }
    
    public required init(viewController: UIViewController) {
        precondition(viewController is TDisplayLogic, "\(type(of: viewController.self)) must inherit from \(TDisplayLogic.self)")
        self._viewController = viewController
        precondition(self is PresenterProtocol, "\(type(of: self)) must inherit from \(PresenterProtocol.self)")
    }
    
}
