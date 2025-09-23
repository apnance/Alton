//
//  Configs.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import UIKit
import ConsoleView

struct Configs {
    
    struct UI {
        
        struct View {
            
            static var borderWidth  = 0.5
            static var cornerRadius = 4.0
            static var borderColor  = UIColor.orange.halfAlpha.cgColor
        }
    }
    
    struct Puzzle {
        
        static var originalPuzzleDate: Date = "09/20/22".simpleDate
        
        struct Difficulty {
            
            static var maxTheoretical   = 100
            static var scarcityFactor   = 0.4
            static var complexityFactor = 0.6
            static var offset           = -7.0
            static var bucketSize       = 4.6
            static var minEstimated     = 1.0
            static var maxEstimated     = 10.0
            
        }
        
    }
    
    struct Expression {
        
        static var invalidAnswer = -1279
        
        struct Difficulty { static var unsolvable = 999.0 }
        
        struct Complexity {
            
            static var max: Int {
                
                Swift.max(Operand.Complexity.int,
                          Operand.Complexity.fraction)  // Operand Complexity
                + (Operator.Complexity.max * 3)         // Operator Complexity - can have at most 3 operators
                + (Operator.Complexity.ope * 2)         // Parentheses Complexity - can have at most 2 sets of parens
                
            }
            
        }
        
    }
    
    struct Operand {
        
        struct Complexity {
            
            static var int      = 5
            static var fraction = 6
            
        }
        
    }
    
    struct Operator {
        
        struct Precedence {
            
            static var addSub   = 1
            static var mltDiv   = 2
            static var fraction = 3
            static var parens   = 4
            
        }
        
        struct Complexity {
            
            static var add = 10
            static var sub = 11
            static var mlt = 20
            static var div = 30
            static var ope = 40
            static var clo = 0
            static var fra = 65
            
            static var max = fra
            
        }
        
    }
    
    struct Archiver {
        
        struct File {
            
            static let saved    = (name:"SavedPuzzles",
                                   subDir: "Data")
            
            static let defaults = (name:"puzzle.default.data",
                                   type: "txt")
            
        }
        
    }
    
    struct Console {
        
        struct Commands {
            
            static var category = "ALTON"
            
            struct Solve {
                
                static var token    = "solve"
                static var category =  Configs.Console.Commands.category
                static var helpText = """
                Attemps to solve the specified puzzle.
                \tUsage:
                \t* 'solve 1234' creates a solver with digits `1234`
                \t  then echos the general solution.
                \t* 'solve 5678 3' creates a solver with digits `5678`
                \t  then displays all solutions for answer '3'.
                
                """
                
                static var validationPattern = CommandArgPattern(.numSingle,
                                                                 .numSingleOptional).labeled("Puzzle Digits", "For Answer #")
                
            }
            
            struct Add {
                
                static var token    = "add"
                static var category =  Configs.Console.Commands.category
                static var helpText =  """
                                        Attempts to add the specified puzzle(s) to archive with optional date. If no date is specified today's date is assumed.
                                        \tUsage:
                                        \t* 'add 1234' adds puzzle [1,2,3,4] with today's date.
                                        \t* 'add 1234 \"5-24-73\"' adds puzzle [1,2,3,4] with date of 5-23-1983.
                                        """
                
                static var validationPattern = CommandArgPattern(.numSingle,
                                                                 .dateSingleOptional).labeled("Puzzle Digits", "w/ Date")
                
            }
            
            struct Get {
                
