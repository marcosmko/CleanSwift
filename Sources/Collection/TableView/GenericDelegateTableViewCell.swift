//
//  GenericDelegateTableViewCell.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

@objc
public protocol GenericTableViewCellDelegate: class {
    
}

protocol GenericDelegateTableViewCellProtocol {
    func prepare(indexPath: IndexPath, delegate: NSObject?)
}

open class GenericDelegateTableViewCell<T: ViewModel, D: GenericTableViewCellDelegate>: GenericTableViewCell<T>, GenericDelegateTableViewCellProtocol {
    
    public private(set) var indexPath: IndexPath = IndexPath(item: -1, section: -1)
    public private(set) weak var delegate: D?
    
    func prepare(indexPath: IndexPath, delegate: NSObject?) {
        self.indexPath = indexPath
        self.delegate = delegate as? D
    }
    
}
