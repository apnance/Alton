//
//  Solution.swift
//  Alton
//
//  Created by Aaron Nance on 3/28/24.
//

import Foundation

enum OperatorError: Error, LocalizedError {
    case divideByZero
    
    var errorDescription: String? {
        switch self {
            case .divideByZero: return NSLocalizedString("Attempted to divide by zero.", comment: "Divide By Zero")
        }
    }
    
}

enum Operator: String, CaseIterable, CustomStringConvertible {
    
    case add = "+"
    case sub = "-"
    case div = "/"
    case mlt = "*"
    
    func operate(_ lhs: Int, _ rhs: Int) throws -> Int {
        
        switch self {
                
            case .add: return lhs + rhs
            case .sub: return lhs - rhs
            case .div: 
                
                if rhs == 0 { throw OperatorError.divideByZero }
                
                return lhs / rhs
                
                
            case .mlt: return lhs * rhs
                
        }
        
    }
    
    var description: String { self.rawValue }
    
}

struct Solution: CustomStringConvertible, Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
    
        return lhs.description == rhs.description
        
    }
    
    var operands:   [Int]
    var operators:  [Operator]
    var value       = -1279
    
    var isValid     = true
        
    init(operands: [Int], operators: [Operator]) {
        
        self.operands = operands
        self.operators = operators.first(x: operands.count - 1)!
        
        value = computeValue()
        
    }
    
    mutating fileprivate func computeValue() -> Int {
        
        var computed = operands[0]
        
        for i in 0..<operators.count {
            
            let lhs = computed
            let rhs = operands[i+1]
            let `operator` = operators[i]
            
            
            do {
                
                computed = try `operator`.operate(lhs, rhs)
                
            } catch {
                
                // print("Error occured: \(error.localizedDescription) in solution '\(self)'")
                isValid = false
                
            }
            
        }
        
        return computed
        
    }
    
    var description: String {
        
        switch operands.count {
            
            case 2:
                
                return
                    """
                    \(operands[0]) \(operators[0]) \(operands[1]) = \(value)
                    """
                
            case 3:
                
                return
                    """
                    (\(operands[0]) \(operators[0]) \(operands[1])) \(operators[1]) \(operands[2])  = \(value)
                    """
                
            case 4:
                
                return
                    """
                    (\(operands[0]) \(operators[0]) \(operands[1])) \(operators[1]) \(operands[2])) \(operators[2]) \(operands[3]) = \(value)
                    """
                
            default: fatalError()
                
        }
        
        
    }
    
}
