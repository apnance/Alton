//
//  CommandAddTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 9/22/25.
//

import XCTest
import APNUtil

@testable import Alton

final class CommandAddTests: ConsoleViewTestCase {
    
    func testAddGeneral() {
        
        let today = Date().simple
        
        // Succeed
        utils.testCommand("add 1234", ["Archiving [1, 2, 3, 4],  \(today) ... Succeeded.\n"])
        utils.testCommand("add 1234 \"04-25-71\"", ["Archiving [1, 2, 3, 4],  04-25-71 ... Succeeded.\n"])
        
        // Fail
        utils.testCommand("add 1111", ["[Warning] Archiving [1, 1, 1, 1],  \(today) ... Failed.\n"])
        utils.testCommand("add 1111 \"04-26-79\"", ["[Warning] Archiving [1, 1, 1, 1],  04-26-79 ... Failed.\n"])
        
    }
    
}
