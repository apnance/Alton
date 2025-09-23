//
//  ConsoleTestCase.swift
//  ConsoleView
//
//  Created by Aaron Nance on 6/4/23.
//

import XCTest
import UIKit
import APNUtil
import FrameworkTestSupport

@testable import ConsoleView

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
    
    // BEG : Convenience Shortcuts
    var console: Console { utils.console}
    var utils = CommandTestUtils()
    var consoleView: ConsoleView? {
        get { utils.consoleView }
        set { utils.consoleView = newValue }
    }
    
    override func setUp() {
        
        super.setUp()
        
        // Initializing a ConsoleView triggers initializion of Console singleton
        // shared with this ConsoleView set as the singelton's ConsoleView.
        consoleView = ConsoleView(frame: CGRect.zero)
        
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
    
    // - MARK: Console Shortcuts
    /// Runs commands to get font into known/testable starting state.
    /// - Returns: Expected command output of running "font"  command.
    @discardableResult func resetFont() -> String {
        utils.eval("font min \(defaultFontMin)")
        utils.eval("font max \(defaultFontMax)")
        utils.eval("font size \(defaultFontSize)")
        utils.eval("font name \(defaultFontName)")
        utils.eval("font color \(defaultFontColor)")
        
        let expected = buildExpectedOutputWith()
        
        utils.testCommand("font", [expected])
        
        // Expected output
        return expected
        
    }
    
    /// Returns an expected font command output with the specified values.
    func buildExpectedOutputWith(fontName: String? = nil,
                                 fontSize: Double? = nil,
                                 fontColorHexValue: String? = nil) -> String {
        
        var fontSizeText = "\(fontSize ?? defaultFontSize)"
        
        let fontSize            = fontSize ?? defaultFontSize
        let fontName            = fontName ?? defaultFontName
        let fontColorHexValue   =  fontColorHexValue ?? defaultFontColorHex
        
        if (fontSize < defaultFontMin) {
            
            fontSizeText = "\(defaultFontMin) <- min font size reached"
            
        } else if fontSize > defaultFontMax {
            
            fontSizeText = "\(defaultFontMax) <- max font size reached"
            
        }
        
        return  """
                  name: \(fontName) - size: \(fontSizeText) - color: \(fontColorHexValue)
                  """
        
    }
    
}
