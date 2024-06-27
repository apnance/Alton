//
//  AltonConsoleConfigurator.swift
//  Alton
//
//  Created by Aaron Nance on 6/23/24.
//

import UIKit
import APNUtil
import APNConsoleView

struct AltonConsoleConfigurator: ConsoleConfigurator {
    
    @discardableResult init(consoleView: APNConsoleView) {
        
        self.consoleView = consoleView
        
        load()
        
    }
    
    var consoleView: APNConsoleView
    
    var commandGroups: [CommandGroup] {
        
        [AltonCommandGroup(consoleView: consoleView)]
        
    }
    
    var configs: ConsoleViewConfigs {
        
        var configs = ConsoleViewConfigs()
        
        configs.aboutScreen                     = "All Ten's worst nightmare...\n\(consoleView.about)"
        configs.fontSize                        = 12
        configs.fgColorScreenOutput             = .white
        configs.fgColorPrompt                   = .systemYellow.pointEightAlpha
        configs.fgColorCommandLine              = .systemYellow
        configs.fgColorScreenInput              = .systemOrange
        configs.bgColor                         = .black
        configs.borderColor                     = UIColor.white.cgColor
        configs.shouldMakeCommandFirstResponder = true
        configs.shouldHideOnScreenTap           = true
        
        return configs
        
    }
    
    fileprivate struct AltonCommandGroup: CommandGroup {
        
        private let consoleView: APNConsoleView
        
        init(consoleView: APNConsoleView) {
            
            self.consoleView = consoleView
            
        }
        
        var commands: [Command] {
            [
                Command(token: Configs.Console.Command.Del.token,
                        process: comDel,
                        category: Configs.Console.Command.category,
                        helpText: Configs.Console.Command.Del.helpText),
                
                Command(token: Configs.Console.Command.Last.token,
                        process: comLast,
                        category: Configs.Console.Command.category,
                        helpText:  Configs.Console.Command.Last.helpText),
                
                Command(token: Configs.Console.Command.CSV.token,
                        process: comCSV,
                        category: Configs.Console.Command.category,
                        helpText:  Configs.Console.Command.CSV.helpText),
                
                Command(token: Configs.Console.Command.Gaps.token,
                        process: comGaps,
                        category: Configs.Console.Command.category,
                        helpText:  Configs.Console.Command.Gaps.helpText),
                
                Command(token: Configs.Console.Command.Add.token,
                        process: comAdd,
                        category: Configs.Console.Command.category,
                        helpText:  Configs.Console.Command.Add.helpText),
                
            ]
        }
        
        // TODO: Clean Up - tidy/commit
        // TODO: Clean Up - IMPLEMENT gaps()
        func comGaps(_:[String]?) -> CommandOutput {
            
            let puzzleNums  = PuzzleArchiver.shared.byDate().map{$0.puzzleNum}
            let tomorrowNum = PuzzleArchiver.tomorrowsPuzzleNumber
            
            let gaps = GapFinder.findGaps(in: puzzleNums, usingRange: 1...tomorrowNum)
            
            var output = ""
            
            gaps.forEach{ output += "\($0)\n"}
            
            return consoleView.formatCommandOutput(output)
            
        }
        
        // TODO: Clean Up - IMPLEMENT add()
        func comAdd(_:[String]?) -> CommandOutput {
            
            consoleView.formatCommandOutput("Implement: '\(#function)'")
            
        }
        
        func comCSV(_:[String]?) -> CommandOutput {
            
            let sortedPuzzles = Array(PuzzleArchiver.shared.byDate())
            
            var archivedPuzzles = sortedPuzzles
                .reduce(""){ "\($0)\n\($1)"}
            
            // Format .CSV
            archivedPuzzles = archivedPuzzles.replacingOccurrences(of: " ", with: "\t")
            
            archivedPuzzles = """
                                ==============================
                                Puzzle Count: \(sortedPuzzles.count)
                                Last Update:  \(Date().simple)
                                Source:       comCSV()
                                ==============================
                                Digits Difficulty Date Puzzle#
                                ------------------------------\
                                \(archivedPuzzles)
                                """
            
            printToClipboard(archivedPuzzles)
            
            archivedPuzzles              = """
                                            \(archivedPuzzles)
                                            
                                            [Note: above output copied to pasteboard]
                                            """
            
            var atts                = consoleView.formatCommandOutput(archivedPuzzles)
            atts.foregroundColor    = UIColor.lightGray
            
            return atts
            
        }
        
        func comDel(_ args:[String]?) -> CommandOutput {
            
            guard let args = args,
                  args.count > 0
            else {
                
                return consoleView.formatCommandOutput("""
                                                        Please specify 1 or more sets of \
                                                        puzzle digits to delete.\
                                                        \nex. 'del 1234' or \
                                                        'del 1234 2245 2345'
                                                        """) /*EXIT*/
                
            }
            
            var output = ""
            
            var deleted = Array(repeating: false, count: args.count)
            
            for (i, arg) in args.enumerated() {
                
                guard let digits = Int(arg)
                else { continue /*EXIT*/ }
                
                if PuzzleArchiver.shared.delete(puzzleWithDigits: digits) {
                    
                    deleted[i] = true
                    
                }
                
            }
            
            
            var (matched, unmatched) = ([String](), [String]())
            
            for (i, wasDeleted) in deleted.enumerated() {
                
                if wasDeleted { matched.append(args[i]) }
                else {          unmatched.append(args[i]) }
                
            }
            
            if matched.count > 0 {
                
                output += "\nDeleted puzzles(s): \(matched.asCommaSeperatedString(conjunction: "&"))"
                
            }
            
            if unmatched.count > 0 {
                
                output += "\n[ERROR] Puzzle(s) not found: \(unmatched.asCommaSeperatedString(conjunction: "&"))"
                
            }
            
            return consoleView.formatCommandOutput(output)
            
        }
        
        
        func comLast(_ args:[String]?) -> CommandOutput {
            
            var output = AttributedString("")
            
            var k = 1
            
            if let args = args,
               args.count > 0 {
                
                let arg1 = args.first!
                
                guard let lastCount = Int(arg1)
                else {
                    
                    return consoleView.formatCommandOutput("[Error] Invalid argument: '\(arg1)'. Specify Integer count value.") // EXIT
                    
                }
                
                if lastCount < 1 {
                    
                    return consoleView.formatCommandOutput("[Error] Invalid argument: '\(arg1)'. [Error] specify count argument > 0") // EXIT
                }
                
                k = lastCount
                
            }
            
            let lastK = PuzzleArchiver.shared.byDate().last(k)
            
            output += consoleView.formatCommandOutput("\nLast \(lastK.count) Archived Puzzle(s)")
            
            for (i, archivedPuzzle) in lastK.enumerated() {
                
                let rowColor =  (i % 2 == 0)
                ? consoleView.configs.fgColorScreenOutput.halfAlpha
                : consoleView.configs.fgColorScreenOutput.pointEightAlpha
                
                let word = consoleView.formatCommandOutput("""
                                                        
                                                       \t     #: \(archivedPuzzle.puzzleNum)
                                                       \tPuzzle: \(archivedPuzzle.digits)
                                                       \t  Date: \(archivedPuzzle.date.simple)
                                                       """,
                                                           overrideColor: rowColor)
                
                output += word
                
            }
            
            if lastK.count != k {
                
                output += consoleView.formatCommandOutput("""
                        
                        
                        Note: Requested(\(k)) > Total(\(lastK.count))
                        """)
                
            }
            
            return output
            
        }
        
    }
    
}
