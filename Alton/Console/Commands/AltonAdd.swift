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
    var console: Console
    
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
        let screen = console.screen!
        
        repeat {
            
            let puzzle  = args.elementNum(i)
            let date    = args.elementNum(i + 1).simpleDateMaybe
            
            i += date.isNotNil ? 2 : 1
            
            if Solver.validate(puzzle) {
                
                let puzzle  = Int(puzzle)!
                let date    = date  ?? Date().simple.simpleDate
                
                var (result, format) = ("Failed",
                                        FormatTarget.outputWarning)
                
                if PuzzleArchiver.shared.add(puzzleWithDigits: puzzle,
                                             andDate: date) {
                    
                    (result, format) = ("Succeeded",
                                        .output)
                    
                }
                
                output += screen.format("Archiving \(puzzle.digits),  \(date.simple) ... \(result)\n"
                                        , target: format)
                
            } else {
                
                output += screen.format("""
                                        [ERROR] Please specify valid 4 digit puzzle \
                                        (e.g. 'add 1234')
                                        """,
                                        target: .outputWarning) /*EXIT*/
                
            }
            
        } while args.elementNum(i).isNotEmpty
        
        return output
        
    }
    
}

