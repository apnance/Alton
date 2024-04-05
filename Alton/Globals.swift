//
//  Globals.swift
//  Alton
//
//  Created by Aaron Nance on 4/5/24.
//

import Foundation

/// A utility method for printing purely test messages with ability to silence all attempts to print via
/// `Configs.Test.printTestMessage` flag in configs.
/// - Parameter toPrint: `String` to print
func printLocal(_ toPrint: String) {
    
    if Configs.Test.printTestMessage { print("PL: \(toPrint)") }
    
}

