//
//  Solver.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import Foundation
import APNUtil

/// A `Solution` finding `Puzzle` manager.
///
/// Nomenclature:
/// * `Solver`:  a `Solution` finding `Puzzle` manager.
///
/// * `Puzzle`:  Represents an All Ten puzzle and is a collection of 4 digits(`Operand`s)
///  that may or may not have `Solution`s to all expected `Answer`s(1-10)
///  . A `Puzzle` with `Solution`s to `Answer`s 1-10 is considered fully solved
///  All Ten `Puzzle`
///
/// * `Expression`:  A chain of `Components` that when evaluated may or may not
/// yield a valid integer `Answer`
///
/// * `Component`:  the building block of an `Expression`. Can be either an `Operand`
/// or an `Operator`
///
/// * `Answer`: a valid  result(Integer) of evaluating an `Expression`.
///
/// * `Solution`: an `Expression` with an `Answer`
struct Solver {
    
    static var cached = [[Int] : Puzzle]()
    
    private (set) var puzzle: Puzzle
    
    /// Backing property containing array of all possible 3-operator combinations
    /// excluding open and close parens.
    private static var operators = [[Operator]]()
    
    /// Performance tracking counter.
    var loopCount = 0
    
    /// Initializes a `Solver`
    /// - Parameters:
    ///   - originals: Array of the puzzle digits to solve.
    ///   - bruteForce: Flag to toggle use of very slow, brute force Expression generation.
    ///
    /// - Important: Do not use bruteForce except for testing.
    /// - Note: bruteForce is meant only for testing that the solutions generated
    /// w/o bruteForce are as thorough/exhaustive as possible.
    init(_ originals: [Int],
         useBruteForce bruteForce: Bool = false) {
        
        let originals = originals.sorted()
        
        if !bruteForce,
           let puzzle = Self.cached[originals] {
            
            self.puzzle = puzzle
            
            return /*EXIT*/
            
        } else {
            
            puzzle = Puzzle(originals)
            solve(useBruteForce: bruteForce)
            
            Self.cached[originals] = puzzle
            
        }
        
    }
    
    /// Solves for all possible solution `Expression` for all expected answers 1-10.
    /// This is the heart of the `Solver`.
    mutating private func solve(useBruteForce: Bool) {
        
        if useBruteForce {
            
            puzzle.solutions = buildExpressionsBruteForce(operands:  buildOperands(),
                                                          operators: buildOperators())
            
        }
        else {
            
            puzzle.solutions = buildExpressions(operands:  buildOperands(),
                                                operators: buildOperators())
        }
        for answer in puzzle.solutions.keys {
            
            loopCount += 1
            
            if puzzle.solutions[answer]?.count == 0 {
                
                puzzle.unsolved.append(answer)
                
            }
            
        }
        
        puzzle.finalize()
        
    }
    
    /// Builds an array of all possible operand combinations.
    mutating fileprivate func buildOperands() -> [[Int]] {
                
        var operands = [[Int]]()
        
        // Single Digit Combinations
        operands += puzzle.digits.permuteDeduped()
        
        // Double Digit Combinations
        var doubleDigits = [[Int]]()
        
        for operand in operands {
            
            // Single Digits
            let d1  = operand[0]
            let d2  = operand[1]
            let d3  = operand[2]
            let d4  = operand[3]
            
            // Double Digits
            let dd1 = d1.concatenated(d2)!
            let dd2 = d2.concatenated(d3)!
            let dd3 = d3.concatenated(d4)!
            
            doubleDigits.append([dd1,   d3,    d4])
            doubleDigits.append([d1,    dd2,   d4])
            doubleDigits.append([d1,    d2,    dd3])
            doubleDigits.append([dd1,   dd3])
            
            loopCount += 1
            
        }
        
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
    
    /// Generates all possible Expression combinations  for the given `operands`
    mutating fileprivate func buildExpressions(operands: [[Int]],
                                               operators: [[Operator]]) -> [Int : [Expression]] {
        
        var deduper = ExpressionDeduper()
        
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
                        deduper.addExpressionFrom([d1, o1, d2])
                        
                    case 3:
                        
                        // 12x3x4
                        deduper.addExpressionFrom([d1, o1, d2, o2, d3])
                        
                        if o1 < o2 {
                            
                            // (12x3)x4
                            deduper.addExpressionFrom([pO, d1, o1, d2, pC, o2, d3])
                            
                        }
                        
                        if o2 < o1 {
                            
                            // 12x(3x4)
                            deduper.addExpressionFrom([d1, o1, pO, d2, o2, d3, pC])
                            
                        }
                        
                    case 4:
                        
                        // 1x2x3x4
                        deduper.addExpressionFrom([d1, o1, d2, o2, d3, o3, d4])
                        
                        if o1 < o2 {
                            
                            // (1x2)x3x4
                            deduper.addExpressionFrom([pO, d1, o1, d2, pC, o2, d3, o3, d4])
                            
                            if o2 < o3 {
                                
                                // ((1x2)x3)x4
                                deduper.addExpressionFrom([pO, pO, d1, o1, d2, pC, o2, d3, pC, o3, d4])
                                
                            }
                            
                        } else if o2 < o3 {
                            
                            // (1x2x3)x4
                            deduper.addExpressionFrom([pO, d1, o1, d2, o2, d3, pC, o3, d4])
                            
                        }
                        
                        if o1 < o2 && o3 < o2 {
                            
                            // (1x2)x(3x4)
                            deduper.addExpressionFrom([pO, d1, o1, d2, pC, o2, pO, d3, o3, d4, pC])
                            
                        }
                        
                        if o2 < o3 {
                            
                            // 1x(2x3)x4
                            deduper.addExpressionFrom([d1, o1, pO, d2, o2, d3, pC, o3, d4])
                            
                        }
                        
                        if o3 < o2 {
                            
                            // 1x2x(3x4)
                            deduper.addExpressionFrom([d1, o1, d2, o2, pO, d3, o3, d4, pC])
                            
                        }
                        
                        if o3 < o1 {
                            
                            if o2 < o3 {
                                
                                // 1x((2x3)x4)
                                deduper.addExpressionFrom([d1, o1, pO, pO, d2, o2, d3, pC, o3, d4, pC])
                                
                            } else {
                                
                                // 1x(2x3x4)
                                deduper.addExpressionFrom([d1, o1, pO, d2, o2, d3, o3, d4, pC])
                                
                            }
                            
                        }
                        
                        if o2 < o1 {
                            
                            if o3 < o2 {
                                
                                // 1x(2x(3x4))
                                deduper.addExpressionFrom([d1, o1, pO, d2, o2, pO, d3, o3, d4, pC, pC])
                                
                            } else {
                                
                                // 1x(2x3x4)
                                deduper.addExpressionFrom([d1, o1, pO, d2, o2, d3, o3, d4, pC])
                                
                            }
                            
                        }
                        
                    default: fatalError()
                        
                }
                
                loopCount += 1
                
            }
            
        }
        
        return deduper.uniques
        
    }
    
}

