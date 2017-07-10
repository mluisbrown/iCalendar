//
//  RegEx.swift
//  iCalendar
//
//  Created by Michael Brown on 07/07/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

enum RegEx: String {
    case fold = "(\r?\n)+[ \t]"
    case lineEnding = "\r?\n"
    case escComma = "\\\\,"
    case escSemiColon = "\\\\;"
    case escBackslash = "\\\\{2}"
    case escNewline = "\\\\[nN]"
    
    case newLine = "\n"
    case comma = ","
    case semiColon = ";"
    case backslash = "\\\\"

    static var cache: [RegEx: NSRegularExpression] = [:]
    
    var compiled: NSRegularExpression {
        let nsregex: NSRegularExpression
        
        if let nsr = RegEx.cache[self] {
            nsregex = nsr
        }
        else {
            nsregex = try! NSRegularExpression(pattern: self.rawValue, options: .caseInsensitive)
            RegEx.cache[self] = nsregex            
        }
                
        return nsregex 
    }
}
