//
//  AltonSolve.swift
//  Alton
//
//  Created by Aaron Nance on 9/29/24.
//

import Foundation
import ConsoleView

/// Command to solve an All Ten puzzle.
@available(iOS 15, *)
struct AltonSolve: Command {
    
    // - MARK: Command Requirements
    static var flags    = [Token]()
    
    var commandToken    = Configs.Console.Commands.Solve.token
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Solve.helpText
    
    let validationPattern: CommandArgPattern? = Configs.Console.Commands.Solve.validationPattern
    
    /// Solves the specified `Puzzle` digits displaying a general result or the results for a specified `Answer`.
    /// - Parameter args: `String` array containing `String` formated puzzle digits and maybe an `Answer`
    /// - Returns: colorized puzzle solution results.
    func process(_ args: [String]?) -> CommandOutput {
        
        let arg1 = args.elementNum(0)
        let arg2 = args.elementNum(1)
        
        let answer: Int? = arg2.isEmpty ? nil : Int(arg2)
        
        guard let   digits = Int(arg1)?.digits,
                    digits.count == 4
        else {
            
            return CommandOutput.error(msg:"""
                                            please specify valid 4 digit puzzle \
                                            (e.g. 'solve 1234')
                                            """) /*EXIT*/
            
        }
        
        if !arg2.isEmpty {
            
            if  answer.isNil
                || answer! < 1
                || answer! > 10 {
                
                return CommandOutput.error(msg:"""
                                                '\(arg2)' is not a valid answer. \
                                                Valid answers are integers ranging from 1-10.
                                                """) /*EXIT*/
                
            }
            
        }
        
        let solver          = Solver(digits)
        
        var output          = CommandOutput.empty
        let font            = Console.configs.font
        output.formatted    = AttributedString(solver.puzzle.colorizeSolutions(forAnswer: answer,
                                                                        withFont: font))
        output.raw          = output.formatted.string
        
        return output
        
    }
}

