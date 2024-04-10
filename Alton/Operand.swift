//
//  Operand.swift
//  Alton
//
//  Created by Aaron Nance on 4/9/24.
//

import Foundation

protocol Operand: Component { 
    
    static func + (lhs: Self, rhs: any Operand) -> any Operand
    static func - (lhs: Self, rhs: any Operand) -> any Operand
    static func * (lhs: Self, rhs: any Operand) -> any Operand
    static func / (lhs: Self, rhs: any Operand) throws -> any Operand
    
    // TODO: Clean Up - Refactor: change integerEquivalent func to asInteger var.
    // var asInteger: Int { get throws }
    func integerEquivalent() throws -> Int
}

extension Int: Operand {
    
    var complexity: Int { self > 9 ? 2 : 0 }
    
    var asFraction: Fraction { Fraction(numerator: self, denominator: 1) }

    func integerEquivalent() -> Int { self }
    
    static func + (lhs: Int, rhs: any Operand) -> any Operand {
        
        if let rhs = rhs as? Fraction {
            
            return lhs.asFraction + rhs // Return Fraction
            
        } else {
            
            return lhs + (rhs as! Int)
            
        }
        
    }
        
    static func - (lhs: Int, rhs: any Operand) -> any Operand {
        
        if let rhs = rhs as? Fraction {
            
            return lhs.asFraction - rhs // Return Fraction
            
        } else {
            
            return lhs - (rhs as! Int)
            
        }
        
    }
        
    static func * (lhs: Int, rhs: any Operand) -> any Operand {
        
        if let rhs = rhs as? Fraction {
            
            return lhs.asFraction * rhs // Return Fraction
            
        } else {
            
            return lhs * (rhs as! Int)
            
        }
        
    }
        
    static func / (lhs: Int, rhs: any Operand) throws -> any Operand {
        
        if let rhs = rhs as? Fraction {
            
            if rhs.numerator == 0 { throw OperatorError.divideByZero /*THROW*/ }
            
            return lhs.asFraction / rhs // Return Fraction
            
        } else {
            
            let rhs = rhs as! Int
            
            if rhs == 0 { throw OperatorError.divideByZero /*THROW*/ }
            else if lhs % rhs != 0 {
            
                throw OperatorError.remainderInDivision
                
            }
            
            else { return lhs / rhs }
            
        }
        
    }
    
}

extension Fraction: Operand {
    
    var complexity: Int { 6 }
    func integerEquivalent() throws -> Int {
        
        if self.numerator % self.denominator != 0 { throw OperatorError.remainderInDivision }
        else { return self.numerator / self.denominator }
        
    }

    static func + (lhs: Fraction, rhs: any Operand) -> any Operand {
        
        if let rhs = rhs as? Int {
            
            return lhs + rhs.asFraction
            
        } else {
            
// TODO: Clean Up - delete
//            bug here.. getting caught in infinite loop
            return lhs + (rhs as! Fraction)
            
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

