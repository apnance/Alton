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
        
        configs.aboutScreen                     = "All Ten's worst nightmare...\n\(Console.screen.about)"
        configs.fontSize                        = 9
        configs.fgColorScreenOutput             = .white
        configs.fgColorPrompt                   = .systemYellow.pointEightAlpha
        configs.fgColorCommandLine              = .systemYellow
        configs.fgColorScreenInput              = .systemOrange
        configs.fgColorScreenOutputNote         = .systemBlue
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
