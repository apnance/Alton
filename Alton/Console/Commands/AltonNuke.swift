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
    var console: Console
    
    var commandToken    = Configs.Console.Commands.Nuke.token
    
    var isGreedy        = false
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Nuke.helpText
    
    /// Deletes all user saved `Puzzle` data and reloads defaults from file.
    /// - Parameter args: used to handle response to Y/N query.
    /// - Returns: message indicating result of command.
    func process(_ args: [String]?) -> CommandOutput {
        
        var commandOutput = ""
        let expectedResponses = ["Y","N"]
        
        let arg1 = args.elementNum(0)
        
        switch arg1 {
                
            case "Y":
                
                let startCount  = PuzzleArchiver.shared.count
                PuzzleArchiver.shared.nuke()
                let deleteCount = startCount - PuzzleArchiver.shared.count
                
                commandOutput   = "Nuke successful: \(deleteCount) user saved puzzle(s) deleted."
                
            case "N":
                
                commandOutput   = "Nuke operation aborted."
                
            default:
                
                console.registerCommand(Configs.Console.Commands.Nuke.token,
                                            expectingResponse: expectedResponses)
                
                commandOutput = """
                                [Warning] Nuking cannot be undone and will *DELETE ALL* user-saved answers.
                                
                                'N' to abort - 'Y' to proceed.
                                """
                
        }
        
        return console.screen.formatCommandOutput(commandOutput)
        
    }
}

