//
//  AltonSolve.swift
//  Alton
//
//  Created by Aaron Nance on 9/29/24.
//

import Foundation
import ConsoleView

/// Command the runs various diagnostic tests in `Console`.
@available(iOS 15, *)
struct AltonDiagnostic: Command {
    
    // - MARK: Command Requirements
    static var flags    = [Token]()
    
    var commandToken    = Configs.Console.Commands.Diagnostic.token
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Diagnostic.helpText
    
    let validationPattern: CommandArgPattern? = Configs.Console.Commands.Diagnostic.validationPattern
    
    /// Runs several diagnostic tests on `archive` data.
    /// - Parameter _: does not require or process arguments.
    func process(_ args: [String]?) -> CommandOutput {
        
        CommandOutput.output(PuzzleArchiver.shared.diagnose())
        
    }
}

