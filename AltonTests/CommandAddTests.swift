//
//  CommandSolveTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 9/20/25.
//

import XCTest
import APNUtil

@testable import Alton

final class CommandSolveTests: ConsoleViewTestCase {
    
    func testSolveGeneral() {
        
        utils.testCommand("solve 1234",
                          ["""
                              #       Ex.       Found 
                            ---------------------------
                              1  1 × 2 + 3 - 4   355  
                              2  1 + 2 + 3 - 4   294  
                              3  1 + 2 × 3 - 4   244  
                              4  1 + 2 - 3 + 4   232  
                              5    12 - 3 - 4    262  
                              6  1 - 2 + 3 + 4   247  
                              7     31 - 24       63  
                              8  2 - 1 + 3 + 4   111  
                              9     23 - 14      218  
                             10  1 + 2 + 3 + 4   143  
                            --------------------------
                                 Difficulty: 1/10
                            """],
                          shouldTrimOutput: true)
        
        utils.testCommand("solve 1279",
                          ["""
                            #       Ex.       Found 
                            ---------------------------
                              1  1 + 2 + 7 - 9   308  
                              2    27 ÷ 9 - 1     73  
                              3  2 - 1 - 7 + 9    70  
                              4    7 - 12 + 9    154  
                              5    21 - 7 - 9     65  
                              6    17 - 2 - 9     38  
                              7    72 ÷ 9 - 1     11  
                              8     27 - 19       81  
                              9    1 + 72 ÷ 9     17  
                             10    12 + 7 - 9     18  
                            --------------------------
                                 Difficulty: 3/10
                            """],
                          shouldTrimOutput: true)
        
        utils.testCommand("solve 1117",
                          ["""
                            #        Ex.        Found 
                            -----------------------------
                              1  1 + (1 - 1) × 7    11  
                              2        -NA-         0   
                              3     11 - 1 - 7      4   
                              4   7 - 1 - 1 - 1     17  
                              5     11 + 1 - 7      28  
                              6      17 - 11        89  
                              7   1 - 1 + 1 × 7    209  
                              8   1 + 1 - 1 + 7    171  
                              9   1 + 1 + 1 × 7     72  
                             10   1 + 1 + 1 + 7     4   
                            ----------------------------
                                   Unsolvable: [2]
                            """],
                          shouldTrimOutput: true)
        
    }
    
    func testSolveForSpecificAnswer() {
        
        utils.testCommand("solve 1111 9",
                          ["""
                            #     Soln.    Comp. 
                            -----------------------
                             9  11 - 1 - 1    27 
                            """],
                          shouldTrimOutput: true)
        
        utils.testCommand("solve 1119 6",
                          ["""
                            #      Soln.      Comp. 
                            --------------------------
                             6  9 - 1 - 1 - 1    33 
                            """],
                          shouldTrimOutput: true)
        
        utils.testCommand("solve 1117 2",
                          ["No Solutions Found For: 2"],
                          shouldTrimOutput: true)
        
    }
    
}
