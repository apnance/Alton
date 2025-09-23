//
//  CommandNukeTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 9/22/25.
//

import XCTest
import APNUtil

@testable import Alton

final class CommandNukeTests: ConsoleViewTestCase {
    
    func testNukeGeneral() {
        
        func confirmUserData(_ isPresent: Bool) {
            
            if isPresent {
                
                utils.testCommand("get -1234", ["-1234: 1234;1;04-25-71;-18774\n"])
                utils.testCommand("get -1156", ["-1156: 1156;6;09-09-09;-4758\n"])
                
            } else {
                
                utils.testCommand("get -1234", ["-1234: nothing to get.\n"])
                utils.testCommand("get -1156", ["-1156: nothing to get.\n"])
                
            }
            
        }
        
        // Test Deleting w/ Digits in Order
        
        // Add Some to Delete
        addDeletables()
        
        confirmUserData(true)
        utils.testCommand("nuke Y",["[Warning] Nuke successful: user saved puzzle(s) deleted."])
        confirmUserData(false)
        
        addDeletables()
        confirmUserData(true)
        
        utils.testCommand("nuke N",["Nuke operation aborted."])
        confirmUserData(true)
        
    }
    
}
