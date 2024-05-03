//
//  Difficulty.swift
//  Alton
//
//  Created by Aaron Nance on 4/30/24.
//

import Foundation

/// Estimates the relative difficulty of solving the specified `Puzzle`.
///
/// The difficulty is computed as a combination of the scarcity of `Solution`s
/// for all `Answer`s as well as an average of the complexity of the simplest
/// possible `Solution` for all `Answer`s 1-10.
struct Difficulty {
    
    /// Normalized(1-10) estimation of the relative difficulty of solving the `Puzzle` being assessed.
    /// - note: a value of 999 indicates the `Puzzle` is not solvable for all required `Answer`s 1-10.
    var estimated = 999
    
    /// The total number of `Solutions` found for the `Puzzle` at hand.
    private (set) var totalSolutionCount    = 0
    
    /// The estimated percent of the maximum difficulty of this Puzzle.
    private (set) var percentMax            = -1279.9
    
    /// One factor in calculating `Estimated` that reflect the scarcity of
    /// `Solution`s for required `Answer`s 1-10
    private (set) var scarcityComponent     = -1279.9
    
    /// One factor in calculating `Estimated` that reflect the relative complexity
    /// of the `Solution`s for required `Answer`s 1-10
    private (set) var complexityComponent   = -1279.9
    
    /// Basis for calculating `estimated`
    private var solutions                   = [Int: [Expression]]()
    
    /// Initializes a `Difficulty` object to analyze `puzzle`'s relative difficulty to solve.
    /// - Parameter puzzle: `Puzzle` to estimate difficulty of solving.
    init(puzzle: Puzzle ) {
        
        solutions  = puzzle.solutions
        estimated       = estimate()
        
    }
    
    /// Estimates the difficulty of solving the `Puzzle` represented by `solutions`
    mutating func estimate() -> Int {
        
        let maxSolutionComplexity   =  Double(Expression.maxComplexity * 10)
        let maxSolutionScarcity     = 100.0 * 10.0
        
        var solutionComplexity      = 0
        var solutionScarcity        = 0.0
        
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
        
        complexityComponent = Double(solutionComplexity) / Double(maxSolutionComplexity)
        scarcityComponent   = solutionScarcity / maxSolutionScarcity
        
        percentMax          =   scarcityComponent   * Configs.Puzzle.Difficulty.scarcityFactor +
                                complexityComponent * Configs.Puzzle.Difficulty.complexityFactor
        
        var estimated       = Double(Configs.Puzzle.Difficulty.maxTheoretical) * percentMax
        
        if estimated <= 100 {
            
            estimated       += Configs.Puzzle.Difficulty.offset
            
            estimated       = (estimated / Configs.Puzzle.Difficulty.bucketSize)
            
            estimated       = max(estimated, Configs.Puzzle.Difficulty.minEstimated)
            estimated       = min(estimated, Configs.Puzzle.Difficulty.maxEstimated)
            
        } else {
            
            estimated       = Configs.Expression.Difficulty.unsolvable
            
        }
        
        assert(estimated < 1000 && estimated > 0)
        
        return Int(estimated)
        
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
    
}

extension Difficulty: CustomStringConvertible {
    
    var description: String {
                        """
                        \(estimated)\
                        \t\(totalSolutionCount)\
                        \t\(scarcityComponent.roundTo(3))\
                        \t\(complexityComponent.roundTo(3))\
                        \t\(percentMax.roundTo(3))
                        """
        
    }
    
    var descriptionForTesting: String {
                                """
                                \(estimated)\
                                , \(totalSolutionCount)\
                                , \(scarcityComponent.roundTo(3))\
                                , \(complexityComponent.roundTo(3))\
                                , \(percentMax.roundTo(3))
                                """
    }
    
    static var header: String {
        
        "Digits\tDifficulty\tTotal_Solutions\tScarcity\tComplexity\tPercent_Max"
        
    }
    
}
