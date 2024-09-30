//
//  AltonSolve.swift
//  Alton
//
//  Created by Aaron Nance on 9/29/24.
//

import Foundation
import ConsoleView

// TODO: Clean Up - Add command summary comment.
/// Add command summary comment
@available(iOS 15, *)
struct AltonFirst: Command {
    
    // - MARK: Command Requirements
    var console: Console
    
    var commandToken    = Configs.Console.Commands.First.token
    
    var isGreedy        = false
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.First.helpText
    
    /// Attempts to return the first `n` `ArchivedPuzzle` resutls
    /// - Returns: `CommandOutput`
    func process(_ args: [String]?) -> CommandOutput {
        
        Self.firstLast(args, first: true, console: console)
        
    }
    
    /// Common function used by `comFirst(_:)` & `comLast(_:)`
    static func firstLast(_ args:[String]?, first: Bool, console: Console) -> CommandOutput {
        
        let sortedArchived = PuzzleArchiver.shared.byDate()
        
        var output = CommandOutput()
        
        var requestedCount = 1
        var k = 1
        
        let arg1 = args.elementNum(0)
        
        if arg1 != "" {
            
            if let count = Int(arg1) {
                
                if count >= 1 {
                    
                    k = min(count, sortedArchived.count)
                    
                    requestedCount = count
                    
                } else {
                    
                    return console.screen.formatCommandOutput("[Error] Invalid argument: '\(arg1)'. [Error] specify count argument > 0") // EXIT
                    
                }
                
                
            } else {
                
                return console.screen.formatCommandOutput("[Error] Invalid argument: '\(arg1)'. Specify Integer count value.") // EXIT
                
            }
            
        }
        
        let puzzles =  first ? sortedArchived.first(k: k) : sortedArchived.last(k)
        let hintText = first ? "First" : "Last"
        
        output += console.screen.formatCommandOutput("\(hintText) \(puzzles.count) Archived Puzzle(s)")
        
        for (i, archivedPuzzle) in puzzles.enumerated() {
            
            let rowColor =  (i % 2 == 0)
            ? console.screen.configs.fgColorScreenOutput.pointSixAlpha
            : console.screen.configs.fgColorScreenOutput
            
            let word = console.screen.formatCommandOutput("""
                                                       
                                                       \t     #: \(archivedPuzzle.puzzleNum)
                                                       \tPuzzle: \(archivedPuzzle.digits)
                                                       \t  Date: \(archivedPuzzle.date.simple)
                                                       """,
                                                       overrideColor: rowColor)
            
            output += word
            
        }
        
        if requestedCount != k {
            
            output += console.screen.formatCommandOutput("""
                    
                    Note: Requested(\(requestedCount)) > Total(\(puzzles.count))
                    """)
            
        }
        
        return output
        
    }
    
}

