//
//  CommandLastTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 9/22/25.
//

import XCTest
import APNUtil

@testable import Alton

final class CommandLastTests: ConsoleViewTestCase {
    
    func testLastGeneral() {
        
        // Reset Data
        nuke()
        
        // "first"
        utils.testCommand("last",      ["""
                                            Last 1 Archived Puzzle(s)            
                                                 #: 741
                                            Puzzle: [9, 9, 9, 2]
                                              Date: 09-29-24
                                            """])
        
        // first 1
        utils.testCommand("last 1",      ["""
                                            Last 1 Archived Puzzle(s)            
                                                 #: 741
                                            Puzzle: [9, 9, 9, 2]
                                              Date: 09-29-24
                                            """])
        
        // first 3
        utils.testCommand("last 3",    ["""
                                            Last 3 Archived Puzzle(s)            
                                                 #: 739
                                            Puzzle: [9, 3, 1, 1]
                                              Date: 09-27-24            
                                                 #: 740
                                            Puzzle: [5, 4, 4, 3]
                                              Date: 09-28-24            
                                                 #: 741
                                            Puzzle: [9, 9, 9, 2]
                                              Date: 09-29-24
                                            """])
        
        // "first 5"
        utils.testCommand("last 5",    ["""
                                            Last 5 Archived Puzzle(s)            
                                                 #: 737
                                            Puzzle: [9, 6, 4, 2]
                                              Date: 09-25-24            
                                                 #: 738
                                            Puzzle: [7, 6, 2, 2]
                                              Date: 09-26-24            
                                                 #: 739
                                            Puzzle: [9, 3, 1, 1]
                                              Date: 09-27-24            
                                                 #: 740
                                            Puzzle: [5, 4, 4, 3]
                                              Date: 09-28-24            
                                                 #: 741
                                            Puzzle: [9, 9, 9, 2]
                                              Date: 09-29-24
                                            """])

    }
    
}
