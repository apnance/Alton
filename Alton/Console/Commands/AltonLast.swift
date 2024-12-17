//
//  AltonSolve.swift
//  Alton
//
//  Created by Aaron Nance on 9/29/24.
//

import Foundation
import ConsoleView

/// Command to retrieve the last `n` `ArchivedPuzzle` results.
@available(iOS 15, *)
struct AltonLast: Command {
    
    // - MARK: Command Requirements    
    var commandToken    = Configs.Console.Commands.Last.token
    
    var isGreedy        = false
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Last.helpText
    
    /// Attempts to return the last `n` `ArchivedPuzzle` resutls
    /// - Returns: `CommandOutput`
    func process(_ args: [String]?) -> CommandOutput {
        
        AltonFirst.firstLast(args, first: false)
        
    }
}

