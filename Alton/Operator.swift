//
//  Operator.swift
//  Alton
//
//  Created by Aaron Nance on 3/28/24.
//

import UIKit

enum OperatorError: Error, LocalizedError {
    
    case divideByZero, remainderInDivision, nestedFractions
    
    var errorDescription: String? {
        switch self {
                
            case .divideByZero:
                return NSLocalizedString("Attempted to divide by zero.", comment: "Divide By Zero")
                
            case .remainderInDivision:
                return NSLocalizedString("Result of division has remainder and is not a valid solution.", comment: "Division With Remainder")
                
            case .nestedFractions:
                return NSLocalizedString("Result cannot have nested fractions.", comment: "Nested Fraction")
                
        }
    }
    
}

// - MARK: Protocol Adoption
/// - Note: *To facilitate generating test Expressions via String initializer*,
/// rawValue and description values differ in most cases.
/// .mlt - rawValue `*` differs from description string value ` ÷ `,
/// .div - rawValue `/` differs from description string value ` × `,
/// .fra - rawValue `_` differs from description string value `/`,
/// .add - rawValue `+` differs from description string value ` + `,
/// .sub - rawValue `-` differs from description string value ` - `.
enum Operator: String, CaseIterable, Comparable {
    
    static func < (lhs: Operator, rhs: Operator) -> Bool {
        
        lhs.precedence.rawValue < rhs.precedence.rawValue
        
    }
    
    // TODO: Clean Up - get rid of this enum, move the values down into precedence variable...
    enum Precendence: Int {
    
        // TODO: Clean Up - move these magic numbers into configs
        case additionSubtraction    = 1
        case multiplicationDivision = 2
        case fraction               = 3
        case parenthetical          = 4
        
    }
    
    case add = "+" // description renders as ' + '
    case sub = "-" // description renders as ' - '
    case mlt = "*" // description renders as ' × '
    case div = "/" // description renders as ' ÷ '
    case ope = "(" // description renders as '('
    case clo = ")" // description renders as ')'
    case fra = "_" // description renders as '/'
    
    var precedence: Precendence {
        
        switch self {
                
            case .add, .sub: return .additionSubtraction
            case .mlt, .div: return .multiplicationDivision
            case .ope, .clo: return .parenthetical
            case .fra: return .fraction
                
        }
    }
    
    
    /// Array of all `Operator`s excluding open and close parens.
    static let nonParen = [Operator.add, .sub, .div, .mlt, .fra]
    
    func operate<LHS: Operand, RHS: Operand>(_ lhs: LHS,
                                             _ rhs: RHS) throws -> any Operand {
        
        switch self {
                
            case .add: return lhs + rhs
            case .sub: return lhs - rhs
            case .mlt: return lhs * rhs
            case .div: return try lhs / rhs
                
            case .fra:
                
                if let lhs = lhs as? Int,
                    let rhs = rhs as? Int {
                    
                    if rhs == 0 { throw OperatorError.divideByZero /*ERROR*/ }
                    else {
                        
                        return Fraction(numerator: lhs, denominator: rhs) /*SUCCESS*/
                    }
                    
                } else {
                    
                    throw OperatorError.nestedFractions /*ERROR*/
                    
                }
                
            case .ope: fatalError("Wrong turn at Albuquerque?")
            case .clo: fatalError("Wrong turn at Albuquerque?")
                
        }
        
    }
    
    /// Returns the signature color for the `Operator` corresponding to the
    /// provided display text equivalent or nil if specified `displayChar`
    /// doesn't correspond to an existing `Operator`
    ///
    /// - Parameter displayChar: character represening the display
    /// text version of an `Operator`
    /// - Returns: UIColor if the specified displayChar corresponds to an
    /// `Operator` nil otherwise.
    ///
    /// - Note: displayChar and rawValues are not the same for all `Operator`s
    static func colorFor(_ displayChar: Character) -> UIColor? {
        
        let displayValue = String(displayChar)
        
        switch displayValue {
            case "+" :          return UIColor.systemBlue
            case "-" :          return UIColor.systemOrange
            case "×" :          return UIColor.systemGreen
            case "÷" :          return UIColor.systemRed
            case "/" :          return UIColor.yellow
            case "(", ")":      return UIColor.white.pointSixAlpha
                
            default: return nil /*NIL*/
        }
        
    }
    
}

extension Operator: Component {
    
    func isCloseParen() -> Bool { self == .clo }
    func isOpenParen() -> Bool { self == .ope }
    
    static var maxComplexity = Configs.Complexity.Operator.max
    
    var complexity: Int {
        
        switch self {
                
            case .add: return Configs.Complexity.Operator.add
            case .sub: return Configs.Complexity.Operator.sub
            case .mlt: return Configs.Complexity.Operator.mlt
            case .div: return Configs.Complexity.Operator.div
            case .ope: return Configs.Complexity.Operator.ope
            case .clo: return Configs.Complexity.Operator.clo
            case .fra: return Configs.Complexity.Operator.fra
            
        }
        
    }
    
}

extension Operator: CustomStringConvertible {
    
    var description: String {
    
        switch self {
                
            case .add : return " \(rawValue) "
            case .sub : return " \(rawValue) "
                
            case .mlt : return " × "
            case .div : return " ÷ "
            case .fra : return "/"
                
            case .ope : return rawValue
            case .clo : return rawValue
                
        }
        
    }
    
}
