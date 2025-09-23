//
//  ConsoleViewTestCase.swift
//  Alton
//
//  Created by Aaron Nance on 9/19/25.
//

import XCTest
import UIKit
import APNUtil
@testable import Alton
@testable import ConsoleView
@testable import FrameworkTestSupport

// courtesy of ChatGPT
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    
    if Configs.Settings.Test.shouldShuntTestPrintMessages { return } // EXIT : Shunted
    
    var output = ""
    
    for (index, item) in items.enumerated() {
        
        if index > 0 { output += separator }
        
        output += String(describing: item)
        
    }
    
    // Call the original print function if needed
    Swift.print(output, separator: separator, terminator: terminator)
    
}

@available(iOS 16, *)
class ConsoleViewTestCase: XCTestCase  {
    
    // NOTE: must import both to replicate ConsoleViewTestCase found in ConsoleView unit tests.
    // @testable import ConsoleView
    // @testable import FrameworkTestSupport
    
    struct RegExp {
        
        /// Matches 08-08-24
        static let zeroPaddedSimpleDate = "\\d{2}-\\d{2}-\\d{2}"
        static let fullGetOutput        = "\\d{4};\\d;\(zeroPaddedSimpleDate);-{0,1}\\d+"
        
    }
    
    
    // BEG : Convenience Shortcuts
    var console: Console { utils.console}
    var utils = CommandTestUtils()
    var consoleView: ConsoleView? {
        get { utils.consoleView }
        set { utils.consoleView = newValue }
    }
    
    override func setUp() {
        
        super.setUp()
        
        // Load HelperConfigurator Test Commands Into Console
        TestConfigurator()
        
    }
    
    /// Global flag for toggling on/off diagnostic print messages
    var showDiagnostics     = false
    
    var defaultFontMin      = 5.0
    var defaultFontMax      = 22.0
    var defaultFontSize     = 8.0
    var defaultFontName     = "Menlo"
    var defaultFontColor    = "blue"
    var defaultFontColorHex: String { UIColor.getColor(named: defaultFontColor)!.hexValue! }
    
}

// - MARK: - DATA
extension ConsoleViewTestCase {
    
    /// Ensures that archived data is in  known state for beginning of tests.
    func setData() {
        
        assert(Data.dates.count >= Data.digits.count)
        
        // Nuke - Get Rid of User Inputted Digits
        utils.testCommand("nuke Y",
                          ["[Warning] Nuke successful: user saved puzzle(s) deleted."])
        
        // Check Expected Count
        utils.testCommand("get c \"0-3000\"",
                          ["0-3000: 152 puzzle(s)\n"])
        
        for i in 0..<Data.dates.count {
            let date = Data.dates[i]
            let digits = Data.digits[i]
            
            utils.testCommand("add \(digits) \"\(date)\"",
                              ["Archiving.*Succeeded\\.\\n"], useRegExMatching: true)
            
        }
        
    }
    
    /// Nukes user entered data - resets to default data.
    func nuke() { utils.runCommandSimple("nuke Y")}
    
    /// Adds some known puzzles for deletion.
    func addDeletables() {
        
        utils.testCommand("add 1234 \"04-25-71\"", ["Archiving [1, 2, 3, 4],  04-25-71 ... Succeeded.\n"])
        utils.testCommand("add 1156 \"09-09-09\"", ["Archiving [1, 1, 5, 6],  09-09-09 ... Succeeded.\n"])
        
    }
    
    struct Data {
        
        
        
        static let puzzleNumToData: [Int : [String]] = [
            
            665 : ["4458", "6", "07-15-24", "665"],
            666 : ["1344", "4", "07-16-24", "666"],
            667 : ["1335", "4", "07-17-24", "667"],
            668 : ["3566", "5", "07-18-24", "668"],
            669 : ["3799", "7", "07-19-24", "669"],
            670 : ["1458", "3", "07-20-24", "670"],
            671 : ["2299", "7", "07-21-24", "671"],
            672 : ["2458", "2", "07-22-24", "672"]
            
        ]
        
        static let dates = [
            "07-15-24",
            "07-16-24",
            "07-17-24",
            "07-18-24",
            "07-19-24",
            "07-20-24",
            "07-21-24",
            "07-22-24"
        ]
        
        static let digits = [
            "4458",
            "1344",
            "1335",
            "3566",
            "3799",
            "1458",
            "2299",
            "2458"
        ]
        
        static let puzzleNums = [
            "665",
            "666",
            "667",
            "668",
            "669",
            "670",
            "671",
            "672"
        ]
    }
}