                static var token    = "get"
                static var category =  Configs.Console.Commands.category
                static var helpText =   """
                                        Attempts to retrieve data about archived puzzles.
                                        \tUsage:
                                        \t* 'get <date|puzzle#|-digits>' retrieves the associated archived puzzle.
                                        \t   ex1. 'get 04-24-24' retrieves the archived puzzle with date 
                                        \t         04-24-2024.
                                        \t   ex2. 'get 589' retrieves the archived puzzle data for the 589th 
                                        \t         puzzle.
                                        \t   ex3. 'get -1234' retrieves archived data for puzzle [1,2,3,4].
                                        \t* 'get <low-hi>' retrieves the range of archived puzzles 
                                        \t   associated with puzzle #s from low to high. 
                                        \t   ex. 'get 629-741' retrieves the range of archived puzzles with 
                                        \t        numbers 629 to 741.
                                        \t* 'get - <puzzle#|date|low-hi>' retrieves only the digits associated with the specified puzzle number, date or range.
                                        \t* 'get d <puzzle#|-digits|low-hi>' retrieves only the date associated 
                                        \t   with the specified puzzle number or digits.
                                        \t* 'get n <date|-digits|low-hi>' retrieves only the puzzle number 
                                        \t   associated with the specified date, digits or range.
                                        \t   ex1. 'get n 12-07-23' gets the puzzle number for the puzzle from
                                        \t         12-07-2023.
                                        \t   ex2. 'get n -1234' gets the puzzle number for puzzle [1,2,3,4].
                                        \t* 'get c <puzzle#|date|-digits|low-hi>'retrieves only the count of
                                        \t   puzzles associated with the specified puzzle number, date, word
                                        \t   or range.
                                        """
                
                static var validationPattern = CommandArgPattern(.flagSingleOptional,
                                                                 .anyNonFlagMultiOptional).labeled(AltonGet.flagSyntax, "date|puzzle#|-digits")
                
            }
            
            struct Del {
                
                static var token    = "del"
                static var category =  Configs.Console.Commands.category
                static var helpText = "'del 1234' deletes puzzle with digits 1,2,3, & 4.  Digit order is irrelevant.'"
                
                static var validationPattern = CommandArgPattern(.numSingle).labeled("Puzzle Digits")
                
            }
            
            struct Nuke {
                
                static var token    = "nuke"
                static var category =  Configs.Console.Commands.category
                static var helpText = """
                Reverts archived puzzle data to defaults from file \
                puzzle.defaults.data.txt
                \tUsage:
                \t* 'nuke' challenges the user to confirm the request
                \t  before nuking.
                \t* 'nuke Y' bypasses the confirmation nuking archive
                \t  immediately.
                """
                
                static var validationPattern = CommandArgPattern(.flagSingleOptional).labeled(AltonNuke.flagSyntax)
                
            }
            
            struct First {
                
                static var token    = "first"
                static var category =  Configs.Console.Commands.category
                static var helpText = "'first 5' echoes the first 5 puzzles archived."
                
                static var validationPattern = CommandArgPattern(.numSingleOptional).labeled("First n- Count")
                
            }
            
            struct Last {
                
                static var token    = "last"
                static var category =  Configs.Console.Commands.category
                static var helpText = "'last 5' echoes the last 5 puzzles archived."
                
                static var validationPattern = CommandArgPattern(.numSingleOptional).labeled("Last n- Count")
                
            }
            
            struct CSV {
                
                static var token    = "csv"
                static var category =  Configs.Console.Commands.category
                static var helpText = "Formats remembered answer as CSV and copies to pasteboard."
                
                static var validationPattern = CommandArgPattern(.empty)
                
            }
            struct Gaps {
                
                static var token    = "gaps"
                static var category =  Configs.Console.Commands.category
                static var helpText = "Echoes a list of all missing archived puzzles."
                
            }
            
            struct Diagnostic {
                
                static var token    = "diag"
                static var category =  Configs.Console.Commands.category
                static var helpText = "Performs diagnostic test(s)."
                
                static var validationPattern = CommandArgPattern(.empty)
                
            }
            
        }
        
    }
    
    struct Test { static var printTestMessage = false }
    
}


// TODO: Clean Up - Delete this extension when it collides with
// ConsoleView.Command in the not distant future.
extension Command {
    
    static var flagSyntax: String { flags.asCommaSeperatedString(conjunction: "") }
    
}
