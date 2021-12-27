//
//  ViewModel.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 24/10/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public protocol ViewModel {
    var tag: Int { get }
}

public extension ViewModel {
    var tag: Int { return -1 }
}

public struct EmptyViewModel: ViewModel {
    public let tag: Int
    public init(tag: Int) {
        self.tag = tag
    }
}
