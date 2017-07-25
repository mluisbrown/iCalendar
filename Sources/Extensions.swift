//
//  Extensions.swift
//  iCalendar
//
//  Created by Michael Brown on 20/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

extension String {
    var nsRange: NSRange {
        return NSMakeRange(0, self.utf16.count)
    }
    
    func replace(regex: RegEx, with: String) -> String {
        return regex.compiled.stringByReplacingMatches(in: self, options: [], range: self.nsRange, withTemplate: with)
    }
    
    func numberOfMatches(of regex: RegEx) -> Int {
        return regex.compiled.numberOfMatches(in: self, options: [], range: self.nsRange)
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral {
    subscript<Index: RawRepresentable>(index: Index) -> Value? where Index.RawValue == String {
        get {
            return self[index.rawValue as! Key]
        }
        
        set {
            self[index.rawValue as! Key] = newValue
        }
    }
}



