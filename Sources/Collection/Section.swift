//
//  Section.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 20/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public class Section {
    public var headerViewModel: ViewModel?
    public var footerViewModel: ViewModel?
    public var items: [ViewModel]
    public var reload: Bool
    
    public init(headerViewModel: ViewModel? = nil, footerViewModel: ViewModel? = nil, items: [ViewModel], reload: Bool = false) {
        self.headerViewModel = headerViewModel
        self.footerViewModel = footerViewModel
        self.items = items
        self.reload = reload
    }
}
