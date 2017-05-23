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
    let startDate: String //Date
    let endDate: String //Date
    let description: String
    let summary: String
    let location: String

    init(with dict: [String:String]) {
        
        uid = dict["UID"] ?? ""
        startDate = dict["DTSTART"] ?? ""
        endDate = dict["DTEND"] ?? ""
        description = dict["DESCRIPTION"] ?? ""
        summary = dict["SUMMARY"] ?? ""
        location = dict["LOCATION"] ?? ""
    }
}
