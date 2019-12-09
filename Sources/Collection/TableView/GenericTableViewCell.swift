//
//  GenericTableViewCell.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

open class GenericTableViewCell<T: ViewModel>: UITableViewCell, GenericCellProtocol {
    
    func prepare(viewModel: ViewModel) {
        guard let viewModel = viewModel as? T else {
            return
        }
        self.prepare(viewModel: viewModel)
    }
    
    open func prepare(viewModel: T) {
    }
    
}
