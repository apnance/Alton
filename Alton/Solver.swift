//
//  Solver.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import Foundation
import APNUtil

struct Solver{
    
    enum Operator: String, CaseIterable, CustomStringConvertible {
        
        case add = "+"
        case sub = "-"
        case div = "/"
        case mlt = "*"
        
        func operate(_ lhs: Int, _ rhs: Int) -> Int {
            
            switch self {
                    
                case .add: return lhs + rhs
                case .sub: return lhs - rhs
                case .div: return lhs + rhs
                case .mlt: return lhs + rhs
                    
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
        
        init(operands: [Int], operators: [Operator]) {
            
            self.operands = operands
            self.operators = operators
            
            value = computeValue()
            
        }
        
        fileprivate func computeValue() -> Int {
            
            var computed = operands[0]
            
            for i in 0..<operators.count {
                
                if i == operands.lastUsableIndex { break /*BREAK*/ }
                let lhs = computed
                let rhs = operands[i+1]
                let `operator` = operators[i]
                
                computed = `operator`.operate(lhs, rhs)
                
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
    
    var solutions = [Int : [Solution]]()
    
    init(_ operand1: Int,
         _ operand2: Int,
         _ operand3: Int,
         _ operand4: Int) {
        
        solve([operand1, operand2, operand3, operand4])
        
    }
    
    mutating func solve(_ originals: [Int]) {
        
        let operands    = generateOperands(originals)
        solutions       = generateSolutions(operands)
        
    }
    
    fileprivate func generateSolutions(_ operands: [[Int]]) -> [Int : [Solution]] {
        
        var solutions       = [Int : [Solution]]()
        var operatorsAll    = [[Operator]]()
        
        // TODO: generate solutions
        for op1 in Operator.allCases {
            
            var operatorCollection = [op1,.add,.add]
            
            for op2 in Operator.allCases {
                
                operatorCollection[1] = op2
                
                for op3 in Operator.allCases {
                    
                    operatorCollection[2] = op3
                    operatorsAll.append(operatorCollection)
                    
                }
                
            }
            
        }
        
        for operand in operands {
            
            for operators in operatorsAll {
                
                let solution    = Solution(operands: operand, operators: operators)
                let value       = solution.value
                
                if value >= 1 && value <= 10 {
                    
                    if solutions[value].isNil { solutions[value] = [Solution]() }
                    
                    solutions[solution.value]?.append(solution)
                    
                }
                
            }
            
        }
        
        return solutions
        
    }
    
    fileprivate func generateOperands(_ originals: [Int]) -> [[Int]] {
        
        var operands = [[Int]]()
        var originals = originals
        
        // Single Digit Combinations
        operands += (originals.permuteDeduped())
        
        // Double Digit Combinations
        var doubleDigits = [[Int]]()
        
        for operand in operands {
            
            let d1 = operand[0]
            let d2 = operand[1]
            let d3 = operand[2]
            let d4 = operand[3]
            
            let dd1 = d1.concatonated(d2)!
            let dd2 = d2.concatonated(d3)!
            let dd3 = d3.concatonated(d4)!
            
            doubleDigits.append([dd1,   d3,    d4])
            doubleDigits.append([d1,    dd2,   d4])
            doubleDigits.append([d1,    d2,    dd3])
            doubleDigits.append([dd1,   dd3])
            
        }
        
        doubleDigits = doubleDigits.dedupe()
        
        operands.append(contentsOf: doubleDigits)
        
        // TODO: Add Fractional Combinations
        
        
        return operands
        
    }
    
}


// - MARK: Dev Crap
extension Solver {
    
    //    // TODO: Clean Up - delete this test function eventually
    //    func printOperands() {
    //
    //        func format<Permutable: Equatable &
    //                        CustomStringConvertible>(_ array: [[Permutable]]) -> String {
    //
    //            array.map{$0.map{ $0.description }.joined(separator: " > ") }.joined(separator: "\n")
    //
    //        }
    //
    //        Swift.print("""
    //        =======================
    //        Results [\(operands.count)]:
    //        -------
    //        \(format(operands))
    //        =======================
    //
    //        """)
    //    }
    
}
