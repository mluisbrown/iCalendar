//
//  Event.swift
//  iCalendar
//
//  Created by Michael Brown on 20/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

struct Event {
    let uid: String
    let startDate: Date
    let endDate: Date
    let description: String?
    let summary: String?
    let location: String?

    init?(with dict: [String:EventValueType]) {
        guard let uid = dict[Keys.uid]?.textValue,
            let startDate = dict[Keys.startDate]?.dateValue,
            let endDate = dict[Keys.endDate]?.dateValue else {
                return nil
        }
        
        self.uid = uid
        self.startDate = startDate
        self.endDate = endDate
        description = dict[Keys.description]?.textValue
        summary = dict[Keys.summary]?.textValue
        location = dict[Keys.location]?.textValue
        
    }
    
    func asDictionary() -> [String:EventValueType] {
        var dict: [String: EventValueType] = [:]
        dict[Keys.uid] = EventValue(value: uid)
        dict[Keys.startDate] = EventValue(value: startDate)
        dict[Keys.endDate] = EventValue(value: endDate)
        dict[Keys.description] = description.map { EventValue(value: $0) }
        dict[Keys.summary] = summary.map { EventValue(value: $0) }
        dict[Keys.location] = location.map { EventValue(value: $0) }
        
        return dict
    }
}

extension Event {
    enum Keys: String {
        case uid = "UID"
        case startDate = "DTSTART"
        case endDate = "DTEND"
        case description = "DESCRIPTION"
        case summary = "SUMMARY"
        case location = "LOCATION"
    }
}
