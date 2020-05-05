//
//  TableModel.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 16/04/20.
//  Copyright © 2020 Undercaffeine. All rights reserved.
//

import Foundation

public enum TableModel {
    
    public enum GetPosts {
        public struct Request {
            let reload: Bool
        }
        public struct Response {
            let objects: [Any]
            let reload: Bool
        }
        public struct ViewModel {
            let sections: [Section]
            let reload: Bool
        }
    }
    
    public enum UpdatePosts {
        public struct Response {
            public init(objects: [Any]) { self.objects = objects }
            let objects: [Any]
        }
        public struct ViewModel {
            let sections: [Section]
        }
    }
    
    public enum SetClear {
        public struct Request {
            public init() {}
        }
    }
    
}
