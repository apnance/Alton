//
//  Operand.swift
//  Alton
//
//  Created by Aaron Nance on 4/9/24.
//

import Foundation

protocol Operand: Component { 
    
    var asInteger: Int { get throws }
    var asFraction: Fraction { get }
    
    static func + (lhs: Self, rhs: any Operand) -> any Operand
    static func - (lhs: Self, rhs: any Operand) -> any Operand
    static func * (lhs: Self, rhs: any Operand) -> any Operand
    static func / (lhs: Self, rhs: any Operand) throws -> any Operand
    
}

extension Int: Operand {
    
    var complexity: Int { self > 9 ? 5 : 0 }
    var asInteger: Int { self }
    var asFraction: Fraction { Fraction(numerator: self,
                                        denominator: 1) }
    
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
    var asInteger: Int {
        
        get throws {
            
            if self.numerator % self.denominator != 0 { throw OperatorError.remainderInDivision }
            else { return self.numerator / self.denominator }
            
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

