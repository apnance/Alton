//
//  Fraction.swift
//  Alton
//
//  Created by Aaron Nance on 4/8/24.
//

import Foundation

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

extension Fraction: Equatable {
    
    static func ==(lhs: Fraction, rhs: Fraction) -> Bool {
        
        lhs.numerator   == rhs.numerator
        && lhs.denominator == rhs.denominator
        
    }
    
}
