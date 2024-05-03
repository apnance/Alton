//
//  Component.swift
//  Alton
//
//  Created by Aaron Nance on 4/2/24.
//

import Foundation

/// The building block of an `Expression`. Can be either an `Operand`
/// or an `Operator`
protocol Component: CustomStringConvertible {
    
    /// Flag indicating if this `Component` is an open parenthesis
    func isOpenParen() -> Bool
    
    /// Flag indicating if this `Component` is an close parenthesis
    func isCloseParen() -> Bool
    
    /// Relative measure of complexity of the `Component`
    var complexity: Int { get }
    
    static var maxComplexity: Int { get }
    
}

extension Component {
    
    func isCloseParen() -> Bool { false }
    func isOpenParen() -> Bool { false }
    
}

