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
        
        describe("write event") {
            it("write out a parsed airbnb event correctly") {
                guard let ics = testResource(from: "airbnb.ics") else {
                    fail("unable to load resource")
                    return
                }
                
                let result = Parser.parse(ics: ics)
                let calendar = result.value!

                let output = Writer.write(event: calendar.events.first!)
                let expected = "BEGIN:VEVENT\r\nDESCRIPTION:CHECKIN: 19-05-2016\\nCHECKOUT: 21-05-2016\\nNIGHTS: 2\\nPHONE: \r\n +1 (514) 317-0903\\nEMAIL: (no email alias available)\\nPROPERTY: Charming\r\n Apartment in Mouraria\\n\r\nDTEND;VALUE=DATE:20160521\r\nDTSTART;VALUE=DATE:20160519\r\nLOCATION:Charming Apartment in Mouraria\r\nSUMMARY:Mélanie Dumont (PMQ2KJ)\r\nUID:-c05ic0ieu033--p878ee9uueyx@airbnb.com\r\nEND:VEVENT\r\n"
                expect(output).to(equal(expected))
            }
        }        
    }
}
