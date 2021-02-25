//
//  GenericViewHeaderFooterView.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 09/02/21.
//  Copyright © 2021 Undercaffeine. All rights reserved.
//

import Foundation

open class GenericViewHeaderFooterView<T: ViewModel>: UITableViewHeaderFooterView, GenericCellProtocol {
    
    func prepare(viewModel: ViewModel) {
        guard let viewModel = viewModel as? T else {
            return
        }
        self.prepare(viewModel: viewModel)
    }
    
    open func prepare(viewModel: T) {
    }
    
}
