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

protocol EventValueType {
    var textValue: String? { get }
    var dateValue: Date? { get }
}

struct EventValue<T>: EventValueType where T: DateOrString {
    let value: T
    
    var textValue: String? {
        return value as? String
    }
    
    var dateValue: Date? {
        return value as? Date
    }
}
