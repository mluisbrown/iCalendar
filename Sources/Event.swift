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
        guard let uid = dict["UID"]?.textValue,
            let startDate = dict["DTSTART"]?.dateValue,
            let endDate = dict["DTEND"]?.dateValue else {
                return nil
        }
        
        self.uid = uid
        self.startDate = startDate
        self.endDate = endDate
        description = dict["DESCRIPTION"]?.textValue
        summary = dict["SUMMARY"]?.textValue
        location = dict["LOCATION"]?.textValue
    }
}
