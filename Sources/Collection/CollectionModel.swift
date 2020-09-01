//
//  CollectionModel.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 20/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public enum CollectionModel {
    
    public enum Get {
        public struct Request {
            public init(reload: Bool) { self.reload = reload }
            public let reload: Bool
        }
        public struct Response {
            public init(objects: [Any], reload: Bool) { self.objects = objects ; self.reload = reload }
            public let objects: [Any]
            public let reload: Bool
        }
        public struct ViewModel {
            public init(sections: [Section], reload: Bool) { self.sections = sections ; self.reload = reload }
            public let sections: [Section]
            public let reload: Bool
        }
    }
    
    public enum Update {
        public struct Response {
            public init(objects: [Any]) { self.objects = objects }
            public let objects: [Any]
        }
        public struct ViewModel {
            public init(sections: [Section]) { self.sections = sections }
            public let sections: [Section]
        }
    }
    
    public enum Delete {
        public struct Response {
            public init(indexPath: IndexPath) { self.indexPath = indexPath }
            public let indexPath: IndexPath
        }
        public struct ViewModel {
            public init(indexPath: IndexPath) { self.indexPath = indexPath }
            public let indexPath: IndexPath
        }
    }
    
    public enum SetClear {
        public struct Request {
            public init() {}
        }
    }
    
    public enum EndRefreshing {
        public struct Response {
            public init() {
            }
        }
        public struct ViewModel {
            public init() {
            }
        }
    }
    
}
