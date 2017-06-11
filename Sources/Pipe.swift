//
//  Pipe.swift
//  iCalendar
//
//  Created by Michael Brown on 11/06/2017.
//  Copyright © 2017 iCalendar. All rights reserved.
//

import Foundation

precedencegroup PipePrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |> : PipePrecedence

public func |> <T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}
