//
//  ParserSpec.swift
//  iCalendar
//
//  Created by Michael Brown on 20/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation
import Result
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
        
        describe("unescape") {
            it("should unescape escaped characters") {
                let unescaped = Parser.unescape("Newline: \\n Comma: \\, Semicolon: \\; Backslash \\\\")
                expect(unescaped).to(equal("Newline: \n Comma: , Semicolon: ; Backslash \\"))
            }
        }
        
        describe("parseLineFromLine") {
            it("should split a line into key, params and a value") {
                let result = Parser.parse(line: "DTEND;VALUE=DATE:20160614")
                expect(result.value).toNot(beNil())
                
                let kpv = result.value!
                expect(kpv.key).to(equal("DTEND"))
                expect(kpv.params?["VALUE"]).to(equal("DATE"))
                expect(kpv.value).to(equal("20160614"))
            }
            
            it("should parse multiple params") {
                let result = Parser.parse(line: "DTEND;VALUE=DATE;FOO=BAR:20160614")
                expect(result.value).toNot(beNil())

                let kpv = result.value!
                expect(kpv.params?["VALUE"]).to(equal("DATE"))
                expect(kpv.params?["FOO"]).to(equal("BAR"))
                expect(kpv.key).to(equal("DTEND"))
                expect(kpv.value).to(equal("20160614"))
            }

            it("should handle no params") {
                let result = Parser.parse(line: "BEGIN:VEVENT")
                expect(result.value).toNot(beNil())

                let kpv = result.value!
                expect(kpv.key).to(equal("BEGIN"))
                expect(kpv.value).to(equal("VEVENT"))
                expect(kpv.params).to(beNil())
            }
        }
        
        describe("parse airbnb") {
            it("should parse an airbnb calendar correctly") {
                guard
                    let path = testBumdle().path(forResource: "airbnb", ofType: "ics"),
                    let ics = try? String(contentsOf: URL(fileURLWithPath: path))
                else {
                    fail("unable to load resource")
                    return
                }
                
                let result = Parser.parse(ics: ics)
                expect(result.value).toNot(beNil())
                
                let calendar = result.value!
                expect(calendar.events.count).to(equal(3))
            }
        }

        describe("parse wimdu") {
            it("should parse a wimdu calendar correctly") {
                guard
                    let path = testBumdle().path(forResource: "wimdu", ofType: "ics"),
                    let ics = try? String(contentsOf: URL(fileURLWithPath: path))
                    else {
                        fail("unable to load resource")
                        return
                }
                
                let result = Parser.parse(ics: ics)
                expect(result.value).toNot(beNil())
                
                let calendar = result.value!
                expect(calendar.events.count).to(equal(3))
            }
        }
    }
}
