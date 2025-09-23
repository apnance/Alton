//
//  Argument.swift
//  Alton
//
//  Created by Aaron Nance on 10/4/24.
//

import Foundation

enum AltonArgType { case date, puzzleNum, puzzleNumRange, digits, option, unknown }

/// Custom treatment of `String`s for when they are used as arguments to `Command`s
typealias Argument  = String
extension Argument {
    
    var type: AltonArgType {
        
        if isDigits() { return .digits              /*EXIT*/ }
        else if isPuzzleNum() { return .puzzleNum   /*EXIT*/ }
        else if isOption() { return .option         /*EXIT*/ }
        else if isRange() { return .puzzleNumRange  /*EXIT*/ }
        else if isDate() { return .date             /*EXIT*/ }
        else { return .unknown                      /*EXIT*/ }
        
    }
    
    private func isDigits()     -> Bool { matches("^-[0-9]{4}") }
    private func isOption()     -> Bool { matches("^[a-zA-Z\\-]$") }
    private func isRange()      -> Bool { matches("^[0-9]+-[0-9]+$") }
    private func isPuzzleNum()  -> Bool { matches("^[0-9]+$") }
    private func isDate()       -> Bool { simpleDateMaybe.isNotNil }
    
    private func isNumeric(ofLen digits: Int) -> Bool { matches("^[0-9]{\(digits)}$") }
    
    private func matches(_ regExp:String) -> Bool {
        
        let rx = try! NSRegularExpression(pattern: regExp)
        let rg = NSRange(location: 0, length: utf16.count)
        
        return rx.firstMatch(in: self, range: rg).isNotNil /*EXIT*/
        
    }
    
}
