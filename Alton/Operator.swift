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

enum Operator: String, CaseIterable, CustomStringConvertible {
    
    case add = "+"
    case sub = "-"
    case div = "÷"
    case mlt = "×"
    
    func operate(_ lhs: Int, _ rhs: Int) throws -> Int {
        
        switch self {
                
            case .add: return lhs + rhs
            case .sub: return lhs - rhs
            case .div:
                
                if rhs == 0 { throw OperatorError.divideByZero }
                else if lhs % rhs != 0 { throw OperatorError.remainderInDivision}
                
                return lhs / rhs
                
                
            case .mlt: return lhs * rhs
                
        }
        
    }
    
    var description: String { self.rawValue }
    
}
