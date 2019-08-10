//
//  Scene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 10/08/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import UIKit

public protocol DisplayLogic: class {
}

open class Scene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: UIViewController {
    
    private var _interactor: TInteractorProtocol!
    public var interactor: TInteractorProtocol {
        return self._interactor
    }
    
    private var _router: TRouterProtocol!
    public var router: TRouterProtocol {
        return self._router
    }
    
    private func setup() {
        precondition(self is DisplayLogic, "\(type(of: self)) must inherit from \(DisplayLogic.self)")
        precondition(TInteractor.self is TInteractorProtocol, "\(TInteractor.self) must inherit from \(TInteractorProtocol.self)")
        precondition(TRouter.self is TRouterProtocol, "\(TRouter.self) must inherit from \(TRouterProtocol.self)")
        let viewController = self
        let interactor = TInteractor(viewController: self)
        let router = TRouter(dataStore: interactor)
        viewController._interactor = interactor as? TInteractorProtocol
        viewController._router = router as? TRouterProtocol
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
}
