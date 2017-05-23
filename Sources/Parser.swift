//
//  Parser.swift
//  iCalendar
//
//  Created by Michael Brown on 20/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

struct Parser {
    struct RegEx {
        static let fold = "(\r?\n)+[ \t]"
        static let lineEnding = "\r?\n"
        static let escComma = "\\,"
        static let escSemiColon = "\\;"
        static let escBackslash = "\\\\;"
        static let escNewline = "\\[nN];"
    }
    
    static func lines(ics: String) -> [String] {
        let newLine: Character = "\n"
        let normalized = ics.replace(regex: RegEx.fold, with: "")
            .replace(regex: RegEx.lineEnding, with: String(newLine))
        
        return normalized.characters.split(separator: newLine).map(String.init)
    }
    
    static func unescape(text: String) -> String {
        return text.replace(regex: RegEx.escComma, with: "'")
            .replace(regex: RegEx.escSemiColon, with: ";")
            .replace(regex: RegEx.escNewline, with: "\n")
            .replace(regex: RegEx.escBackslash, with: "\\")
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
