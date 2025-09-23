//
//  AltonGet.swift
//  Alton
//
//  Created by Aaron Nance on 10/6/24.
//

import ConsoleView

/// Outputs the puzzle data for a given puzzle number, date, or puzzle digits.  Output can be redirected to another command.
///
/// - note: WordlerGet.swift is a mirror of this functionality.  Any changes to this file might benefit that one as well.
@available(iOS 15, *)
struct AltonGet: Command {
    
    var archiver: PuzzleArchiver
    
    // - MARK: Command Requirements
    static var flags    = ["-", "d", "n", "c"]
    
    var commandToken    = Configs.Console.Commands.Get.token
    
    var category        = Configs.Console.Commands.category
    
    var helpText        = Configs.Console.Commands.Get.helpText
    
    let validationPattern: CommandArgPattern? = Configs.Console.Commands.Get.validationPattern
    
    func process(_ args: [String]?) -> CommandOutput {
        
        var i           = 0
        var arg         = args.elementNum(i)
        var option      = ""
        var contents    = [String]()
        
        /// Advances to next argument returning true unless none found then it returns false.
        func next() -> Bool {
            
            i += 1
            arg = args.elementNum(i)
            
            return arg.isNotEmpty
            
        }
        
        /// Formats content as `CommandOutput`
        func output() -> CommandOutput {
            
            var output  = CommandOutput.empty
            
            for (i, content) in contents.enumerated() {
                
                let content = content.tidy()
                
                output += CommandOutput.output(content + "\n",
                                               overrideFGColor: Console.rowColor(i))
                
            }
            
            return output
            
        }
        
        if arg.type == .option {
            
            option = arg
            
            if !next() {
                
                return output() /*EXIT: Nothing to Do*/
                
            }
            
        }
        
        repeat {
            
            let puzzles = archiver.getFor(arg)
            if puzzles.count == 0 {
                
                contents.append("\(arg): nothing to get.");
                continue /*CONTINUE*/
                
            }
            
            switch option {
                    
                case "-":
                    
                    contents.append(puzzles.reduce("\(arg): ") { "\($0) \($1.digits)"})
                    
                case "d":
                    
                    contents.append(puzzles.reduce("\(arg): ") { "\($0)  \($1.date.simple)"})
                    
                case "n":
                    
                    contents.append(puzzles.reduce("\(arg): ") { "\($0)  \($1.puzzleNum)"})
                    
                case "c":
                    
                    contents.append("\(arg): \(puzzles.count) puzzle(s)")
                    
                    
                default:
                    
                    contents.append(puzzles.reduce("\(arg):") { "\($0) \($1) \n"})
                    
            }
            
        } while next()
        
        return output()
        
    }
}

