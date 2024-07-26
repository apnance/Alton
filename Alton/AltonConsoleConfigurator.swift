//
//  AltonConsoleConfigurator.swift
//  Alton
//
//  Created by Aaron Nance on 6/23/24.
//

import UIKit
import APNUtil
import ConsoleView

struct AltonConsoleConfigurator: ConsoleConfigurator {
    
    @discardableResult init(consoleView: ConsoleView) {
        
        self.consoleView = consoleView
        
        load()
        
    }
    
    var consoleView: ConsoleView
    
    var commandGroups: [CommandGroup] {
        
        [AltonCommandGroup(consoleView: consoleView)]
        
    }
    
    var configs: ConsoleViewConfigs {
        
        var configs = ConsoleViewConfigs()
        
        configs.aboutScreen                     = "All Ten's worst nightmare...\n\(consoleView.about)"
        configs.fontSize                        = 9
        configs.fgColorScreenOutput             = .white
        configs.fgColorPrompt                   = .systemYellow.pointEightAlpha
        configs.fgColorCommandLine              = .systemYellow
        configs.fgColorScreenInput              = .systemOrange
        configs.bgColor                         = .black
        configs.borderColor                     = UIColor.white.cgColor
        configs.borderWidth                     = Configs.UI.View.borderWidth.cgFloat
        configs.shouldMakeCommandFirstResponder = true
        configs.shouldHideOnScreenTap           = true
        
        configs.fgColorHistoryBarCommand            = .systemOrange
        configs.fgColorHistoryBarCommandArgument    = .systemYellow
        configs.bgColorHistoryBarMain               = .black.pointEightAlpha
        
        return configs
        
    }
    
    fileprivate class AltonCommandGroup: CommandGroup {
        
        private var solver: Solver?
        
        private let consoleView: ConsoleView
        
        init(consoleView: ConsoleView) {
            
            self.consoleView = consoleView
            
        }
        
        var commands: [Command] {
            [
                Command(token: Configs.Console.Command.Solve.token,
                        process: comSolve,
                        category: Configs.Console.Command.category,
                        helpText:  Configs.Console.Command.Solve.helpText),
                
                Command(token: Configs.Console.Command.Add.token,
                        process: comAdd,
                        category: Configs.Console.Command.category,
                        helpText:  Configs.Console.Command.Add.helpText),
                
                Command(token: Configs.Console.Command.Del.token,
                        process: comDel,
                        category: Configs.Console.Command.category,
                        helpText: Configs.Console.Command.Del.helpText),
                
                Command(token: Configs.Console.Command.Nuke.token,
                        process: comNuke,
                        category: Configs.Console.Command.category,
                        helpText:  Configs.Console.Command.Nuke.helpText),
                
                Command(token: Configs.Console.Command.First.token,
                        process: comFirst,
                        category: Configs.Console.Command.category,
                        helpText:  Configs.Console.Command.First.helpText),
                
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
                
                Command(token: Configs.Console.Command.Diagnostic.token,
                        process: comDiagnostic,
                        category: Configs.Console.Command.category,
                        helpText:  Configs.Console.Command.Diagnostic.helpText),
                
            ]
        }
        
        /// Solves the specified `Puzzle` digits displaying a general result or the results for a specified `Answer`.
        /// - Parameter args: String array containing string formated puzzle digits and maybe an `Answer`
        /// - Returns: colorized puzzle solution results.
        func comSolve(args: [String]?) -> CommandOutput {
            
            let arg1 = args.elementNum(0)
            let arg2 = args.elementNum(1)
            
            let answer: Int? = arg2.isEmpty ? nil : Int(arg2)
            
            guard let digits = Int(arg1)?.digits,
                    digits.count == 4
            else {
                
                return consoleView.formatCommandOutput("""
                                                    [ERROR] Please specify valid 4 digit puzzle \
                                                    (e.g. 'solve 1234')
                                                    """) /*EXIT*/
                
            }
            
            if !arg2.isEmpty {
                
                if  answer.isNil
                    || answer! < 1
                    || answer! > 10 {
                    
                    return consoleView.formatCommandOutput("""
                                                            [ERROR] '\(arg2)' is not a valid answer. \
                                                            Valid answers are integers ranging from 1-10.
                                                            """) /*EXIT*/
                    
                }
                
            }
            
            solver      = Solver(digits)
            
            let font    = consoleView.configs.font
            let atts    = AttributedString(solver!.puzzle.colorizeSolutions(forAnswer: answer,
                                                                            withFont: font))
            
            return atts
            
        }
        
        /// Attempts to add puzzle digits(arg 1) to archive with optional date(arg 2)
        /// - Parameter args: array containing puzzle digits at first index and
        /// optional date at second index.
        ///
        /// - note: unlike companion method comDel, you cannot add more than
        /// puzzle at a time.
        ///
        /// - Returns: status report `CommandOutput` message.
        func comAdd(_ args :[String]?) -> CommandOutput {
            
            let arg1 = args.elementNum(0)
            let arg2 = args.elementNum(1)
            
            guard let puzzleNums = Int(arg1),
                  puzzleNums > 0,
                  puzzleNums.digits.count == 4
            else {
                
                return consoleView.formatCommandOutput("""
                                                        [ERROR] Please specify valid 4 digit puzzle \
                                                        (e.g. 'add 1234')
                                                        """) /*EXIT*/
                
            }
            
            let date = arg2.simpleDateMaybe ?? Date().simple.simpleDate
            
            PuzzleArchiver.shared.add(puzzleWithDigits: puzzleNums,
                                      withDate: date)
            
            return consoleView.formatCommandOutput("""
                                                    Attempted Archival:
                                                    \tDigits: \(puzzleNums.digits)
                                                    \tDate: \(date.simple)
                                                    """)
            
        }
        
        
        /// Attempts to delete `ArchivedPuzzle`s with digits matching argument
        /// list digits.
        /// - Parameter args: one or more 4 digit Int encoded `Puzzle` digits.
        /// - Returns: status report `CommandOutput` message.
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
        
        /// Deletes all user saved `Puzzle` data and reloads defaults from file.
        /// - Parameter args: used to handle response to Y/N query.
        /// - Returns: message indicating result of command.
        func comNuke(args :[String]?) -> CommandOutput {
            
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
                    
                    consoleView.registerCommand(Configs.Console.Command.Nuke.token,
                                                expectingResponse: expectedResponses)
                    
                    commandOutput = """
                                    [Warning] Nuking cannot be undone and will *DELETE ALL* user-saved answers.
                                    
                                    'N' to abort - 'Y' to proceed.
                                    """
                    
            }
            
            return consoleView.formatCommandOutput(commandOutput)
            
        }
        
