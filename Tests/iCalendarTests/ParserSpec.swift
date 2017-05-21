//
//  ParserSpec.swift
//  iCalendar
//
//  Created by Michael Brown on 20/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import iCalendar


class ParserSpec: QuickSpec {
    override func spec() {
        describe("Unfold") {
            it("should remove folding from input") {
                let unfolded = Parser.unfold(ics: "Line Part One\r\n  Part Two")
                expect(unfolded).to(equal("Line Part One Part Two"))
            }

            it("should remove folding from input with only LF line termination") {
                let unfolded = Parser.unfold(ics: "Line Part One\n  Part Two")
                expect(unfolded).to(equal("Line Part One Part Two"))
            }

            it("should remove folding from input with tab starting folded line") {
                let unfolded = Parser.unfold(ics: "Line Part One\r\n\t Part Two")
                expect(unfolded).to(equal("Line Part One Part Two"))
            }

            it("should not remove folding from when folded line doesn't start with whitespace") {
                let unfolded = Parser.unfold(ics: "Line Part One\r\nPart Two")
                expect(unfolded).to(equal("Line Part One\r\nPart Two"))
            }
        }
        
        describe("lines") {
            it("should split the input into unfolded lines") {
                let lines = Parser.lines(ics: "Line1 Part One\r\n  Part Two\r\nLine2 Hello")
                expect(lines.count).to(equal(2))
                expect(lines[0]).to(equal("Line1 Part One Part Two"))
                expect(lines[1]).to(equal("Line2 Hello"))
            }
        }
    }
}
