//
//  Solver.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import Foundation
import APNUtil

struct Solver{
    
// TODO: Clean Up - delete LOOOOPCOUNT when done developing
var LOOOOPCOUNT = 0
    
    /// Stores the original game digits
    private(set) var originalOperands: [Int]
    
    /// All viable expressions found for each possible answer(1-10)
    var solutions = [Int : [Expression]]()
    
    /// `Array` of possible answers for which no solutions were found.
    var missingSolution = [Int]()
    
    /// Boolean value indicating if solutions have been found for all possible answer(1-10).
    var fullySolved : Bool { missingSolution.count == 0 }
    
    init(_ originals: [Int]) {
        
        assert(originals.count == 4,
               "Expected Digit Count: 4 - Actual: \(originals.count)")
        
        originalOperands = originals
        
        solve()
        
        
    }
    
    mutating func solve() {
        
        let operands    = generateOperands(originalOperands)
        solutions       = generateExpressions(operands)
        
        for key in solutions.keys {
            
            if solutions[key]?.count == 0 {
                
                missingSolution.append(key)
                
            }
            
        }
        
    }
    
    func sampleSolutionFor(_ num: Int) -> String {
        
        solutions[num]?.sorted{$0.complexity < $1.complexity}.first?.description ?? "-NA-"
        
    }
    
    // TODO: Clean Up - remove mutating when LOOOOPCOUNT is removed from generateOperands
    mutating fileprivate func generateOperands(_ originals: [Int]) -> [[Int]] {
        
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
            
            LOOOOPCOUNT += 1
            
        }
        
        doubleDigits = doubleDigits.dedupe()
        
        operands.append(contentsOf: doubleDigits)
        
        // TODO: Add Fractional Combinations
        
        
        return operands
        
    }
    
    // TODO: Clean Up - remove mutating when LOOOOPCOUNT is no longer being modified in generateExpressions
    /// Generates all possible Expression combinations  for the given `operands`
    mutating fileprivate func generateExpressions(_ operands: [[Int]]) -> [Int : [Expression]] {
        
        var operatorsAll    = [[Operator]]()
        var expressions     = [Int : [Expression]]()
        
        // initialize expressions
        (1...10).forEach{ expressions[$0] = [Expression]() }
        
        for op1 in Operator.nonParen {
            
            for op2 in Operator.nonParen {
                
                for op3 in Operator.nonParen {
                    
                    // TODO: Clean Up - delete
                    printLocal("\(#function) : \([op1,op2,op3])")
                    
                    operatorsAll.append([op1,op2,op3])
                    
                    LOOOOPCOUNT += 1
                    
                }
                
            }
            
        }
    
    let (OP, CL) = (Operator.ope, Operator.clo)
    
        for D in operands { // digits
            
            let D1 = D[0]
            let D2 = D[1]
            let D3 = D.count > 2 ? D[2] : Expression.invalidValue
            let D4 = D.count > 3 ? D[3] : Expression.invalidValue
            
            for X in operatorsAll { // symbols
                
                let X1 = X[0]
                let X2 = X[1]
                let X3 = X[2]
                
                var exprs = [Expression]()
                
                switch D.count {
                    
                    case 2:
                        
                        // 12x12
                        exprs.append(Expression([D1, X1, D2]))
                        
                    case 3: 
                        
                        // 12x3x4
                        exprs.append(Expression([D1, X1, D2, X2, D3]))
                        
                        // (12x3)x4
                        exprs.append(Expression([OP, D1, X1, D2, CL, X2, D3]))
                        
                        // 12x(3x4)
                        exprs.append(Expression([D1, X1, OP, D2, X2, D3, CL]))
                        
                    case 4:
                        
                        // 1x2x3x4
                        exprs.append(Expression([D1, X1, D2, X2, D3, X3, D4]))
                        
                        // (1x2)x3x4
                        exprs.append(Expression([OP, D1, X1, D2, CL, X2, D3, X3, D4]))
                            
                        // ((1x2)x3)x4
                        exprs.append(Expression([OP,OP, D1, X1, D2, CL, X2, D3, CL, X3, D4]))
                        
                        // 1x(2x3)x4
                        exprs.append(Expression([D1, X1, OP, D2, X2, D3, CL, X3, D4]))
                        
                        // 1x2x(3x4)
                        exprs.append(Expression([D1, X1, D2, X2, OP, D3, X3, D4, CL]))
                        
                        // 1x((2x3)x4)
                        exprs.append(Expression([D1, X1, OP, OP, D2, X2, D3, CL, X3, D4, CL]))
                        
                        // 1x(2x(3x4))
                        exprs.append(Expression([D1, X1, OP, D2, X2, OP, D3, X3, D4, CL, CL]))
                        
                    default: fatalError()
                        
                }
                
                for expression in exprs {
                    
                    LOOOOPCOUNT += 1
                    
                    if expression.isValid {
                        
                        expressions[expression.value]?.append(expression)
                        
                    }
                    
                }
                
                LOOOOPCOUNT += 1
                
            }
            
        }
        
        return expressions
        
    }
    
    func generateDisplay() -> String {
        
        var rows    = [[String]]()
        let headers = ["#","Ex.", "Found"]
        
        for key in solutions.keys.sorted() {
            
            let row = [key.description,"\(sampleSolutionFor(key))", "\(solutions[key]!.count)"]
            
            rows.append(row)
            
        }
        
        return Report.columnateAutoWidth(rows,
                                         headers: headers,
                                         dataPadType: .center, showSeparators: false)
        
    }
    
}

// - MARK: Utils
extension Solver {
    
    func echoResults() {
        
        let report          = generateDisplay()
        let reportWidth     = report.split(separator: "\n")[1].count
        let sep1            = String(repeating: "=", count: reportWidth)
        let sep2            = String(repeating: "-", count: reportWidth)
        let title           = "\(originalOperands)".centerPadded(toLength: reportWidth)
        
        let loopCountText   = ("Loop Count: \(LOOOOPCOUNT)").centerPadded(toLength: reportWidth)
        let solvedText      = "Fully Solved?: \(fullySolved)".centerPadded(toLength: reportWidth)
        
        print("""
            \(sep1)
            \(title)
            \(sep1)
            \(report)\
            \(sep2)
            \(loopCountText)
            \(solvedText)
            \(sep1)
            
            """)
        
    }
    
}
