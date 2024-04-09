//
//  FractionalMathTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 4/8/24.
//

import Foundation

import XCTest
@testable import Alton

final class FractionalMathTests: XCTestCase {
    
    func testAddition() {
        
        var f1          = Fraction(numerator: 1, denominator: 2)
        var f2          = Fraction(numerator: 3, denominator: 2)
        var actual      = f1 + f2
        var expected    = Fraction(numerator: 4, denominator: 2)
        XCTAssert(actual == expected, "\(f1) + \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 1, denominator: 5)
        f2              = Fraction(numerator: 1, denominator: 2)
        actual          = f1 + f2
        expected        = Fraction(numerator: 7, denominator: 10)
        XCTAssert(actual == expected, "\(f1) + \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 2, denominator: 3)
        f2              = Fraction(numerator: 4, denominator: 5)
        actual          = f1 + f2
        expected        = Fraction(numerator: 22, denominator: 15)
        XCTAssert(actual == expected, "\(f1) + \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        // Improper Fraction
        f1              = Fraction(numerator: 10, denominator: 5)
        f2              = Fraction(numerator: 2, denominator: 5)
        actual          = f1 + f2
        expected        = Fraction(numerator: 12, denominator: 5)
        XCTAssert(actual == expected, "\(f1) + \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 3, denominator: 2)
        f2              = Fraction(numerator: 4, denominator: 3)
        actual          = f1 + f2
        expected        = Fraction(numerator: 17, denominator: 6)
        XCTAssert(actual == expected, "\(f1) + \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        // Adding Negatives
        f1              = Fraction(numerator: 2, denominator: 3)
        f2              = Fraction(numerator: -1, denominator: 3)
        actual          = f1 + f2
        expected        = Fraction(numerator: 1, denominator: 3)
        XCTAssert(actual == expected, "\(f1) + \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 5, denominator: 12)
        f2              = Fraction(numerator: -20, denominator: 21)
        actual          = f1 + f2
        expected        = Fraction(numerator: -135, denominator: 252)
        XCTAssert(actual == expected, "\(f1) + \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
    }
    
    func testIntAddition() {
        
        var f1          = Fraction(numerator: 1, denominator: 2)
        var f2          = 1
        var actual      = f1 + f2
        var expected    = Fraction(numerator: 3, denominator: 2)
        XCTAssert(actual == expected, "\(f1) + \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 1, denominator: 5)
        f2              = 2
        actual          = f1 + f2
        expected        = Fraction(numerator: 11, denominator: 5)
        XCTAssert(actual == expected, "\(f1) + \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
    }
    
    func testSubtraction() {
        
        var f1          = Fraction(numerator: 1, denominator: 2)
        var f2          = Fraction(numerator: 3, denominator: 2)
        var actual      = f1 - f2
        var expected    = Fraction(numerator: -2, denominator: 2)
        XCTAssert(actual == expected, "\(f1) - \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: -5, denominator: 12)
        f2              = Fraction(numerator: -20, denominator: 12)
        actual          = f1 - f2
        expected        = Fraction(numerator: 15, denominator: 12)
        XCTAssert(actual == expected, "\(f1) - \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: -5, denominator: 12)
        f2              = Fraction(numerator: 20, denominator: 12)
        actual          = f1 - f2
        expected        = Fraction(numerator: -25, denominator: 12)
        XCTAssert(actual == expected, "\(f1) - \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 5, denominator: 12)
        f2              = Fraction(numerator: 20, denominator: 12)
        actual          = f1 - f2
        expected        = Fraction(numerator: -15, denominator: 12)
        XCTAssert(actual == expected, "\(f1) - \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
    }
    
    func testIntSubtraction() {
        
        var f1          = Fraction(numerator: 1, denominator: 2)
        var f2          = 1
        var actual      = f1 - f2
        var expected    = Fraction(numerator: -1, denominator: 2)
        XCTAssert(actual == expected, "\(f1) - \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 1, denominator: 5)
        f2              = 2
        actual          = f1 - f2
        expected        = Fraction(numerator: -9, denominator: 5)
        XCTAssert(actual == expected, "\(f1) - \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
    }
    
    
    func testMultiplication() {
        
        var f1          = Fraction(numerator: 1, denominator: 2)
        var f2          = Fraction(numerator: 3, denominator: 2)
        var actual      = f1 * f2
        var expected    = Fraction(numerator: 3, denominator: 4)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 1, denominator: 5)
        f2              = Fraction(numerator: 1, denominator: 2)
        actual          = f1 * f2
        expected        = Fraction(numerator: 1, denominator: 10)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 2, denominator: 3)
        f2              = Fraction(numerator: 4, denominator: 5)
        actual          = f1 * f2
        expected        = Fraction(numerator: 8, denominator: 15)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        // Improper Fraction
        f1              = Fraction(numerator: 10, denominator: 5)
        f2              = Fraction(numerator: 2, denominator: 5)
        actual          = f1 * f2
        expected        = Fraction(numerator: 20, denominator: 25)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 3, denominator: 2)
        f2              = Fraction(numerator: 4, denominator: 3)
        actual          = f1 * f2
        expected        = Fraction(numerator: 12, denominator: 6)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        // Adding Negatives
        f1              = Fraction(numerator: 2, denominator: 3)
        f2              = Fraction(numerator: -1, denominator: 3)
        actual          = f1 * f2
        expected        = Fraction(numerator: -2, denominator: 9)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 5, denominator: 12)
        f2              = Fraction(numerator: -20, denominator: 21)
        actual          = f1 * f2
        expected        = Fraction(numerator: -100, denominator: 252)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
    }
    
    func testIntMultiplication() {
        
        var f1          = Fraction(numerator: 1, denominator: 2)
        var f2          = 1
        var actual      = f1 * f2
        var expected    = Fraction(numerator: 1, denominator: 2)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 239, denominator: 556)
        f2              = 1
        actual          = f1 * f2
        expected        = Fraction(numerator: 239, denominator: 556)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: -1, denominator: 15)
        f2              = 2
        actual          = f1 * f2
        expected        = Fraction(numerator: -2, denominator: 15)
        XCTAssert(actual == expected, "\(f1) * \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
    }
    
    func testDivision() {
        
        var f1          = Fraction(numerator: 1, denominator: 2)
        var f2          = Fraction(numerator: 3, denominator: 2)
        var actual      = f1 / f2
        var expected    = Fraction(numerator: 2, denominator: 6)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 1, denominator: 5)
        f2              = Fraction(numerator: 1, denominator: 2)
        actual          = f1 / f2
        expected        = Fraction(numerator: 2, denominator: 5)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 2, denominator: 3)
        f2              = Fraction(numerator: 4, denominator: 5)
        actual          = f1 / f2
        expected        = Fraction(numerator: 10, denominator: 12)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        // Improper Fraction
        f1              = Fraction(numerator: 10, denominator: 5)
        f2              = Fraction(numerator: 2, denominator: 5)
        actual          = f1 / f2
        expected        = Fraction(numerator: 50, denominator: 10)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 3, denominator: 2)
        f2              = Fraction(numerator: 4, denominator: 3)
        actual          = f1 / f2
        expected        = Fraction(numerator: 9, denominator: 8)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        // Adding Negatives
        f1              = Fraction(numerator: 2, denominator: 3)
        f2              = Fraction(numerator: -1, denominator: 3)
        actual          = f1 / f2
        
        expected        = Fraction(numerator: 6, denominator: -3)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        expected        = Fraction(numerator: -6, denominator: 3)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 5, denominator: 12)
        f2              = Fraction(numerator: -20, denominator: 21)
        actual          = f1 / f2
        
        expected        = Fraction(numerator: 105, denominator: -240)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        expected        = Fraction(numerator: -105, denominator: 240)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
    }
    
    func testIntDivision() {
        
        var f1          = Fraction(numerator: 1, denominator: 2)
        var f2          = 1
        var actual      = f1 / f2
        var expected    = Fraction(numerator: 1, denominator: 2)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: 239, denominator: 556)
        f2              = 1
        actual          = f1 / f2
        expected        = Fraction(numerator: 239, denominator: 556)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
        f1              = Fraction(numerator: -1, denominator: 15)
        f2              = 2
        actual          = f1 / f2
        expected        = Fraction(numerator: -1, denominator: 30)
        XCTAssert(actual == expected, "\(f1) / \(f2) :: Expected: \(expected) - Actual: \(actual)" )
        
    }
    
}
