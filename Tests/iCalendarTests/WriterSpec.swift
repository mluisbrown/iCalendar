//
//  WriterSpec.swift
//  iCalendar
//
//  Created by Michael Brown on 07/07/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import iCalendar

class WriterSpec: QuickSpec {
    override func spec() {
        describe("escape") {
            it("should escape special characters") {
                let escaped = Writer.escape("Newline: \n Comma: , Semicolon: ; Backslash \\")
                expect(escaped).to(equal("Newline: \\n Comma: \\, Semicolon: \\; Backslash \\\\"))
            }
        }
        
        describe("fold") {
            it("should fold long lines at the specified length") {
                let folded = Writer.fold("01234567890123456789", at: 10)
                expect(folded).to(equal("0123456789\r\n 012345678\r\n 9"))
            }
        }
        
//        describe("write airbnb") {
//            it("write out a parsed airbnb calendar correctly") {
//                guard
//                    let path = testBumdle().path(forResource: "airbnb", ofType: "ics"),
//                    let ics = try? String(contentsOf: URL(fileURLWithPath: path))
//                    else {
//                        fail("unable to load resource")
//                        return
//                }
//                
//                let result = Parser.parse(ics: ics)
//                expect(result.value).toNot(beNil())
//                
//                let calendar = result.value!
//                expect(calendar.events.count).to(equal(3))
//
//                let output = Writer.write(calendar: calendar)
//                expect(output).to(equal(ics))
//            }
//        }
        
    }
}
