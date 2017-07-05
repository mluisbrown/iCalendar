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
        BEGIN:VCALENDAR
        PRODID;X-RICAL-TZSOURCE=TZINFO:-//Michael Brown//iCalendar//EN
        CALSCALE:GREGORIAN
        VERSION:2.0
        """
        
        return calendar.events.reduce(header) {
            $0.appending(write(event: $1))
        } + "END:VCALENDAR\n"
    }
    
    static func write(event: Event) -> String {
        return event.encoded.reduce("BEGIN:VEVENT\n" ) {
            $0.appending("\($1.0)\(write(value:$1.1))\n")
            } + "END:VEVENT\n"
    }
    
    static func write(value: EventValueRepresentable) -> String {
        if let date = value.dateValue {
            return ";VALUE=DATE:" + dateFormatter.string(from: date)
        }
        
        if let text = value.textValue {
            return ":" + text
        }
        
        return ""
    }
}
