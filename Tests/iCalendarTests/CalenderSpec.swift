//
//  CalenderSpec.swift
//  iCalendar
//
//  Created by Michael Brown on 23/07/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation
import Result
import Nimble
import Quick

@testable import iCalendar

class CalendarSpec: QuickSpec {
    override func spec() {
        describe("merge airbnb and wimdu calendar") {
            it("should merge an airbnb and wimdu calendar sorted by start date") {
                guard
                    let airbnb = testResource(from: "airbnb.ics"),
                    let wimdu = testResource(from: "wimdu.ics")
                    else {
                        fail("unable to load resources")
                        return
                }
                
                let airbnbCal = Parser.parse(ics: airbnb).value!
                let wimduCal = Parser.parse(ics: wimdu).value!
                
                let merged = airbnbCal + wimduCal
                
                expect(merged.events.count).to(equal(6))
            }
        }        
    }
}

