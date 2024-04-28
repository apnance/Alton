//
//  Solver.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import Foundation
import APNUtil

struct Solver{
    
    /// Toggles printing of difficulty info
    var shouldPrintDiffInfo     = false
    
    /// Toggles printing of difficulty info header
    var shouldPrintDiffHeader   = false
    
    /// Performance tracking counter.
    private (set) var loopCount = 0
    
    /// Backing property containing array of all possible 3-operator combinations
    /// excluding open and close parens.
    private static var operators = [[Operator]]()
    
    /// Stores the original game digits
    let originalOperands: [Int]
    
    /// All viable `Expression`s found for each possible answer(1-10)
    private (set) var solutions = [Int : [Expression]]()
    
    static var maxSolutionDifficulty = 100
    
    // TODO: Clean Up - convert solutionDifficulty to func
    var solutionDifficulty: Int {
        
        let maxSolutionComplexity   =  Double(Expression.maxComplexity * 10)
        let maxSolutionScarcity     = 100.0 * 10.0
        
        var solutionComplexity      = 0
        var solutionScarcity        = 0.0
        var totalSolutionCount      = 0
        
        for answer in 1...10 {
            
            // Solution Complexity Component
            let leastComplexExpression  = leastComplexExpressionFor(answer)
            solutionComplexity          += leastComplexExpression?.complexity ?? 0
            
            // Solution Scarcity Component (the fewer possible solutions the harder to solve)
            let solutionCount = solutions[answer]?.count ?? 0
            
            totalSolutionCount += solutionCount
            
            if solutionCount > 0 {
                
                solutionScarcity += max(100.0 - Double(solutionCount), 0.0)
                
            } else {
                
                solutionScarcity += maxSolutionScarcity * 5.0
                
            }
            
        }
        
        let complexityComponent: Double = Double(solutionComplexity) / Double(maxSolutionComplexity)
        let scarcityComponent: Double   = solutionScarcity / maxSolutionScarcity
        
        // Weight the different components
        let percentMax      =   scarcityComponent * (2.0/5.0)
                                + complexityComponent * (3.0/5.0)
        
        var difficulty      = Double(Solver.maxSolutionDifficulty) * percentMax
        
        if difficulty < 100 {
            
            difficulty      -= 7.0
            difficulty      = (difficulty / 4.6)
            
            difficulty      = max(1, difficulty)
            difficulty      = min(10, difficulty)
            
            
        } else {
            
            // TODO: Clean Up - delete
//            difficulty = 999
            difficulty = Configs.Expression.unsolvableDifficulty
            
        }
        
        if shouldPrintDiffInfo {
            
            if shouldPrintDiffHeader {
                
                print("Digits\tDifficulty\tTotal Solutions\tScarcity\tComplexity\tPercent Max")
                
            }
            
            print("""
                \(originalOperands)\
                \t\(Int(difficulty))\
                \t\(totalSolutionCount)\
                \t\(scarcityComponent.roundTo(3))\
                \t\(complexityComponent.roundTo(3))\
                \t\(percentMax.roundTo(3))
                """)
            
        }
        
        let returnValue = Int(difficulty)
        
        assert(returnValue < 1000 && returnValue > 0)
        
        return Int(returnValue)
        
    }
    
    /// All answers for which no solutions were found.
    private (set) var unsolved = [Int]()
    
    /// Boolean value indicating if solutions have been found for all possible answer(1-10).
    var fullySolved : Bool { unsolved.isEmpty }
    
    init(_ originals:           [Int],
         shouldPrintDiffInfo:   Bool = false,
         shouldPrintDiffHeader: Bool = false) {
        
        assert(originals.count == 4,
               "Expected Digit Count: 4 - Actual: \(originals.count)")
        
        self.shouldPrintDiffInfo = shouldPrintDiffInfo
        self.shouldPrintDiffHeader = shouldPrintDiffHeader
        
        originalOperands = originals
        
        solve()
        
        // Trigger difficulty calculation?
        if shouldPrintDiffInfo { _ = solutionDifficulty }
        
    }
    
