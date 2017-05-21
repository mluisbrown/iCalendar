//
//  Extensions.swift
//  iCalendar
//
//  Created by Michael Brown on 20/05/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

extension String {
    func NSRange() -> NSRange {
        return NSMakeRange(0, self.characters.count)
    }
}
