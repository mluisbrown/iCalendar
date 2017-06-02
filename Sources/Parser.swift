//
//  Parser.swift
//  iCalendar
//
//  Created by Michael Brown on 20/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation


struct Context {
    var inCalendar = false
    var inEvent = false
    var values: [String : EventValueType]
    var events: [Event]
    
    init() {
        values = [String : EventValueType]()
        events = [Event]()
    }
}

struct ParsedLine {
    let key: String
    let params: [String:String]?
    let value: String
}

struct Parser {
    struct RegEx {
        static let fold = "(\r?\n)+[ \t]"
        static let lineEnding = "\r?\n"
        static let escComma = "\\,"
        static let escSemiColon = "\\;"
        static let escBackslash = "\\\\"
        static let escNewline = "\\\\[nN]"
    }
    
    struct Keys {
        static let begin = "BEGIN"
        static let end = "END"
    }
    
    static let DateKeys = ["DTSTART", "DTEND", "DTSTAMP"]
    static let dateTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd'T'HHmmssZ"
        return formatter
    }()

    struct VTypes {
        static let calendar = "VCALENDAR"
        static let event = "VEVENT"
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
    
    static func dateString(from date: String, params: [String:String]?) -> String {
        if let params = params,
            params["VALUE"] == "DATE" {
            return date + "T120000Z"
        }
        
        if date.characters.last != "Z" {
            return date + "Z"
        }
        
        return date
    }
    
    static func parse(date: String, params: [String:String]?) -> Date? {
        return dateTimeFormatter.date(from: dateString(from: date, params: params))
    }
    
    static func parse(params: [String]?) -> [String:String]? {
        guard let params = params else {
            return Optional.none
        }
        
        return params.reduce([String:String]()) {
            resultIn, param in
            var result = resultIn
            let split = param.characters.split(separator: "=", maxSplits: 1)
            
            if let paramKey = split.first,
                let paramVal = split.last {
                result[String(paramKey)] = String(paramVal)
            }
            return result
        }
    }
    
    static func parse(line: String) -> ParsedLine? {
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
        
        return ParsedLine(key: key, params: parse(params: params), value: value)
    }
    
    static func parse(ics: String) -> Calendar? {
        let parsedCtx = lines(ics: ics).reduce(Context()) {
            ctxIn, line in
            guard let parsedLine = parse(line: line) else { return ctxIn }
            
            var ctx = ctxIn;
            
            switch parsedLine.key {
            case Keys.begin:
                ctx.inCalendar = ctx.inCalendar || parsedLine.value == VTypes.calendar
                ctx.inEvent = ctx.inEvent || parsedLine.value == VTypes.event
            case Keys.end:
                if ctx.inEvent {
                    ctx.inEvent = false;
                    ctx.events.append(Event(with: ctx.values))
                    ctx.values = [String:EventValueType]()
                }
            case let key where DateKeys.contains(key):
                guard ctx.inEvent else { break }
                if let date = parse(date: parsedLine.value, params: parsedLine.params) {
                    ctx.values[key] = EventValue(value: date)
                }
                else {
                    ctx.values[key] = EventValue(value: parsedLine.value)
                }
            case let key:
                guard ctx.inEvent else { break }
                ctx.values[key] = EventValue(value: unescape(text: parsedLine.value))
            }
            
            return ctx
        }
        
        return Calendar(events: parsedCtx.events)
    }
}
