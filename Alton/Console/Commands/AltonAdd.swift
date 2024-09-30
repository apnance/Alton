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
struct AltonAdd: Command {
    
    // - MARK: Command Requirements
    var console: Console
    
    var commandToken    = Configs.Console.Commands.Add.token
    
    var isGreedy        = false
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Add.helpText
    
    /// Attempts to add puzzle digits(arg 1) to archive with optional date(arg 2)
    /// - Parameter args: array containing puzzle digits at first index and
    /// optional date at second index.
    ///
    /// - note: unlike companion method comDel, you cannot add more than
    /// puzzle at a time.
    ///
    /// - Returns: status report `CommandOutput` message.
    func process(_ args: [String]?) -> CommandOutput {
        
        let arg1 = args.elementNum(0)
        let arg2 = args.elementNum(1)
        
        guard let puzzleNums = Int(arg1),
              puzzleNums > 0,
              puzzleNums.digits.count == 4
        else {
            
            return console.screen.formatCommandOutput("""
                                                    [ERROR] Please specify valid 4 digit puzzle \
                                                    (e.g. 'add 1234')
                                                    """) /*EXIT*/
            
        }
        
        let date = arg2.simpleDateMaybe ?? Date().simple.simpleDate
        
        PuzzleArchiver.shared.add(puzzleWithDigits: puzzleNums,
                                  withDate: date)
        
        return console.screen.formatCommandOutput("""
                                                Attempted Archival:
                                                \tDigits: \(puzzleNums.digits)
                                                \tDate: \(date.simple)
                                                """)
        
    }
}

