//
//  Operator.swift
//  Alton
//
//  Created by Aaron Nance on 3/28/24.
//

import Foundation

enum OperatorError: Error, LocalizedError {
    
    case divideByZero, remainderInDivision
    
    var errorDescription: String? {
        switch self {
                
            case .divideByZero:
                return NSLocalizedString("Attempted to divide by zero.", comment: "Divide By Zero")
                
            case .remainderInDivision:
                return NSLocalizedString("Result of division has remainder and is not a valid solution", comment: "Division With Remainder")
                
        }
    }
    
}

enum Operator: String, CaseIterable {
    
    enum Precendence { case addSub, mltDiv, opeClo }
    
    case add = "+"
    case sub = "-"
    case div = "/" // "÷"
    case mlt = "*" // "×"
    case ope = "("
    case clo = ")"
    
    var precedence: Precendence {
        
        switch self {
                
            case .add, .sub: return .addSub
            case .mlt, .div: return .mltDiv
            case .ope, .clo: return .opeClo
                
        }
    }
    
    static let nonParen = [Operator.add, .sub, .div, .mlt]
    
    func operate(_ lhs: Int, _ rhs: Int) throws -> Int {
        
        switch self {
                
            case .add: return lhs + rhs
            case .sub: return lhs - rhs
            case .mlt: return lhs * rhs
            case .div:
                
                if rhs == 0 { throw OperatorError.divideByZero }
                else if lhs % rhs != 0 { throw OperatorError.remainderInDivision}
                
                return lhs / rhs
                
            case .ope: fatalError("Bad turn at Albuquerque?")
            case .clo: fatalError("Bad turn at Albuquerque?")
                
        }
        
    }
    
}

extension Operator: CustomStringConvertible {
    
    var description: String { self == .mlt ? "×" : self.rawValue }
    
}
