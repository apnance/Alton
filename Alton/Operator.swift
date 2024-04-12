//
//  Operator.swift
//  Alton
//
//  Created by Aaron Nance on 3/28/24.
//

import Foundation

enum OperatorError: Error, LocalizedError {
    
    case divideByZero, remainderInDivision, nestedFractions
    
    var errorDescription: String? {
        switch self {
                
            case .divideByZero:
                return NSLocalizedString("Attempted to divide by zero.", comment: "Divide By Zero")
                
            case .remainderInDivision:
                return NSLocalizedString("Result of division has remainder and is not a valid solution.", comment: "Division With Remainder")
                
            case .nestedFractions:
                return NSLocalizedString("Result cannot have nested fractions.", comment: "Nested Fraction")
                
        }
    }
    
}

enum Operator: String, CaseIterable {
    
    enum Precendence {
        case additionSubtraction
        case multiplicationDivision
        case parenthetical
        case fraction
    }
    
    // TODO: Clean Up - change division rawValue to '÷' and fraction rawValue to '/'
    case add = "+"
    case sub = "-"
    case div = "/" // "÷"
    case mlt = "*" // "×"
    case ope = "("
    case clo = ")"
    case fra = "_" // fraction '1_2' is the fraction '1/2'
    
    var precedence: Precendence {
        
        switch self {
                
            case .add, .sub: return .additionSubtraction
            case .mlt, .div: return .multiplicationDivision
            case .ope, .clo: return .parenthetical
            case .fra: return .fraction
                
        }
    }
    
    static let nonParen = [Operator.add, .sub, .div, .mlt, .fra]
    
    func operate<LHS: Operand, RHS: Operand>(_ lhs: LHS,
                                             _ rhs: RHS) throws -> any Operand {
        
        switch self {
                
            case .add: return lhs + rhs
            case .sub: return lhs - rhs
            case .mlt: return lhs * rhs
            case .div: return try lhs / rhs
                
            case .fra:
                
                if let lhs = lhs as? Int,
                    let rhs = rhs as? Int {
                    
                    if rhs == 0 { throw OperatorError.divideByZero /*ERROR*/ }
                    else {
                        
                        return Fraction(numerator: lhs, denominator: rhs) /*SUCCESS*/
                    }
                    
                } else {
                    
                    throw OperatorError.nestedFractions /*ERROR*/
                    
                }
                
// TODO: Clean Up - delete
//                let (lhs, rhs) = (lhs as! Int, rhs as! Int)
//                if rhs == 0 { throw OperatorError.divideByZero /*ERROR*/ }
//                
//                return Fraction(numerator: lhs, denominator: rhs)
                
            case .ope: fatalError("Wrong turn at Albuquerque?")
            case .clo: fatalError("Wrong turn at Albuquerque?")
                
        }
        
    }
    
}

extension Operator: Component {
    
    func isCloseParen() -> Bool { self == .clo }
    func isOpenParen() -> Bool { self == .ope }
    
    var complexity: Int {
        
        switch self {
                
            case .add: return 10
            case .sub: return 11
            case .mlt: return 20
            case .div: return 30
            case .ope: return 40
            case .clo: return 0
            case .fra: return 65
            
        }
        
    }
    
}

extension Operator: CustomStringConvertible {
    
    var description: String { self == .mlt ? "×" : self.rawValue }
    
}
