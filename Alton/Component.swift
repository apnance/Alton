//
//  Component.swift
//  Alton
//
//  Created by Aaron Nance on 4/2/24.
//

import Foundation

protocol Component: CustomStringConvertible {
    
    /// Flag indicating if this `Component` is an open parenthesis
    func isOpenParen() -> Bool
    /// Flag indicating if this `Component` is an close parenthesis
    func isCloseParen() -> Bool
    
    /// Relative measure of complexity of the `Component`
    var complexity: Int { get }
    
    /// A `Component` is required to offer the maximum possible complexity it can have.
    static var maxComplexity: Int { get }
    
}

extension Component {
    
    func isCloseParen() -> Bool { false }
    func isOpenParen() -> Bool { false }
    
}

