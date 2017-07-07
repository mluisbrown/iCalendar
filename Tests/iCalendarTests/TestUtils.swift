//
//  TestUtils.swift
//  iCalendar
//
//  Created by Michael Brown on 07/07/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

func testBumdle() -> Bundle {
    let bundleArray = Bundle.allBundles.filter() { $0.bundlePath.hasSuffix(".xctest") }
    return bundleArray.first!
}

