//
//  CommandFirstTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 9/22/25.
//

import XCTest
import APNUtil

@testable import Alton

final class CommandFirstTests: ConsoleViewTestCase {
    
    func testFirstGeneral() {
        
        // "first"
        utils.testCommand("first",      ["""
                                            First 1 Archived Puzzle(s)            
                                                 #: -18774
                                            Puzzle: [1, 2, 3, 4]
                                              Date: 04-25-71
                                            """])
        
        // first 1
        utils.testCommand("first 1",      ["""
                                            First 1 Archived Puzzle(s)            
                                                 #: -18774
                                            Puzzle: [1, 2, 3, 4]
                                              Date: 04-25-71
                                            """])
        
        // first 3
        utils.testCommand("first 3",    ["""
                                            First 3 Archived Puzzle(s)            
                                                 #: -18774
                                            Puzzle: [1, 2, 3, 4]
                                              Date: 04-25-71            
                                                 #: -4758
                                            Puzzle: [1, 1, 5, 6]
                                              Date: 09-09-09            
                                                 #: 589
                                            Puzzle: [8, 8, 5, 4]
                                              Date: 04-30-24
                                            """])
        
        // "first 5"
        utils.testCommand("first 5",    ["""
                                            First 5 Archived Puzzle(s)            
                                                 #: -18774
                                            Puzzle: [1, 2, 3, 4]
                                              Date: 04-25-71            
                                                 #: -4758
                                            Puzzle: [1, 1, 5, 6]
                                              Date: 09-09-09            
                                                 #: 589
                                            Puzzle: [8, 8, 5, 4]
                                              Date: 04-30-24            
                                                 #: 590
                                            Puzzle: [6, 3, 3, 3]
                                              Date: 05-01-24            
                                                 #: 591
                                            Puzzle: [9, 7, 5, 2]
                                              Date: 05-02-24
                                            """])

    }
    
}
