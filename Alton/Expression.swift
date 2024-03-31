//
//  Expression.swift
//  Alton
//
//  Created by Aaron Nance on 3/28/24.
//

import Foundation

struct Expression: CustomStringConvertible, Equatable {
    
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
                
                if Configs.Test.printTestMessage {
                    
                     print("Error occured: \(error.localizedDescription) in Expression: '\(self)'")
                    
                }
                
                isValid = false
                
            }
            
            
        }
        
        if !computed.isBetween(1, 10) { isValid = false }
        
        return computed
        
    }
    
    var description: String {
        
        let val = value == 10 ? " \(value) = " : "  \(value) = "
        
        switch operands.count {
                
            case 2:
                
                return
                    """
                    \(val)\(operands[0]) \(operators[0]) \(operands[1])
                    """
                
            case 3:
                
                return
                    """
                    \(val)(\(operands[0]) \(operators[0]) \(operands[1])) \(operators[1]) \(operands[2])
                    """
                
            case 4:
                
                return
                    """
                    \(val)(\(operands[0]) \(operators[0]) \(operands[1])) \(operators[1]) \(operands[2])) \(operators[2]) \(operands[3])
                    """
                
            default: fatalError()
                
        }
        
        
    }
    
}
