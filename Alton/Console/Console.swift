//
//  Console.swift
//  Alton
//
//  Created by Aaron Nance on 12/14/24.
//

import UIKit
import ConsoleView

extension Console {
    
    static func rowColor(_ n: Int) -> UIColor {
    
        let baseColor = Console.configs.fgColorScreenOutput
        
        return baseColor.altRow(n, baseColor.pointSixAlpha)
        
    }
    
}
