//
//  GenericDelegateViewHeaderFooterView.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 09/02/21.
//  Copyright © 2021 Undercaffeine. All rights reserved.
//

import Foundation

open class GenericDelegateViewHeaderFooterView<T: ViewModel, D: GenericCellDelegate>: GenericViewHeaderFooterView<T>, GenericCellDelegateProtocol {
    
    public private(set) var section: Int = -1
    public private(set) weak var delegate: D?
    
    func prepare(section: Int, delegate: AnyObject?) {
        self.section = section
        self.delegate = delegate as? D
    }
    
}
