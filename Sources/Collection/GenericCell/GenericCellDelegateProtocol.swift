//
//  GenericCellDelegateProtocol.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 20/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

protocol GenericCellDelegateProtocol {
    func prepare(indexPath: IndexPath, delegate: NSObject?)
}
