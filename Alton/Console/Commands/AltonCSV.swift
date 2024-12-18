//
//  AltonSolve.swift
//  Alton
//
//  Created by Aaron Nance on 9/29/24.
//

import UIKit
import APNUtil
import ConsoleView

/// Command to retrieve a comma separated list of all`ArchivedPuzzle`data.
@available(iOS 15, *)
struct AltonCSV: Command {
    
    // - MARK: Command Requirements
    var commandToken    = Configs.Console.Commands.CSV.token
    
    var isGreedy        = false
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.CSV.helpText
    
    /// Builds and returns a comma separated values list of `ArchivedPuzzle`
    /// data in `archive`
    /// - Parameter _: does not require or process arguments.
    /// - Returns: CSV version of all `ArchivedPuzzle` data  in `archive`
    func process(_ args: [String]?) -> CommandOutput {
        
        let sortedPuzzles = Array(PuzzleArchiver.shared.byDate())
        
        var archivedPuzzles = sortedPuzzles
            .reduce(""){ "\($0)\n\($1)"}
        
        // Format .CSV
        archivedPuzzles = archivedPuzzles.replacingOccurrences(of: " ", with: "\t")
        
        archivedPuzzles = """
                            ==============================
                            Puzzle Count: \(sortedPuzzles.count)
                            Last Update:  \(Date().simple)
                            Source:       AltonOutputCSV.process()
                            ==============================
                            Digits Difficulty Date Puzzle#
                            ------------------------------\
                            \(archivedPuzzles)
                            """
        
        printToClipboard(archivedPuzzles)
      
       return   CommandOutput.output(archivedPuzzles, overrideFGColor: UIColor.lightGray)
                + CommandOutput.note("above output copied to pasteboard", newLines: 2)
        
    }
}

