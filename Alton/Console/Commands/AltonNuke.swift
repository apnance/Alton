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
        
        var output = CommandOutput()
        
        let expectedResponses = ["Y","N"]
        
        let arg1 = args.elementNum(0)
        
        switch arg1 {
                
            case "Y":
                
                let startCount  = PuzzleArchiver.shared.count
                PuzzleArchiver.shared.nuke()
                let deleteCount = startCount - PuzzleArchiver.shared.count
                
                output  = CommandOutput.note("Nuke successful: \(deleteCount) user saved puzzle(s) deleted.")
                
            case "N":
                
                output  = CommandOutput.warning("Nuke operation aborted.")
                
            default:
                
                Console.shared.registerCommand(Configs.Console.Commands.Nuke.token,
                                               expectingResponse: expectedResponses)
                
                output  = CommandOutput.warning("""
                                                Nuking cannot be undone and will *DELETE ALL* user-saved answers.
                                                
                                                'N' to abort - 'Y' to proceed.
                                                """)
                
        }
        
        return output
        
    }
    
}

