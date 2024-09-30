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
struct AltonDel: Command {
    
    // - MARK: Command Requirements
    var console: Console
    
    var commandToken    = Configs.Console.Commands.Del.token
    
    var isGreedy        = false
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Del.helpText
    
    /// Attempts to delete `ArchivedPuzzle`s with digits matching argument
    /// list digits.
    /// - Parameter args: one or more 4 digit Int encoded `Puzzle` digits.
    /// - Returns: status report `CommandOutput` message.
    func process(_ args: [String]?) -> CommandOutput {
        
        guard let args = args,
              args.count > 0
        else {
            
            return console.screen.formatCommandOutput("""
                                                    Please specify 1 or more sets of \
                                                    puzzle digits to delete.\
                                                    \nex. 'del 1234' or \
                                                    'del 1234 2245 2345'
                                                    """) /*EXIT*/
            
        }
        
        var output = ""
        
        var deleted = Array(repeating: false, count: args.count)
        
        for (i, arg) in args.enumerated() {
            
            guard let digits = Int(arg)
            else { continue /*EXIT*/ }
            
            if PuzzleArchiver.shared.delete(puzzleWithDigits: digits) {
                
                deleted[i] = true
                
            }
            
        }
        
        var (matched, unmatched) = ([String](), [String]())
        
        for (i, wasDeleted) in deleted.enumerated() {
            
            if wasDeleted { matched.append(args[i]) }
            else {          unmatched.append(args[i]) }
            
        }
        
        if matched.count > 0 {
            
            output += "\nDeleted puzzles(s): \(matched.asCommaSeperatedString(conjunction: "&"))"
            
        }
        
        if unmatched.count > 0 {
            
            output += "\n[ERROR] Puzzle(s) not found: \(unmatched.asCommaSeperatedString(conjunction: "&"))"
            
        }
        
        return console.screen.formatCommandOutput(output)
        
    }
}

