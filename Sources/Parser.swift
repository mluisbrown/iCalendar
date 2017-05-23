//
//  Parser.swift
//  iCalendar
//
//  Created by Michael Brown on 20/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

struct RegEx {
    static let fold = "(\r?\n)+[ \t]"
    static let lineEnding = "\r?\n"
    static let escComma = "\\,"
    static let escSemiColon = "\\;"
    static let escBackslash = "\\\\;"
    static let escNewline = "\\[nN];"
}

enum EventValue {
    case text(String)
    case date(Date)
}

struct Context {
    var inCalendar = false
    var inEvent = false
    var values: [String : String]
    var events: [Event]
    
    init() {
        values = [String : String]()
        events = [Event]()
    }
}

struct Parser {
    
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
    
    static func parse(ics: String) -> Calendar? {
        let parsedCtx = lines(ics: ics).reduce(Context()) {
            ctx, line in
            guard let kpv = keyParamsAndValue(from: line) else { return ctx }
            
            var newCtx = ctx;
            
            switch kpv.key {
            case "BEGIN":
                newCtx.inCalendar = newCtx.inCalendar || kpv.value == "VCALENDAR"
                newCtx.inEvent = newCtx.inEvent || kpv.value == "VEVENT"
            case "END":
                if newCtx.inEvent {
                    newCtx.inEvent = false;
                    newCtx.events.append(Event(with: newCtx.values))
                }
            default:
                break
            }
            
            return newCtx
        }
        
        return Calendar(events: parsedCtx.events)
    }
}
