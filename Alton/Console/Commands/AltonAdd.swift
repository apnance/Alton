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
    var commandToken    = Configs.Console.Commands.Add.token
    
    var isGreedy        = false
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Add.helpText
    
    /// Attempts to add puzzle digits to archive with optional date
    /// - Parameter args: array containing puzzle digits alternating with
    /// optional date strings. If a date string follows digits the digits are
    /// archived under that date if possible.  If no date follows a set of puzzle digits
    /// the current date is used.
    ///
    /// - Returns: status report `CommandOutput` message.
    func process(_ args: [String]?) -> CommandOutput {
        
        var i = 0
        var output = CommandOutput()
        
        repeat {
            
            let puzzle  = args.elementNum(i)
            let date    = args.elementNum(i + 1).simpleDateMaybe
            
            i += date.isNotNil ? 2 : 1
            
            if Solver.validate(puzzle) {
                
                let puzzle  = Int(puzzle)!
                let date    = date  ?? Date().simple.simpleDate
                
                if PuzzleArchiver.shared.add(puzzleWithDigits: puzzle,
                                             andDate: date) {
                    
                    output += CommandOutput.output("Archiving \(puzzle.digits),  \(date.simple) ... Succeeded.\n")
                    
                    
                } else {
                    
                    output += CommandOutput.warning("Archiving \(puzzle.digits),  \(date.simple) ... Failed.\n")
                    
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