    /// Solves for all possible solution `Expression` for all expected answers 1-10.
    /// This is the heart of the `Solver`.
    mutating func solve() {
        
        solutions = buildExpressions(operands:  buildOperands(),
                                     operators: buildOperators())
        
        for key in solutions.keys {
            
            if solutions[key]?.count == 0 {
                
                unsolved.append(key)
                
            }
            
        }
        
    }
    
    /// Returns the  description of least complex `Expression` that evaluates to `num`
    /// - Parameter answer: expected `Expression` answer. (e.g. the 5 in '2 + 3 = 5')
    /// - Returns: String representation of the `Expression` or "-NA-" if no solution exists for that answer.
    func leastComplexSolutionFor(_ answer: Int) -> String {
        
        leastComplexExpressionFor(answer)?.description ?? "-NA-"
        
    }
    
    /// Returns the  least complex `Expression` that evaluates to `num`
    /// - Parameter answer: expected `Expression` answer. (e.g. the 5 in '2 + 3 = 5')
    /// - Returns: `Expression` with the lowest `complexity` that evaluates to `answer`
    func leastComplexExpressionFor(_ answer: Int) -> Expression? {
        
        solutions[answer]?.sorted{$0.complexity < $1.complexity}.first
        
    }
    
    /// Builds an array of all possible operand combinations.
    mutating fileprivate func buildOperands() -> [[Int]] {
                
        var operands = [[Int]]()
        
        // Single Digit Combinations
        operands += originalOperands.permuteDeduped()
        
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
            
            loopCount += 1
            
        }
        
        doubleDigits = doubleDigits.dedupe()
        
        operands.append(contentsOf: doubleDigits)
        
