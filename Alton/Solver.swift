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
private (set) var LOOOOPCOUNT = 0
    
    /// Backing property containing array of all possible 3-operator combinations
    /// excluding open and close parens.
    private static var operators = [[Operator]]()
    
    /// Stores the original game digits
    let originalOperands: [Int]
    
    /// All viable expressions found for each possible answer(1-10)
    private (set) var solutions = [Int : [Expression]]()
    
    /// `Array` of possible answers for which no solutions were found.
    private (set) var missingSolution = [Int]()
    
    /// Boolean value indicating if solutions have been found for all possible answer(1-10).
    var fullySolved : Bool { missingSolution.count == 0 }
    
    init(_ originals: [Int]) {
        
        assert(originals.count == 4,
               "Expected Digit Count: 4 - Actual: \(originals.count)")
        
        originalOperands = originals
        
        solve()
        
        
    }
    
    
    /// Solves for all possible solution `Expression` for all expected answer
    /// values 1-10
    mutating func solve() {
        
        solutions = buildExpressions(operands:  buildOperands(),
                                     operators: buildOperators())
        
        for key in solutions.keys {
            
            if solutions[key]?.count == 0 {
                
                missingSolution.append(key)
                
            }
            
        }
        
    }
    
    
    /// Returns the  description of least complex `Expression` that evaluates to `num`
    /// - Parameter num: expected `Expression` answer. (e.g. the 5 in '2 + 3 = 5')
    /// - Returns: String representation of the `Expression`
    func sampleSolutionFor(_ num: Int) -> String {
        
        solutions[num]?.sorted{$0.complexity < $1.complexity}.first?.description ?? "-NA-"
        
    }
    
    // TODO: Clean Up - remove mutating when LOOOOPCOUNT is removed from buildOperands
    mutating fileprivate func buildOperands() -> [[Int]] {
                
        var operands = [[Int]]()
        
        // Single Digit Combinations
        operands += (originalOperands.permuteDeduped())
        
        // Double Digit Combinations
        var doubleDigits = [[Int]]()
        
        for operand in operands {
            
            // Single Digits
            let d1  = operand[0]
            let d2  = operand[1]
            let d3  = operand[2]
            let d4  = operand[3]
            
            // Double Digits
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
        
        return operands
        
    }
    
    /// Returns all possible permuations of 3-at-a-time non-parentheticcal operator collections.
    /// Returns all possible permuations of 3-at-a-time non-parentheticcal operator collections.
    mutating func buildOperators() -> [[Operator]] {
        
        if Solver.operators.count == 0 {
            
            for op1 in Operator.nonParen {
                
                for op2 in Operator.nonParen {
                    
                    for op3 in Operator.nonParen {
                        
                        Solver.operators.append([op1,op2,op3])
                        LOOOOPCOUNT += 1
                        
                    }
                    
                }
                
            }
            
        }
        
        return Solver.operators /*EXIT*/
        
    }
    
    // TODO: Clean Up - remove mutating when LOOOOPCOUNT is no longer being modified in buildExpressions
    /// Generates all possible Expression combinations  for the given `operands`
    mutating fileprivate func buildExpressions(operands: [[Int]],
                                               operators: [[Operator]]) -> [Int : [Expression]] {
        
        // initialize expressions
        var expressions     = [Int : [Expression]]()
        (1...10).forEach{ expressions[$0] = [Expression]() }
        
        // Optimization mechanism to prevent duplicative initalization of the
        // same Expression which is relatively cpu intensive.
        var existingExpressionHashes = Set<String>()
        
        // Prevents duplicative initialization of identical `Expression`s
        func addExpressionFrom(_ components: [Component]) {
            
            let currentExpressionHash = components.reduce(""){ $0 + $1.description }
            
            if !existingExpressionHashes.contains(currentExpressionHash) {
                
                let exp = Expression(components)
                existingExpressionHashes.insert(currentExpressionHash)
                
                if exp.isValid {
                    
                    expressions[exp.value]?.append(exp)
                    
                }
                
            }
            
        }
        
        // parens open/close
        let (po, pc) = (Operator.ope, Operator.clo)
        
        for digits in operands { // digits
            
            let d1 = digits[0]
            let d2 = digits[1]
            let d3 = digits.count > 2 ? digits[2] : Configs.Expression.invalidValue
            let d4 = digits.count > 3 ? digits[3] : Configs.Expression.invalidValue
            
            for operators in operators { // non-paren operators
                
                let o1 = operators[0]
                let o2 = operators[1]
                let o3 = operators[2]
                
                switch digits.count {
                    
                    case 2:
                        
                        // 12x12
                        addExpressionFrom([d1, o1, d2])
                        
                    case 3:
                        
                        // 12x3x4
                        addExpressionFrom([d1, o1, d2, o2, d3])
                        
                        // (12x3)x4
                        addExpressionFrom([po, d1, o1, d2, pc, o2, d3])
                        
                        // 12x(3x4)
                        addExpressionFrom([d1, o1, po, d2, o2, d3, pc])
                        
                    case 4:
                        
                        // 1x2x3x4
                        addExpressionFrom([d1, o1, d2, o2, d3, o3, d4])
                        
                        // (1x2)x3x4
                        addExpressionFrom([po, d1, o1, d2, pc, o2, d3, o3, d4])
                            
                        // ((1x2)x3)x4
                        addExpressionFrom([po,po, d1, o1, d2, pc, o2, d3, pc, o3, d4])
                        
                        // 1x(2x3)x4
                        addExpressionFrom([d1, o1, po, d2, o2, d3, pc, o3, d4])
                        
                        // 1x2x(3x4)
                        addExpressionFrom([d1, o1, d2, o2, po, d3, o3, d4, pc])
                        
                        // 1x((2x3)x4)
                        addExpressionFrom([d1, o1, po, po, d2, o2, d3, pc, o3, d4, pc])
                        
                        // 1x(2x(3x4))
                        addExpressionFrom([d1, o1, po, d2, o2, po, d3, o3, d4, pc, pc])
                        
                    default: fatalError()
                        
                }
                
                LOOOOPCOUNT += 1
                
            }
            
        }
        
        return expressions
        
    }
    
    func formattedSolution() -> String {
        
        var rows    = [[String]]()
        let headers = ["#","Ex.", "Found"]
        
        for key in solutions.keys.sorted() {
            
            let row = [key.description,
                       sampleSolutionFor(key).description,
                       solutions[key]!.count.description]
            
            rows.append(row)
            
        }
        
        return Report.columnateAutoWidth(rows,
                                         headers: headers,
                                         dataPadType: .center, 
                                         showSeparators: false)
        
    }
    
    func formattedSolutionsFor(_ value: Int) -> String {
        
        var rows    = [[String]]()
        let headers = ["#","Soln.", "Comp."]
        
        let sorted = solutions[value]!.sorted{ $0.complexity < $1.complexity }
        
        for solution in sorted {
            
            let row = [value.description,
                       solution.description,
                       solution.complexity.description]
            
            rows.append(row)
            
        }
        
        if rows.count == 0 { return "No Solutions Found For: \(value)" }
        else {
            
            return Report.columnateAutoWidth(rows,
                                             headers: headers,
                                             dataPadType: .center,
                                             showSeparators: false)
            
        }
        
    }
    
}

// - MARK: Utils
extension Solver {
    
    func echoResults() {
        
        let report          = formattedSolution()
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
