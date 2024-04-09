//
//  ExpressionTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 4/3/24.
//

import XCTest
@testable import Alton

final class ExpressionTests: XCTestCase { 
    
    func test(_ expression: String, _ expected: Int) {
        
        let exp     = Expression(expression)
        let actual  = exp.value
        XCTAssert(expected == actual,
                  "'\(exp)' Expected: \(expected) - Actual: \(actual)")
        
        print("\(exp) == \(expected)")
        
    }
    
    /// These Expressions have been returning expected values.
    func testWorkingExpressions() {
        
        // Passing
        test("(((1 + 2)))", 3)
        test("1 + 2", 3)
        test("(1 + 2) + (3 / 3)", 4)
        test("(4+2) / (1+2)", 2)
        test("1 + (3 + 3) / 3", 3)
        test("1 + 1 + 1 + 24", 27)
        test("1 + (2 + 3) / 5", 2)
        test("1 + ((3 + 3) / 3)", 3)
        
        test("(4 + 4) / (3 + 1)", 2)
        test("((3 + 3) / 3) + 1", 3)
        test("(3 + 3 * 3)", 12)
        
    }

    /// These Expressions have been returning erroneous values.
    /// - Note: this is likely caused by precedence bug
    func testBrokenExpressions() {
        
        
        // Broken
        test("(3 + 3 * 3 + 2)", 14) // Expected 14 - Actual 18
        test("(3 + 3) * 3 + 1", 19) // Expected 19 - Actual 24
        test("(3 + 3) / 3 + 1", 3)  // Expected 3 - Actual -1279
                                    // breaks because it operates in left to
                                    // right order except that parentheticals
                                    // are evaluated as they are encountered.
                                    // So here we calculate (3 + 3), then 3 + 1, then (3 + 3) / (3 + 1)
        
    }
    
    func testMultDivPrecedence() {
        
        
        test("2 * 2 * 3 * 4", 48)
        test("((2 * 5) / 2) * 3", 15)
        
        test("(2 * 4) + 3 / 3 + 1", 10)
        test("2 * 4 + 3 / 3", 9)
        test("50 / 2 / 5 / 5", 1)
        
    }
    
    func testExtraneousButCorrectParens() {
        
        test("((3) + (((3) * (3))) + 2)", 14)
        
    }
    
    func testMisc() {
        
        test("2 * 4 + 3 / 3", 9)
        test("(2+1) / 3", 1)
        
    }
    
}
