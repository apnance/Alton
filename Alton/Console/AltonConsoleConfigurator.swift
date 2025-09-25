//
//  AltonConsoleConfigurator.swift
//  Alton
//
//  Created by Aaron Nance on 6/23/24.
//

import UIKit
import APNUtil
import ConsoleView

struct AltonConsoleConfigurator: ConsoleConfigurator {
    
    @discardableResult init(archiver: PuzzleArchiver) {
        
        self.archiver       = archiver
        
        load()
        
    }
    
    var archiver: PuzzleArchiver
    var commands: [Command]? {
        
        [
            
            AltonSolve(),
            AltonAdd(),
            AltonGet(archiver: archiver),
            AltonDel(),
            AltonNuke(),
            AltonFirst(),
            AltonLast(),
            AltonCSV(),
            AltonDiagnostic()
            
        ]
        
    }
    
    var configs: ConsoleViewConfigs? {
        
        var configs = ConsoleViewConfigs()
        
        configs.aboutScreen                         = "All Ten's worst nightmare...\n\(Console.screen.about)"
        configs.fontSize                            = 9
        configs.fgColorScreenOutput                 = .white
        configs.fgColorPrompt                       = .systemYellow.pointEightAlpha
        configs.fgColorCommandLine                  = .systemYellow
        configs.fgColorScreenInput                  = .systemOrange
        configs.fgColorScreenOutputNote             = .systemBlue
        configs.bgColor                             = .black
        configs.borderColor                         = UIColor.white.cgColor
        configs.borderWidth                         = Configs.UI.View.borderWidth.cgFloat
        configs.shouldMakeCommandFirstResponder     = true
        configs.shouldHideOnScreenTap               = true
        
        // Keyboard Accessory View Colors
        let blue1   = UIColor.systemBlue
        let orange1 = UIColor.systemOrange
        let orange2 = UIColor.systemOrange.pointSevenAlpha
        let yellow1 = UIColor.systemYellow
        let yellow2 = UIColor.systemYellow.pointSevenAlpha
        let white1  = UIColor.white
        let white2  = UIColor.white.pointEightAlpha
        let black1  = UIColor.black.pointNineAlpha
        let black2  = UIColor.black.pointSevenAlpha
        configs.cvaBGColor                          = black2
        configs.cvaHistoryBar                       = ColorPalette(bg: black1,       fg: blue1, brdr: blue1)
        configs.cvaCommandToken                     = ColorPalette(bg: black1,       fg: orange1, brdr: orange1)
        configs.cvaCommandRaw                       = ColorPalette(bg: black1,       fg: orange2, brdr: orange2)
        configs.cvaCommandFlag                      = ColorPalette(bg: black1,       fg: white2, brdr: white2)
        configs.cvaNumeric                          = ColorPalette(bg: black1,       fg: yellow1, brdr: yellow1)
        configs.cvaOperator                         = ColorPalette(bg: black1,       fg: white1, brdr: white2)
        configs.cvaQuotes                           = ColorPalette(bg: black1,       fg: orange2, brdr: orange2)
        configs.cvaPound                            = ColorPalette(bg: black1,       fg: orange2, brdr: orange2)
        configs.cvaParenthetical                    = ColorPalette(bg: black1,       fg: orange2, brdr: orange2)
        configs.cvaUndefined                        = ColorPalette(bg: .systemGray2, fg: white2, brdr: white2)
        
        configs.shouldShowOnLoad                    = false
        
        return configs
        
    }
    
}
