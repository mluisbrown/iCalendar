//
//  EventSpec.swift
//  iCalendar
//
//  Created by Michael Brown on 04/07/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import iCalendar

class EventSpec: QuickSpec {
    override func spec() {
        describe("encoded") {
            it("should encode the data in is given") {
                let dict: [String:EventValueRepresentable] = [Event.Keys.uid.rawValue: EventValue(value: "a UID"),
                            Event.Keys.startDate.rawValue: EventValue(value: Date()),
                            Event.Keys.endDate.rawValue: EventValue(value: Date().addingTimeInterval(864000))]
                
                let event = Event(with: dict)
                expect(event).toNot(beNil())
                expect(event?.encoded.elementsEqual(dict, by: ==)).to(beTrue())
            }
        }
    }
}
