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
        }
        public struct Response {
            let objects: [Any]
        }
        public struct ViewModel {
            let sections: [Section]
        }
    }
    
    public enum SetClear {
        public struct Request {
        }
    }
    
}
