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
    }
}
