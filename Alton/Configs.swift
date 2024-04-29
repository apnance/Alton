//
//  Configs.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import Foundation

struct Configs {
    
    struct Puzzle {
        
        static var maxTheoreticalDifficulty = 100
        
    }
    
    struct Expression {
        
        static var invalidAnswer        = -1279
        static var unsolvableDifficulty = 999.0
        
    }
    
    struct Precedence {
        
        static var addSub   = 1
        static var mltDiv   = 2
        static var fraction = 3
        static var parens   = 4
        
    }
    
    struct Complexity {
        
        struct Operand {
            
            static var int      = 5
            static var fraction = 6
            
        }
        
        struct Operator {
            
            static var add = 10
            static var sub = 11
            static var mlt = 20
            static var div = 30
            static var ope = 40
            static var clo = 0
            static var fra = max
            
            static var max = 65
            
        }
    }
    
    
    struct Test {
        
        static var printTestMessage = false
        
    }
    
}
