//
//  TabBarScene.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 01/06/21.
//  Copyright © 2021 Undercaffeine. All rights reserved.
//

import UIKit

open class TabBarScene<TInteractor: InteractorProtocol, TInteractorProtocol, TRouter: DataPassing, TRouterProtocol>: UITabBarController {
    
    open public(set) override var title: String? {
        get { super.title }
        set {
            self.navigationItem.title = newValue
            super.title = newValue
        }
    }
    
    private lazy var _interactor: TInteractorProtocol! = TInteractor(viewController: self) as? TInteractorProtocol
    public var interactor: TInteractorProtocol {
        return self._interactor
    }
    
    private lazy var _router: TRouter! = TRouter(dataStore: self.interactor, viewController: self)
    public var router: TRouter {
        return self._router
    }
    
    private func setup() {
        precondition(self is DisplayLogic, "\(type(of: self)) must inherit from \(DisplayLogic.self)")
        precondition(TInteractor.self is TInteractorProtocol, "\(TInteractor.self) must inherit from \(TInteractorProtocol.self)")
        precondition(TRouter.self is TRouterProtocol, "\(TRouter.self) must inherit from \(TRouterProtocol.self)")
    }
    
    public convenience init() {
        self.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        (self.interactor as! TInteractor).didLoad()
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        let selector = NSSelectorFromString("routeTo\(identifier)WithSegue:sender:")
        if router.responds(to: selector) {
            router.perform(selector, with: segue, with: sender)
        }
    }
    
}
