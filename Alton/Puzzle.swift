//
//  Puzzle.swift
//  Alton
//
//  Created by Aaron Nance on 4/30/24.
//

import APNUtil

/// Represents an All Ten puzzle and is a collection of 4 digits(`Operand`s)
///  that may or may not have `Solution`s to all expected `Answer`s(1-10)
///  . A `Puzzle` with `Solution`s to `Answer`s 1-10 is considered fully solved
///  All Ten `Puzzle`
struct Puzzle {
    
    /// Stores the original game digits.
    let digits: [Int]
    
    /// All viable `Expression`s found for each possible answer(1-10)
    var solutions = [Answer : [Expression]]()
    
    /// All answers for which no solutions were found.
    var unsolved = [Answer]()
    
    /// Boolean value indicating if solutions have been found for all possible answer(1-10).
    var isFullySolved : Bool { unsolved.isEmpty }
    
    private(set) var difficulty: Difficulty?
    
    init(_ originals:           [Int],
         shouldPrintDiffInfo:   Bool = false,
         shouldPrintDiffHeader: Bool = false) {
        
        assert(originals.count == 4,
               "Expected Digit Count: 4 - Actual: \(originals.count)")
        
        digits = originals
        
    }
    
    /// Call before attempting to access data from Puzzle.
    mutating func finalize() {
        
        difficulty = Difficulty(puzzle: self)
        
    }
    
}

extension Puzzle: CustomStringConvertible {
    
    var description: String { "[\(digits[0]),\(digits[1]),\(digits[2]),\(digits[3])]" }
    
    var descriptionVerbose: String { "\(description)\t\(difficulty!)" }
    
    var descriptionForTesting: String {
        "test(\(description), \(difficulty!.descriptionForTesting))\n"
    }
    
}

// - MARK: Utils
extension Puzzle {
    
    /// - Returns: `String` representation of the full solution to the puzzle.
    func formattedSolutionSummary() -> String {
        
        var rows    = [[String]]()
        let headers = ["#","Ex.", "Found"]
        
        for key in solutions.keys.sorted() {
            
            let row = [key.description,
                       difficulty!.leastComplexSolutionFor(key).description,
                       solutions[key]!.count.description]
            
            rows.append(row)
            
        }
        
        let tabular     = Report.columnateAutoWidth(rows,
                                                    headers: headers,
                                                    dataPadType: .center,
                                                    showSeparators: false)
        
        let padCount    = tabular.split(separator: "\n").first?.count ?? 40
        let separator   = String(repeating: "-", count: padCount)
        let diff        = difficulty!.estimated
        
        var diffText    = diff <= 10 ? "Difficulty: \(diff)/10" : "Unsolvable: \(unsolved)"
        diffText      = diffText.centerPadded(toLength: padCount)
        
        return """
                \(tabular)
                \(separator)
                \(diffText)
                """
        
    }
    
    /// - Returns: `String` representations solutions for the given `answer`
    func formattedSolutionsFor(_ answer: Answer) -> String {
        
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
    
    /// Prints a summary of the solver's results.
    func echoResults() {
        
        let report          = formattedSolutionSummary()
        let reportWidth     = report.split(separator: "\n")[1].count
        let sep1            = String(repeating: "=", count: reportWidth)
        let sep2            = String(repeating: "-", count: reportWidth)
        let title           = "\(digits)".centerPadded(toLength: reportWidth)
        
        let solvedText      = "Fully Solved?: \(isFullySolved)".centerPadded(toLength: reportWidth)
        
        print("""
            \(sep1)
            \(title)
            \(sep1)
            \(report)
            \(sep2)
            \(solvedText)
            \(sep1)
            
            """)
        
    }
    
}
