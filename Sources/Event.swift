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
    let description: String
    let summary: String
    let location: String

    init(with dict: [String:EventValueType]) {
        
        uid = dict["UID"]?.textValue ?? ""
        startDate = dict["DTSTART"]?.dateValue ?? Date()
        endDate = dict["DTEND"]?.dateValue ?? Date()
        description = dict["DESCRIPTION"]?.textValue ?? ""
        summary = dict["SUMMARY"]?.textValue ?? ""
        location = dict["LOCATION"]?.textValue ?? ""
    }
}
