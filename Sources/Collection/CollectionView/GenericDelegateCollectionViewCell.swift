//
//  GenericDelegateCollectionViewCell.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 20/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

open class GenericDelegateCollectionViewCell<T: ViewModel, D: GenericCellDelegate>: GenericCollectionViewCell<T>, GenericCellDelegateProtocol {
    
    public private(set) var indexPath: IndexPath = IndexPath(item: -1, section: -1)
    public private(set) weak var delegate: D?
    
    func prepare(indexPath: IndexPath, delegate: AnyObject?) {
        self.indexPath = indexPath
        self.delegate = delegate as? D
    }
    
}