        /// Attempts to return the first `n` `ArchivedPuzzle` resutls
        /// - Returns: `CommandOutput`
        func comFirst(_ args:[String]?) -> CommandOutput {
            
            firstLast(args, first: true)
            
        }
        
        /// Attempts to return the last `n` `ArchivedPuzzle` resutls
        /// - Returns: `CommandOutput`
        func comLast(_ args:[String]?) -> CommandOutput {
            
            firstLast(args, first: false)
            
        }
        
        /// Common function used by `comFirst(_:)` & `comLast(_:)`
        private func firstLast(_ args:[String]?, first: Bool) -> CommandOutput {
            
            let sortedArchived = PuzzleArchiver.shared.byDate()
            var output = AttributedString("")
            var requestedCount = 1
            var k = 1
            
            let arg1 = args.elementNum(0)
            
            if arg1 != "" {
                
                if let count = Int(arg1) {
                    
                    if count >= 1 {
                        
                        k = min(count, sortedArchived.count)
                        
                        requestedCount = count
                        
                    } else {
                        
                        return consoleView.formatCommandOutput("[Error] Invalid argument: '\(arg1)'. [Error] specify count argument > 0") // EXIT
                        
                    }
                    
                    
                } else {
                    
                    return consoleView.formatCommandOutput("[Error] Invalid argument: '\(arg1)'. Specify Integer count value.") // EXIT
                    
                }
                
            }
            
            let puzzles =  first ? sortedArchived.first(k: k) : sortedArchived.last(k)
            let hintText = first ? "First" : "Last"
            
            output += consoleView.formatCommandOutput("\(hintText) \(puzzles.count) Archived Puzzle(s)")
            
            for (i, archivedPuzzle) in puzzles.enumerated() {
                
                let rowColor =  (i % 2 == 0)
                ? consoleView.configs.fgColorScreenOutput.pointSixAlpha
                : consoleView.configs.fgColorScreenOutput
                
                let word = consoleView.formatCommandOutput("""
                                                           
                                                           \t     #: \(archivedPuzzle.puzzleNum)
                                                           \tPuzzle: \(archivedPuzzle.digits)
                                                           \t  Date: \(archivedPuzzle.date.simple)
                                                           """,
                                                           overrideColor: rowColor)
                
                output += word
                
            }
            
            if requestedCount != k {
                
                output += consoleView.formatCommandOutput("""
                        
                        Note: Requested(\(requestedCount)) > Total(\(puzzles.count))
                        """)
                
            }
            
            return output
            
        }
        
        /// Builds and returns a comma separated values list of `ArchivedPuzzle` 
        /// data in `archive`
        /// - Parameter _: does not require or process arguments.
        /// - Returns: CSV version of all `ArchivedPuzzle` data  in `archive`
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
        
        /// Echoes an ASCII representation of all of missing `ArchivedPuzzle` data.
        /// - Parameter _: does not require or process arguments.
        func comGaps(_:[String]?) -> CommandOutput {
            
            let puzzleNums = PuzzleArchiver.shared.byDate().map{$0.puzzleNum}
            let searchRange = 1...PuzzleArchiver.todaysPuzzleNumber
            
            let output  = GapFinder.describeGaps(in: puzzleNums,
                                             usingRange: searchRange)
            
            return consoleView.formatCommandOutput(output)
            
        }
        
        /// Runs several diagnostic tests on `archive` data.
        /// - Parameter _: does not require or process arguments.
        func comDiagnostic (_ args :[String]?) -> CommandOutput {
            
            var diagnosticResult    = ""
            
            diagnosticResult        += PuzzleArchiver.shared.diagnose()
            
            let puzzleNums          = PuzzleArchiver.shared.byDate().map{$0.puzzleNum}
            let searchRange         = 1...PuzzleArchiver.todaysPuzzleNumber
            
            diagnosticResult += GapFinder.compactDescribeGaps(in: puzzleNums,
                                                              usingRange: searchRange)
            
            return consoleView.formatCommandOutput(diagnosticResult)
            
        }
        
    }
    
}
