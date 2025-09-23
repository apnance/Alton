//
//  AltonSolve.swift
//  Alton
//
//  Created by Aaron Nance on 9/29/24.
//

import Foundation
import ConsoleView

/// Command to add puzzle digits to archive.
@available(iOS 15, *)
struct AltonAdd: Command {
    
    // - MARK: Command Requirements
    static var flags    = [Token]()
    
    var commandToken    = Configs.Console.Commands.Add.token
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Add.helpText
    
    let validationPattern: CommandArgPattern? = Configs.Console.Commands.Add.validationPattern
    
    /// Attempts to add puzzle digits to archive with optional date; today's date is used if none provided.
    ///
    /// - Returns: status report `CommandOutput` message.
    func process(_ args: [String]?) -> CommandOutput {
        
        // Note: the actual capability of this function for handling inputs is
        // greater than specified in comment above, however `validationPattern`
        // restrict inputs to those specified(i.e. "add 1232" or "add 1232 12-12-12")
        
        var i = 0
        var output = CommandOutput.empty
        
        repeat {
            
            let puzzle      = args.elementNum(i)
            let date        = args.elementNum(i + 1).simpleDateMaybe
            
            i += date.isNotNil ? 2 : 1
            
            if Solver.validate(puzzle) {
                
                let puzzle  = Int(puzzle)!
                let date    = date  ?? Date().simple.simpleDate
                
                let digits  = puzzle.digits.sorted()
                
                if PuzzleArchiver.shared.add(puzzleWithDigits: puzzle,
                                             andDate: date) {
                    
                    output += CommandOutput.output("Archiving \(digits),  \(date.simple) ... Succeeded.\n")
                    
                } else {
                    
                    output += CommandOutput.warning("Archiving \(digits),  \(date.simple) ... Failed.\n")
                    
                }
                
            } else {
                
                output += CommandOutput.error(msg: """
                                                    please specify valid 4 digit puzzle \
                                                    (e.g. 'add 1234')
                                                    """) /*EXIT*/
                
            }
            
        } while args.elementNum(i).isNotEmpty
        
        return output
        
    }
    
}

