import XCTest
@testable import iCalendarTests

XCTMain([
    testCase(ParserSpec.allTests),
    testCase(WriterSpec.allTests),
    testCase(EventSpec.allTests),
    testCase(CalendarSpec.allTests)
])