extension Solver {
    
    /// Generates all possible Expression combinations  for the given `operands` 
    /// ignores `Operator` precedence logic and uses all possible combinations of parens.
    ///
    /// * The purpose of this variant of `buildExpressions(::)` is to ensure that no `Solution`s
    /// are missed by the significantly more efficient but also more complex `buildExpressions(::)`
    /// * This method should be called in testing only.
    mutating fileprivate func buildExpressionsBruteForce(operands: [[Int]],
                                               operators: [[Operator]]) -> [Int : [Expression]] {
        
        var deduper = ExpressionDeduper()
        
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
                        deduper.addExpressionFrom([d1, o1, d2])
                        
                    case 3:
                        
                        // 12x3x4
                        deduper.addExpressionFrom([d1, o1, d2, o2, d3])
                        
                        // (12x3)x4
                        deduper.addExpressionFrom([pO, d1, o1, d2, pC, o2, d3])
                        
                        // 12x(3x4)
                        deduper.addExpressionFrom([d1, o1, pO, d2, o2, d3, pC])
                        
                    case 4:
                        
                        // 1x2x3x4
                        deduper.addExpressionFrom([d1, o1, d2, o2, d3, o3, d4])
                        
                        // (1x2)x3x4
                        deduper.addExpressionFrom([pO, d1, o1, d2, pC, o2, d3, o3, d4])
                        
                        // ((1x2)x3)x4
                        deduper.addExpressionFrom([pO, pO, d1, o1, d2, pC, o2, d3, pC, o3, d4])
                        
                        // (1x2x3)x4
                        deduper.addExpressionFrom([pO, d1, o1, d2, o2, d3, pC, o3, d4])
                        
                        // (1x2)x(3x4)
                        deduper.addExpressionFrom([pO, d1, o1, d2, pC, o2, pO, d3, o3, d4, pC])
                        
                        // 1x(2x3)x4
                        deduper.addExpressionFrom([d1, o1, pO, d2, o2, d3, pC, o3, d4])
                        
                        // 1x2x(3x4)
                        deduper.addExpressionFrom([d1, o1, d2, o2, pO, d3, o3, d4, pC])
                        
                        // 1x((2x3)x4)
                        deduper.addExpressionFrom([d1, o1, pO, pO, d2, o2, d3, pC, o3, d4, pC])
                        
                        // 1x(2x3x4)
                        deduper.addExpressionFrom([d1, o1, pO, d2, o2, d3, o3, d4, pC])
                        
                        // 1x(2x(3x4))
                        deduper.addExpressionFrom([d1, o1, pO, d2, o2, pO, d3, o3, d4, pC, pC])
                        // 1x(2x3x4)
                        deduper.addExpressionFrom([d1, o1, pO, d2, o2, d3, o3, d4, pC])
                        
                    default: fatalError()
                        
                }
                
                loopCount += 1
                
            }
            
        }
        
        return deduper.uniques
        
    }
    
}
