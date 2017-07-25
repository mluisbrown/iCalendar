//
//  TestUtils.swift
//  iCalendar
//
//  Created by Michael Brown on 07/07/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation
import XCTest

func testBundle() -> Bundle {
    let bundleArray = Bundle.allBundles.filter() { $0.bundlePath.hasSuffix(".xctest") }
    return bundleArray.first!
}

func testBundlePath() -> String {
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    return testBundle().bundlePath
#else
    // Foundation on Linux doesn't support Bundle.allBundles or other more correct
    // ways of getting to the test bundle path
    return Bundle.main.bundlePath
#endif
}

func testResource(from filename: String) -> String? {
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    let resourcePath = testBundle().path(forResource: filename, ofType: "")
    if let bundlePath = resourcePath, let resource = try? String(contentsOf: URL(fileURLWithPath: bundlePath)) {
        return resource
    }
#endif
    // hack to get around bundle resources not existing when running in Swift Package Manager (swift test)
    // see: https://bugs.swift.org/browse/SR-4725
    let resourceUrl = NSURL.fileURL(withPathComponents: [testBundlePath(), "..", "..", "..", "Tests/iCalendarTests/Fixtures/", filename])
    
    if let resourceUrl = resourceUrl, let spmResource = try? String(contentsOfFile: resourceUrl.path, encoding: .utf8) {
        return spmResource
    }

    return nil;        
}


