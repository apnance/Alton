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
    
    @discardableResult init(consoleView: ConsoleView,
                            archiver: PuzzleArchiver) {
        
        self.consoleView    = consoleView
        self.archiver       = archiver
        
        load()
        
    }
    
    var archiver: PuzzleArchiver
    var consoleView: ConsoleView
    var console: Console { consoleView.console }
    
    var commands: [Command]? {
        
        [
            
            AltonSolve(console: console),
            AltonAdd(console: console),
            AltonGet(archiver: archiver, console: console),
            AltonDel(console: console),
            AltonNuke(console: console),
            AltonFirst(console: console),
            AltonLast(console: console),
            AltonCSV(console: console),
            AltonDiagnostic(console: console)
            
        ]
        
    }
    
    var configs: ConsoleViewConfigs? {
        
        var configs = ConsoleViewConfigs()
        
        configs.aboutScreen                     = "All Ten's worst nightmare...\n\(consoleView.about)"
        configs.fontSize                        = 9
        configs.fgColorScreenOutput             = .white
        configs.fgColorPrompt                   = .systemYellow.pointEightAlpha
        configs.fgColorCommandLine              = .systemYellow
        configs.fgColorScreenInput              = .systemOrange
        configs.bgColor                         = .black
        configs.borderColor                     = UIColor.white.cgColor
        configs.borderWidth                     = Configs.UI.View.borderWidth.cgFloat
        configs.shouldMakeCommandFirstResponder = true
        configs.shouldHideOnScreenTap           = true
        
        configs.fgColorHistoryBarCommand            = .systemOrange
        configs.fgColorHistoryBarCommandArgument    = .systemYellow
        configs.bgColorHistoryBarMain               = .black.pointEightAlpha
        
        return configs
        
    }
    
}
