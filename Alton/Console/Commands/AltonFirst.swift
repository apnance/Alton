//
//  AltonFirst.swift
//  Alton
//
//  Created by Aaron Nance on 9/29/24.
//

import Foundation
import ConsoleView

/// Command to retrieve the first `n` `ArchivedPuzzle` results.
@available(iOS 15, *)
struct AltonFirst: Command {
    
    // - MARK: Command Requirements
    static var flags    = [Token]()
    
    var commandToken    = Configs.Console.Commands.First.token
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.First.helpText
    
    let validationPattern: CommandArgPattern? = Configs.Console.Commands.First.validationPattern
    
    /// Attempts to return the first `n` `ArchivedPuzzle` results.
    /// - Returns: `CommandOutput`
    func process(_ args: [String]?) -> CommandOutput {
        
        Self.firstLast(args, first: true)
        
    }
    
    /// Common function used by `comFirst(_:)` & `comLast(_:)`
    static func firstLast(_ args:[String]?, first: Bool) -> CommandOutput {
        
        let sortedArchived = PuzzleArchiver.shared.byDate()
        
        var output = CommandOutput.empty
        
        var requestedCount = 1
        var k = 1
        
        let arg1 = args.elementNum(0)
        
        if arg1 != "" {
            
            if let count = Int(arg1) {
                
                if count >= 1 {
                    
                    k = min(count, sortedArchived.count)
                    
                    requestedCount = count
                    
                } else {
                    
                    return CommandOutput.error(msg: "invalid argument: '\(arg1)'. Specify count argument > 0") // EXIT
                    
                }
                
                
            } else {
                
                return CommandOutput.error(msg: "invalid argument: '\(arg1)'. Specify Integer count value.") // EXIT
                
            }
            
        }
        
        let puzzles =  first ? sortedArchived.first(k: k) : sortedArchived.last(k)
        let hintText = first ? "First" : "Last"
        
        output += CommandOutput.output("\(hintText) \(puzzles.count) Archived Puzzle(s)")
        
        for (i, archivedPuzzle) in puzzles.enumerated() {
            
            let word = CommandOutput.output("""
                                                       
                                                #: \(archivedPuzzle.puzzleNum)
                                           Puzzle: \(archivedPuzzle.digits)
                                             Date: \(archivedPuzzle.date.simple)
                                           """,
                                            overrideFGColor: Console.rowColor(i))
            
            output += word
            
        }
        
        if requestedCount != k {
            
            output += CommandOutput.note("requested(\(requestedCount)) > Total(\(puzzles.count))")
            
        }
        
        return output
        
    }
    
}
