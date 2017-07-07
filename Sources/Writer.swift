//
//  Writer.swift
//  iCalendar
//
//  Created by Michael Brown on 05/07/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

struct Writer {
    static let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    
    public static func write(calendar: Calendar) -> String {
        let header =
        """
        BEGIN:VCALENDAR\r
        PRODID;X-RICAL-TZSOURCE=TZINFO:-//Michael Brown//iCalendar//EN\r
        CALSCALE:GREGORIAN\r
        VERSION:2.0\r
        """
        
        return calendar.events.reduce(header) {
            $0 + write(event: $1)
        } + "END:VCALENDAR\r\n"
    }
    
    static func write(event: Event) -> String {
        return event.encoded.reduce("BEGIN:VEVENT\r\n" ) {
            $0 + ("\($1.0)\(write(value:$1.1))" |> fold) + "\r\n"
            } + "END:VEVENT\r\n"
    }
    
    static func write(value: EventValueRepresentable) -> String {
        if let date = value.dateValue {
            return ";VALUE=DATE:" + dateFormatter.string(from: date)
        }
        
        if let text = value.textValue {
            return ":" + escape(text)
        }
        
        return ""
    }
    
    static func fold(line: String) -> String {
        return line.characters.reduce("") {
            let result = $0.appending(String($1))
            let splitCount = result.components(separatedBy: "\r\n ").count - 1
            return (result.characters.count - splitCount) % 73 == 0 ? result.appending("\r\n ") : result
        }
    }
    
    static func escape(_ text: String) -> String {
        return text.replace(regex: .backslash, with: "\\\\\\\\")
            .replace(regex: .newLine, with: "\\\\n")
            .replace(regex: .semiColon, with: "\\\\;")
            .replace(regex: .comma, with: "\\\\,")
    }
}
