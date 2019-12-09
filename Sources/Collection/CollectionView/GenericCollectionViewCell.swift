//
//  GenericCollectionViewCell.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

open class GenericCollectionViewCell<T: ViewModel>: UICollectionViewCell, GenericCellProtocol {
    
    open func prepare(viewModel: T) {
    }
    
    func prepare(viewModel: ViewModel) {
        guard let cellViewModel = viewModel as? T else {
            fatalError("The \(String(describing: viewModel)) view model is not of the expected \(type(of: T.self)) type")
        }
        self.prepare(viewModel: cellViewModel)
    }
    
}
