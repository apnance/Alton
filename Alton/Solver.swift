//
//  Solver.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import Foundation
import APNUtil

struct Solver{
    
    /// All viable expressions found for each possible answer(1-10)
    var solutions = [Int : [Expression]]()
    
    /// `Array` of possible answers for which no solutions were found.
    var missingSolution = [Int]()
    
    /// Boolean value indicating if solutions have been found for all possible answer(1-10).
    var fullySolved : Bool { missingSolution.count == 0 }
    
    init(_ operand1: Int,
         _ operand2: Int,
         _ operand3: Int,
         _ operand4: Int) {
        
        solve([operand1, operand2, operand3, operand4])
        
        
    }
    
    mutating func solve(_ originals: [Int]) {
        
        let operands    = generateOperands(originals)
        solutions       = generateSolutions(operands)
        
        for key in solutions.keys {
            
            if solutions[key]?.count == 0 {
                
                missingSolution.append(key)
                
            }
            
        }
        
    }
    
    func sampleSolutionFor(_ num: Int) -> String {
        
        solutions[num]?.first?.description ?? "NA"
        
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
        
        // TODO: compute parenthetical variants for multiplation and division containing solutions
        // e.g. 4 - ((4 + 4) / 4) = 2  <- this is currently not possible with the simplistic left to right operand processing algo
        
        // TODO: Add Fractional Combinations
        
        
        return operands
        
    }
    
    fileprivate func generateSolutions(_ operands: [[Int]]) -> [Int : [Expression]] {
        
        var operatorsAll    = [[Operator]]()
        var solutions       = [Int : [Expression]]()
        
        // initialize expressions
        (1...10).forEach{ solutions[$0] = [Expression]() }
        
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
                
                let expression  = Expression(operands: operand, operators: operators)
                
                if  expression.isValid {
                    
                    solutions[expression.value]?.appendUnique(expression)
                    
                }
            }
            
        }
        
        return solutions
        
    }
    
    func generateDisplay() -> String {
        
        var display = ""
        
        for key in solutions.keys.sorted() {
            
            display += "\(sampleSolutionFor(key)) [Found: \(solutions[key]!.count)]\n"
            
        }
        
        return display
    }
    
}

// - MARK: Utils
extension Solver {
    
    func echoResults(_ operands: [Int]) {
        
        print("""
            ========================================
            \t\(operands)
            ----------------------------------------
            
            \(generateDisplay())
            
            ========================================
            """)
        
    }
    
}
