//
//  TestUtils.swift
//  iCalendar
//
//  Created by Michael Brown on 07/07/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

func testBundle() -> Bundle {
    let bundleArray = Bundle.allBundles.filter() { $0.bundlePath.hasSuffix(".xctest") }
    return bundleArray.first!
}

func testResource(from filename: String) -> String? {
    let bundlePath = testBundle().path(forResource: filename, ofType: "")
    // hack to get around bundle resources not existing when running in Swift Package Manager (swift test)
    // see: https://bugs.swift.org/browse/SR-4725
    let spmPath = NSString.path(withComponents: [testBundle().bundlePath, "..", "..", "..", "Tests/iCalendarTests/Fixtures/", filename])
    
    if let bundlePath = bundlePath, let resource = try? String(contentsOf: URL(fileURLWithPath: bundlePath)) {
        return resource
    } 
    
    if let spmResource = try? String(contentsOf: URL(fileURLWithPath: spmPath)) {
        return spmResource
    }
    
    return nil;        
}

