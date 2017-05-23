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
        let NormalizedEOL: Character = "\n"
        let unfolded = unfold(ics: ics)
        let normalized = Regex.LineTerminator.replace(in: unfolded, with: String(NormalizedEOL))
        
        return normalized.characters.split(separator: NormalizedEOL).map(String.init)
    }
    
    static func keyParamsAndValue(from line: String) -> (key: String, params: [String]?, value: String)? {
        let valueSplit = line.characters.split(separator: ":", maxSplits: 1)
        guard valueSplit.count == 2,
            let vsFirst = valueSplit.first,
            let vsLast = valueSplit.last else { return nil }
        
        let value = String(vsLast)
        let paramsSplit = vsFirst.split(separator: ";")

        guard paramsSplit.count > 0,
            let psFirst = paramsSplit.first else { return nil }
        
        let params = paramsSplit.count > 1 ? paramsSplit.suffix(from: 1).map(String.init) : nil
        let key = String(psFirst)
        
        return (key, params, value)
    }
}
