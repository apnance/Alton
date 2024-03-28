//
//  Solver.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import Foundation
import APNUtil

struct Solver{
    
    var solutions = [Int : [Solution]]()
    
    init(_ operand1: Int,
         _ operand2: Int,
         _ operand3: Int,
         _ operand4: Int) {
        
        solve([operand1, operand2, operand3, operand4])
        
        // TODO: Clean Up - delete
        echoResults([operand1, operand2, operand3, operand4])
        
    }
    
    mutating func solve(_ originals: [Int]) {
        
        let operands    = generateOperands(originals)
        solutions       = generateSolutions(operands)
        
    }
    
    fileprivate func generateSolutions(_ operands: [[Int]]) -> [Int : [Solution]] {
        
        var operatorsAll    = [[Operator]]()
        var solutions       = [Int : [Solution]]()
        
        // initialize solutions
        (1...10).forEach{ solutions[$0] = [Solution]() }
        
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
                
                if  solution.isValid
                    && value >= 1
                    && value <= 10 {
                    
                    solutions[solution.value]?.appendUnique(solution)
                    
                }  
            }
            
        }
        
        return solutions
        
    }
    
    fileprivate func generateOperands(_ originals: [Int]) -> [[Int]] {
        
        var operands = [[Int]]()
        
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

// TODO: Clean Up - delete
// - MARK: Dev Crap
extension Solver {
    
    func echoResults(_ operands: [Int]) {
        
        // TODO: Clean Up - delete
        print("~\(operands)~")
        for key in solutions.keys.sorted() {
            
            print("\(key) has \(solutions[key]!.count) solutions")
            
        }
            

        
        print("------")
        print("")
        
    }
    
}