        return operands
        
    }
    
    /// Returns all possible permuations of 3-at-a-time non-parentheticcal operator collections.
    mutating func buildOperators() -> [[Operator]] {
        
        if Solver.operators.count == 0 {
            
            for op1 in Operator.nonParen {
                
                for op2 in Operator.nonParen {
                    
                    for op3 in Operator.nonParen {
                        
                        Solver.operators.append([op1,op2,op3])
                        loopCount += 1
                        
                    }
                    
                }
                
            }
            
        }
        
        return Solver.operators /*EXIT*/
        
    }
    
    // TODO: Clean Up - Factor buildExpression into sub funcs
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
                    
                    expressions[exp.answer]?.append(exp)
                    
                }
                
            }
            
        }
        
        // Parens
        let (pO, pC) = (Operator.ope, Operator.clo)
        
        for digits in operands { // Digits
            
            let d1 = digits[0]
            let d2 = digits[1]
            let d3 = digits.count > 2 ? digits[2] : Configs.Expression.invalidAnswer
            let d4 = digits.count > 3 ? digits[3] : Configs.Expression.invalidAnswer
            
            for operators in operators { // Non-Paren Operators
                
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
                        
                        if o1 < o2 {
                            
                            // (12x3)x4
                            addExpressionFrom([pO, d1, o1, d2, pC, o2, d3])
                            
                        }
                        
                        if o2 < o1 {
                            
                            // 12x(3x4)
                            addExpressionFrom([d1, o1, pO, d2, o2, d3, pC])
                            
                        }
                        
                    case 4:
                        
                        // 1x2x3x4
                        addExpressionFrom([d1, o1, d2, o2, d3, o3, d4])
                        
                        if o1 < o2 {
                            
                            // (1x2)x3x4
                            addExpressionFrom([pO, d1, o1, d2, pC, o2, d3, o3, d4])
                            
                            if o2 < o3 {
                                
                                // ((1x2)x3)x4
                                addExpressionFrom([pO, pO, d1, o1, d2, pC, o2, d3, pC, o3, d4])
                                
                            }
                            
                        } else if o2 < o3 {
                            
                            // (1x2x3)x4
                            addExpressionFrom([pO, d1, o1, d2, o2, d3, pC, o3, d4])
                            
                        }
                        
                        if o2 < o3 {
                            
                            // 1x(2x3)x4
                            addExpressionFrom([d1, o1, pO, d2, o2, d3, pC, o3, d4])
                            
                        }
                        
                        if o3 < o2 {
                            
                            // 1x2x(3x4)
                            addExpressionFrom([d1, o1, d2, o2, pO, d3, o3, d4, pC])
                            
                        }
                        
                        if o3 < o1 {
                        
                            if o2 < o3 {
                                
                                // 1x((2x3)x4)
                                addExpressionFrom([d1, o1, pO, pO, d2, o2, d3, pC, o3, d4, pC])
                                
                            } else {
                                
                                // 1x(2x3x4)
                                addExpressionFrom([d1, o1, pO, d2, o2, d3, o3, d4, pC])
                                
                            }
                            
                        }
                        
                        
                        if o2 < o1 {
                            
                            if o2 < o3 {
                                
                                // 1x(2x(3x4))
                                addExpressionFrom([d1, o1, pO, d2, o2, pO, d3, o3, d4, pC, pC])
                                
                            } else {
                                
                                // 1x(2x3x4)
                                addExpressionFrom([d1, o1, pO, d2, o2, d3, o3, d4, pC])
                                
                            }
                            
                        }
                        
                    default: fatalError()
                        
                }
                
                loopCount += 1
                
            }
            
        }
        
        return expressions
        
    }
    
    /// - Returns: `String` representation of the full solution to the puzzle.
    func formattedSolution() -> String {
        
        var rows    = [[String]]()
        let headers = ["#","Ex.", "Found"]
        
        for key in solutions.keys.sorted() {
            
            let row = [key.description,
                       leastComplexSolutionFor(key).description,
                       solutions[key]!.count.description]
            
            rows.append(row)
            
        }
        
        let tabular     = Report.columnateAutoWidth(rows,
                                                    headers: headers,
                                                    dataPadType: .center,
                                                    showSeparators: false)
        
        let padCount    = tabular.split(separator: "\n").first?.count ?? 40
        
        let separator   = String(repeating: "-", count: padCount)
        let difficulty  = "Difficulty: \(solutionDifficulty)/10".centerPadded(toLength: padCount)
        
        return """
                \(tabular)
                \(separator)
                \(difficulty)
                """
        
    }
    
    /// - Returns: `String` representations solutions for the given `answer`
    func formattedSolutionsFor(_ answer: Int) -> String {
        
        var rows    = [[String]]()
        let headers = ["#","Soln.", "Comp."]
        
        let sorted = solutions[answer]!.sorted{ $0.complexity < $1.complexity }
        
        for solution in sorted {
            
            let row = [answer.description,
                       solution.description,
                       solution.complexity.description]
            
            rows.append(row)
            
        }
        
        if rows.count == 0 { return "No Solutions Found For: \(answer)" }
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
    
    /// Prints a summary of the solver's results.
    func echoResults() {
        
        let report          = formattedSolution()
        let reportWidth     = report.split(separator: "\n")[1].count
        let sep1            = String(repeating: "=", count: reportWidth)
        let sep2            = String(repeating: "-", count: reportWidth)
        let title           = "\(originalOperands)".centerPadded(toLength: reportWidth)
        
        let loopCountText   = ("Loop Count: \(loopCount)").centerPadded(toLength: reportWidth)
        let solvedText      = "Fully Solved?: \(fullySolved)".centerPadded(toLength: reportWidth)
        
        print("""
            \(sep1)
            \(title)
            \(sep1)
            \(report)
            \(sep2)
            \(loopCountText)
            \(solvedText)
            \(sep1)
            
            """)
        
    }
    
}
