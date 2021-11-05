//
//  GenericCellDelegateProtocol.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 20/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

@objc
protocol GenericCellDelegateProtocol {
    @objc optional func prepare(indexPath: IndexPath, delegate: AnyObject?)
    @objc optional func prepare(section: Int, delegate: AnyObject?)
}
