//
//  Configs.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import Foundation

struct Configs {
    
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
        
        struct Command {
            
            static var category = "alton"
            
            struct Add {
                
                static var token = "add"
                static var category =  Configs.Console.Command.category
                static var helpText =  """
                                        Attemps to add the specified puzzle(s) to archive.
                                        \tUsage:
                                        \t* 'add 1234 5678 9999' adds puzzles [1,2,3,4], [5,6,7,8], and [9,9,9,9]
                                        \t  to archived puzzles.
                                        """
                
            }
            
            struct Del {
                
                static var token = "del"
                static var category =  Configs.Console.Command.category
                static var helpText = "'del 1234' deletes puzzle with digits 1,2,3, & 4.  Digit order is irrelevant.'"
                
            }
            
            struct Last {
                
                static var token = "last"
                static var category =  Configs.Console.Command.category
                static var helpText = "'last 5' echoes the last 5 puzzles archived."
                
            }
            
            struct CSV {
                
                static var token = "csv"
                static var category =  Configs.Console.Command.category
                static var helpText = "Formats remembered answer as CSV and copies to pasteboard."
                
            }
            
            struct Gaps {
                
                static var token = "gaps"
                static var category =  Configs.Console.Command.category
                static var helpText = "Echoes a list of all missing archived puzzles."
                
            }
            
        }
        
    }
    
    struct Test { static var printTestMessage = false }
    
}
