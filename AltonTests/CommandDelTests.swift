//
//  CommandDelTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 9/22/25.
//

import XCTest
import APNUtil

@testable import Alton

final class CommandDelTests: ConsoleViewTestCase {
    
    func testDelGeneral() {
        
        // Test Deleting w/ Digits in Order
        
        // Add Some to Delete
        addDeletables()
        
        // Delete
        utils.testCommand("del 1234", ["""
                                        [Warning] Deleted puzzles(s):
                                        '1234'
                                        
                                        """])
        utils.testCommand("del 1156", ["""
                                        [Warning] Deleted puzzles(s):
                                        '1156'
                                        
                                        """])
        
        // Test Deleting w/ Digits Scrambled
        
        addDeletables()
        
        // Delete
        utils.testCommand("del 3412", ["""
                                        [Warning] Deleted puzzles(s):
                                        '3412'
                                        
                                        """])
        utils.testCommand("del 1651", ["""
                                        [Warning] Deleted puzzles(s):
                                        '1651'
                                        
                                        """])
        
    }
    
}
