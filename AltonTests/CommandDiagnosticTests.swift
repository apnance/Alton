//
//  CommandDiagnosticTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 9/22/25.
//

import XCTest
import APNUtil

@testable import Alton

final class CommandDiagnosticTests: ConsoleViewTestCase {
    
    func testDiagnosticGeneral() {
        
        // Reset Data
        nuke()
        
        utils.testCommand("diag", ["""
                                    Duplicates:
                                      Digits(0):
                                    
                                       Dates(0):
                                    """],
                          shouldTrimOutput: true)
        
        utils.testCommand("last 2", ["""
                            Last 2 Archived Puzzle(s)            
                                 #: 740
                            Puzzle: [5, 4, 4, 3]
                              Date: 09-28-24            
                                 #: 741
                            Puzzle: [9, 9, 9, 2]
                              Date: 09-29-24
                            """])
        
        utils.runCommandSimple("add 1234 | add 1156")
        
        utils.testCommand("diag", ["""
                                    Duplicates:
                                      Digits\\(0\\):
                                    
                                       Dates\\(1\\):
                                        \\* 09-22-25
                                        .*;09-22-25;1099
                                        .*;09-22-25;1099
                                    """],
                          shouldTrimOutput: true,
                          useRegExMatching: true)
        
        utils.testCommand("last 2", ["""
                            Last 2 Archived Puzzle(s)            
                                 #: 740
                            Puzzle: [5, 4, 4, 3]
                              Date: 09-28-24            
                                 #: 741
                            Puzzle: [9, 9, 9, 2]
                              Date: 09-29-24
                            """], shouldExpectMatching: false)
        
        // Reset Data
        nuke()
        
        utils.testCommand("diag", ["""
                                    Duplicates:
                                      Digits(0):
                                    
                                       Dates(0):
                                    
                                    
                                    """])
        
    }
    
}
