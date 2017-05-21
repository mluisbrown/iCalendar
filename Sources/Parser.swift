//
//  Parser.swift
//  iCalendar
//
//  Created by Michael Brown on 20/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

struct Parser {
    enum Regex: String {
        case Fold = "(\r?\n)+[ \t]"
        case LineTerminator = "\r?\n"
        
        func NSRegularExpression() -> NSRegularExpression {
            return try! Foundation.NSRegularExpression(pattern: self.rawValue, options: .caseInsensitive)
        }
        
        func replace(in input: String, with: String) -> String {
            return self.NSRegularExpression().stringByReplacingMatches(in: input, options: [], range: input.NSRange(), withTemplate: with)
        }
    }
    
    static func unfold(ics: String) -> String {
        return Regex.Fold.replace(in: ics, with: "")
    }
    
    static func lines(ics: String) -> [String] {
        let NormalizedEOL = "\n"
        let unfolded = unfold(ics: ics)
        let normalized = Regex.LineTerminator.replace(in: unfolded, with: NormalizedEOL)
        return normalized.components(separatedBy: NormalizedEOL)
    }
}
