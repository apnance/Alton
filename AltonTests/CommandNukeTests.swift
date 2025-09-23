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
    
    /// Adds some known puzzles for deletion.
    private func addDeletables() {
        
        utils.testCommand("add 1234 \"04-25-71\"", ["Archiving [1, 2, 3, 4],  04-25-71 ... Succeeded.\n"])
        utils.testCommand("add 1156 \"09-09-09\"", ["Archiving [1, 1, 5, 6],  09-09-09 ... Succeeded.\n"])
        
    }
    
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
