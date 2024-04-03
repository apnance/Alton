//
//  Component.swift
//  Alton
//
//  Created by Aaron Nance on 4/2/24.
//

import Foundation

protocol Component: CustomStringConvertible {
    
    func isCloseParen() -> Bool
    func isOpenParen() -> Bool
    func isNum() -> Bool
    
}

extension Component {
    
    func isCloseParen() -> Bool { false }
    func isOpenParen() -> Bool { false }
    func isNum() -> Bool { false }
}

extension Int: Component {
    
    func isNum() -> Bool { true }
    
}

extension Operator: Component {
    
    func isCloseParen() -> Bool { self == .clo }
    func isOpenParen() -> Bool { self == .ope }
    
}
