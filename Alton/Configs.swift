//
//  Configs.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import UIKit

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
                    Operand.Complexity.fraction)    // Operand Complexity
                + (Operator.Complexity.max * 3)     // Operator Complexity - can have at most 3 operators
                + (Operator.Complexity.ope * 2)     // Parentheses Complexity - can have at most 2 sets of parens
                
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
                
            }
            
            struct Add {
                
                static var token    = "add"
                static var category =  Configs.Console.Commands.category
                static var helpText =  """
                                        Attempts to add the specified puzzle(s) to archive with optional per-puzzle trailing date. If no date is specified for a given puzzle, today's date is assumed.
                                        \tUsage:
                                        \t* 'add 1234' adds puzzle [1,2,3,4] with today's date.
                                        \t* 'add 1234 5-24-73' adds puzzle [1,2,3,4] with date of 5-24-1973.
                                        \t* 'add 1234 5-24-73 2244 3355' adds puzzle [1,2,3,4] with date of 
                                        \t  5-24-1973 and puzzles [2,2,4,4] and [3,3,5,5] both with 
                                        \t  today's date.
                                        """
                
            }
            
            struct Del {
                
                static var token    = "del"
                static var category =  Configs.Console.Commands.category
                static var helpText = "'del 1234' deletes puzzle with digits 1,2,3, & 4.  Digit order is irrelevant.'"
                
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
                
            }
            
            struct First {
                
                static var token    = "first"
                static var category =  Configs.Console.Commands.category
                static var helpText = "'first 5' echoes the first 5 puzzles archived."
                
            }
                        
            struct Last {
                
                static var token    = "last"
                static var category =  Configs.Console.Commands.category
                static var helpText = "'last 5' echoes the last 5 puzzles archived."
                
            }
            
            struct CSV {
                
                static var token    = "csv"
                static var category =  Configs.Console.Commands.category
                static var helpText = "Formats remembered answer as CSV and copies to pasteboard."
                
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
                
            }
            
        }
        
    }
    
    struct Test { static var printTestMessage = false }
    
}
