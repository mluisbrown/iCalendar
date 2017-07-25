//
//  EventValue.swift
//  iCalendar
//
//  Created by Michael Brown on 26/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

protocol DateOrString {}

extension String: DateOrString {}
extension Date: DateOrString {}

protocol EventValueRepresentable {
    var textValue: String? { get }
    var dateValue: Date? { get }
}

struct EventValue<T>: EventValueRepresentable where T: DateOrString {
    let value: T
    
    var textValue: String? {
        return value as? String
    }
    
    var dateValue: Date? {
        return value as? Date
    }
}

func ==(lhs: EventValueRepresentable, rhs: EventValueRepresentable) -> Bool {
    return lhs.dateValue == rhs.dateValue ||
        lhs.textValue == rhs.textValue
}

func ==(lhs: (String, EventValueRepresentable), rhs: (String, EventValueRepresentable)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

