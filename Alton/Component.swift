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

extension Operator: Component {
    
    func isCloseParen() -> Bool { self == .clo }
    func isOpenParen() -> Bool { self == .ope }
    
    var complexity: Int {
        
        switch self {
                
            case .add: return 1
            case .sub: return 2
            case .mlt: return 3
            case .div: return 4
            case .ope: return 5
            case .clo: return 0
            case .fra: return 6
            
        }
        
    }
    
}
