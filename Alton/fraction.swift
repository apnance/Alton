//
//  Fraction.swift
//  Alton
//
//  Created by Aaron Nance on 4/8/24.
//

import Foundation

// TODO: Clean Up - RENAME fraction.swift -> Fraction.swift

struct Fraction {
    
    let numerator: Int
    let denominator: Int
    
    /// Initializes a `Fraction` object.
    /// - important: Validate inputs - no error handling is done to prevent divide by zero errors.
    init(numerator: Int, denominator: Int) {
        
        let sign            = denominator < 0 ? -1 : 1
        self.numerator      = numerator * sign
        self.denominator    = denominator * sign
        
    }
    
    var description: String { "\(numerator)_\(denominator)" }
    
}

// - MARK: Arithmetic
extension Fraction {
    
    // Addition
    static func +(lhs: Fraction, rhs: Fraction) -> Fraction {
        
        if lhs.denominator == rhs.denominator {
            
            Fraction(numerator: lhs.numerator + rhs.numerator,
                     denominator: lhs.denominator) // Common Denom
            
        } else {
            
            Fraction(numerator: (lhs.numerator * rhs.denominator) + (rhs.numerator * lhs.denominator),
                     denominator: lhs.denominator * rhs.denominator) // Common Denom
            
        }
        
    }
    
    static func +(lhs: Fraction, rhs: Int) -> Fraction {
        
        lhs + Fraction(numerator: rhs, 
                       denominator: 1)
        
    }
    
    // Subtraction
    static func -(lhs: Fraction, rhs: Fraction) -> Fraction {
        
        lhs + Fraction(numerator: -rhs.numerator, 
                       denominator: rhs.denominator)
        
    }
    
    static func -(lhs: Fraction, rhs: Int) -> Fraction {
        
        lhs - Fraction(numerator: rhs, denominator: 1)
        
    }
    
    // Multiplication
    static func *(lhs: Fraction, rhs: Fraction) -> Fraction {
        
        Fraction(numerator: lhs.numerator * rhs.numerator,
                 denominator: lhs.denominator * rhs.denominator)
        
    }
    
    static func *(lhs: Fraction, rhs: Int) -> Fraction {
        
        lhs * Fraction(numerator: rhs, denominator: 1)
        
    }
    
    // Division
    static func /(lhs: Fraction, rhs: Fraction) -> Fraction {
        
        Fraction(numerator: lhs.numerator * rhs.denominator,
                 denominator: lhs.denominator * rhs.numerator)
        
    }
    
    static func /(lhs: Fraction, rhs: Int) -> Fraction {
        
        lhs / Fraction(numerator: rhs, denominator: 1)
        
    }
    
}

// - MARK: Equatable
extension Fraction: Equatable {
    
    static func ==(lhs: Fraction, rhs: Fraction) -> Bool {
        
        lhs.numerator   == rhs.numerator
        && lhs.denominator == rhs.denominator
        
    }
    
}

// - MARK: Operand
extension Fraction: Operand {
    
    // Fraction's complexity is never called but
    static var maxComplexity: Int { Configs.Complexity.Operand.fraction }
// TODO: Clean Up - delete
//    static var maxComplexity: Int { Configs.Component.MaxComplexity.fraction }
//    static var maxComplexity: Int { 6 }
    var complexity: Int { Fraction.maxComplexity }
    
    var asInteger: Int {
        
        get throws {
            
            if numerator % denominator != 0 { throw OperatorError.remainderInDivision }
            else { return numerator / denominator }
            
        }
        
    }
    var asFraction: Fraction { self }
    
    static func + (lhs: Fraction, rhs: any Operand) -> any Operand {
        
        if let rhs = rhs as? Int {
            
            return lhs + rhs.asFraction /*EXIT*/
            
        } else {
            
            return lhs + (rhs as! Fraction)  /*EXIT*/
            
        }
        
    }
        
    static func - (lhs: Fraction, rhs: any Operand) -> any Operand {
        
        if let rhs = rhs as? Int {
            
            return lhs - rhs.asFraction
            
        } else {
            
            return lhs - (rhs as! Fraction)
            
        }
        
    }
        
    static func * (lhs: Fraction, rhs: any Operand) -> any Operand {
        
        if let rhs = rhs as? Int {
            
            return lhs * rhs.asFraction
            
        } else {
            
            return lhs * (rhs as! Fraction)
            
        }
        
    }
        
    static func / (lhs: Fraction, rhs: any Operand) throws -> any Operand {
        
        if let rhs = rhs as? Int {
            
            if rhs == 0 { throw OperatorError.divideByZero /*THROW*/ }
            else { return lhs / rhs.asFraction }
            
            
        } else {
            
            let rhs = rhs as! Fraction
                
            if rhs.numerator == 0 { throw OperatorError.divideByZero /*THROW*/ }
            else { return lhs / rhs }
            
        }
        
    }
    
}
