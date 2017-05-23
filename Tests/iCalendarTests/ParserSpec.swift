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
        describe("lines") {
            it("should split the input into unfolded lines") {
                let lines = Parser.lines(ics: "Line1 Part One\r\n  Part Two\r\nLine2 Hello")
                expect(lines.count).to(equal(2))
                expect(lines[0]).to(equal("Line1 Part One Part Two"))
                expect(lines[1]).to(equal("Line2 Hello"))
            }

            it("should unfold when only an LF terminates the line") {
                let lines = Parser.lines(ics: "Line1 Part One\n  Part Two\r\nLine2 Hello")
                expect(lines.count).to(equal(2))
                expect(lines[0]).to(equal("Line1 Part One Part Two"))
                expect(lines[1]).to(equal("Line2 Hello"))
            }

            it("should unfold when folded line starts with a tab") {
                let lines = Parser.lines(ics: "Line1 Part One\r\n\t Part Two\r\nLine2 Hello")
                expect(lines.count).to(equal(2))
                expect(lines[0]).to(equal("Line1 Part One Part Two"))
                expect(lines[1]).to(equal("Line2 Hello"))
            }

            it("should not unfold lines that don't start with whitespace") {
                let lines = Parser.lines(ics: "Line1\r\nLine2\r\nLine3 Hello")
                expect(lines.count).to(equal(3))
                expect(lines[0]).to(equal("Line1"))
                expect(lines[1]).to(equal("Line2"))
                expect(lines[2]).to(equal("Line3 Hello"))
            }
        }
        
        describe("keyParamsAndValueFromLine") {
            it("should split a line into key, params and a value") {
                let kpv = Parser.keyParamsAndValue(from: "DTEND;VALUE=DATE:20160614")
                expect(kpv).toNot(beNil())
                expect(kpv?.key).to(equal("DTEND"))
                expect(kpv?.params?[0]).to(equal("VALUE=DATE"))
                expect(kpv?.value).to(equal("20160614"))
            }
            
            it("should parse multiple params") {
                let kpv = Parser.keyParamsAndValue(from: "DTEND;VALUE=DATE;FOO=BAR:20160614")
                expect(kpv?.params?[0]).to(equal("VALUE=DATE"))
                expect(kpv?.params?[1]).to(equal("FOO=BAR"))
                expect(kpv?.key).to(equal("DTEND"))
                expect(kpv?.value).to(equal("20160614"))
            }

            it("should handle no params") {
                let kpv = Parser.keyParamsAndValue(from: "BEGIN:VEVENT")
                expect(kpv?.key).to(equal("BEGIN"))
                expect(kpv?.value).to(equal("VEVENT"))
                expect(kpv?.params).to(beNil())
            }
        }
    }
}
