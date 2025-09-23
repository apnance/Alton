//
//  AltonSolve.swift
//  Alton
//
//  Created by Aaron Nance on 9/29/24.
//

import Foundation
import ConsoleView

/// Command to delete all user saved `Puzzle` data and reloads defaults from file.
@available(iOS 15, *)
struct AltonNuke: Command {
    
    // - MARK: Command Requirements
    static var flags = ["Y", "N"]
    
    var commandToken    = Configs.Console.Commands.Nuke.token
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Nuke.helpText
    
    let validationPattern: CommandArgPattern? = Configs.Console.Commands.Nuke.validationPattern
    
    /// Deletes all user saved `Puzzle` data and reloads defaults from file.
    /// - Parameter args: used to handle response to Y/N query.
    /// - Returns: message indicating result of command.
    func process(_ args: [String]?) -> CommandOutput {
        
        return yesNo(prompt: """
                                Nuking cannot be undone and will *DELETE ALL* user-saved answers.
                                
                                'N' to abort - 'Y' to proceed.
                                """,
                     yesMsg: CommandOutput.warning("Nuke successful: user saved puzzle(s) deleted."),
                     noMsg: CommandOutput.emphasized("Nuke operation aborted."),
                     args: args,
                     yesCallback: { PuzzleArchiver.shared.nuke() })
        
    }
    
}

