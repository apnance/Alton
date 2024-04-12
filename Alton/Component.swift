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
    var complexity: Int { get }
    
}

extension Component {
    
    func isCloseParen() -> Bool { false }
    func isOpenParen() -> Bool { false }
    
}

