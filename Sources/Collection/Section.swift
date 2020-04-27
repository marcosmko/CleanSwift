//
//  Section.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 20/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public class Section {
    public var viewModel: ViewModel?
    public var items: [ViewModel]
    public var reload: Bool
    
    public init(viewModel: ViewModel? = nil, items: [ViewModel], reload: Bool = false) {
        self.viewModel = viewModel
        self.items = items
        self.reload = reload
    }
}
