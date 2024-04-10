//
//  Expression.swift
//  Alton
//
//  Created by Aaron Nance on 3/28/24.
//

import Foundation
import APNUtil

struct Expression {
    
    // TODO: Clean Up - move invalidValue to Configs.swift
    static var invalidValue = -1279
    
    var components  = [Component]()
    fileprivate (set) var value         = Expression.invalidValue
    fileprivate var result: any Operand = Expression.invalidValue
    var isValid     = true
    
    /// Simple means for comparing the relative complexity of generated `Expressions`.
    /// The higher the number the greater the relative complexity.
    var complexity: Int {
        
        components.reduce(0){ $0 + $1.complexity }
        
    }
    
    /// Initializes an `Expression` from the input.
    init(_ components: [Component]) {
        
        self.components = components
        
        result  = evaluate()
        value   = (try? result.integerEquivalent()) ?? value
        
//// TODO: Clean Up - delete
//        if let value = try? evaluate().integerEquivalent() {
//            
//            self.value = value
//            
//        }
//        
////        if let value = try? evaluate().integerEquivalent() {
////            
////            self.value = value
////            
////        } else {
////            
////            isValid = false
////        }
        
    }
    
    /// Parses a string containing an expression and returns the corresponding expression.
    init(_ string: String) {
        
        self.init(Expression.parse(string))
        
    }
    
    /// Parses a string containing an `Expression` returning an array of all of the `Component`
    /// - Note: rudimentary validation of parenthetical order and balance is
    /// performed however no validation of operator/operand order/blance is done.
    static func parse(_ string: String) -> [Component] {
        
        let string      = string.replacingOccurrences(of: " ", with: "")
        var components  = [Component]()
        var buffer      = ""
        
        var parenCount  = 0
        
        for compStr in string {
            
            let compStr = String(compStr)
            
            if Int(compStr).isNotNil {
                
                // Buffer
                buffer += compStr
                
            } else {
                
                // Process Buffer
                if let num = Int(buffer) { components.append(num) }
                buffer = "" // Clear Buffer
                
                // Process Operator
                let component = Operator(rawValue: compStr)!
                components.append(component)
                
                parenCount += component.isOpenParen() ? 1 : component.isCloseParen() ? -1 : 0
                
            }
            
            // Check Parens
            assert(parenCount >= 0,
                   """
                    Parenthetical Troubles '\(string)':
                    Check the order and number of open \
                    and close parens.
                    """)
            
        }
        
        // Clean Up
        assert(parenCount == 0,
               """
                Parenthetical Troubles '\(string)':
                Unbalanced parens.
                """)
        
        // Process Buffer
        if let num = Int(buffer) { components.append(num) }
        buffer = "" // Clear Buffer
        
        return components
        
    }
    
    // TODO: Clean Up - Refactor evaluate, factor into sub-funcs
    /// Processes self as a mathematical Expression from left to right, observing rules of precedence.
    fileprivate mutating func evaluate() -> any Operand {
        
        // Replace parentheticals with their evalated selves
        var parenCount = 0
        
        let exp = self.components
        var sansParens = [Component]()
        var subExp = [Component]()
        
        if exp.count == 3 {
            
            let lhs     = exp[0] as! any Operand
            let optor   = exp[1] as! Operator
            let rhs     = exp[2] as! any Operand
            
            let (success, subVal)   = tryEval(lhs: lhs,
                                              optor: optor,
                                              rhs: rhs)
            
            if !success { isValid   = false }
            return subVal /*EXIT*/
            
        }
        
// TODO: Clean Up - delete
printLocal("\n-----Ante Parens:\n\(components)")
        
        // 1. Evaluate Parentheticals
        for component in exp {
            
            if component.isOpenParen() {
                
                if parenCount > 0 { subExp.append(component) } // don't append first paren
                
                // Increment Parentheses Count
                parenCount += 1
                
            } else if component.isCloseParen() {
                
                // Decriment Parentheses Count
                parenCount -= 1
                
                if parenCount == 0 { // don't append terminal paren
                    
                    let sub = Expression(subExp)
                    
                    if !sub.isValid {
                        
                        isValid = false
                        return value /*EXIT*/
                        
                    }
                    
// TODO: Clean Up - delete
//                    let subResult = sub.result
//                    sansParens.append(subResult)
                    
                    sansParens.append(sub.result)
                    
                    // Reset Sub-Expression
                    subExp = []
                    
                } else { subExp.append(component) }
                
            } else {
                
                // Append Component
                if parenCount > 0 { subExp.append(component)}
                else { sansParens.append(component) }
                
            }
            
        }
        
        if sansParens.count == 1 { return sansParens[0] as! any Operand /*EXIT*/ }
        
// TODO: Clean Up - delete
printLocal("\n-----Post Parens:\n\(sansParens)")
        
        // 2. Evaluate/Replace Fractional Sub-Expressions
        var sansFractions   = [Component]()
        var i               = 0
        
        while i <= sansParens.lastUsableIndex - 2 {
            
            let lhs         = sansParens[i]     as! any Operand
            let optor       = sansParens[i + 1] as! Operator
            let rhs         = sansParens[i + 2] as! any Operand
            
            if optor.precedence == .fraction {
                
                let (success, subVal)   = tryEval(lhs: lhs,
                                                  optor: optor,
                                                  rhs: rhs)
                
                if !success { isValid   = false; return value /*EXIT*/ }
                
                sansParens[i + 2]       = subVal
                
                i += 2
                
            } else {
                
                sansFractions.append(lhs)
                sansFractions.append(optor)
                
                i += 2
                
            }
            
        }
        
        sansFractions.append(sansParens.last as! any Operand)
        
// TODO: Clean Up - delete
printLocal("\n-----Post Fractions:\n\(sansFractions)")
        
        // 3. Evaluate/Replace Mult/Div Sub-Expressions
        var sansMltDiv  = [Component]()
        i               = 0
        
        while i <= sansFractions.lastUsableIndex - 2 {
            
            let lhs         = sansFractions[i]      as! any Operand
            let optor  = sansFractions[i + 1]       as! Operator
            let rhs         = sansFractions[i + 2]  as! any Operand
            
            if optor.precedence == .mltDiv {
                
                let (success, subVal)   = tryEval(lhs: lhs,
                                                  optor: optor,
                                                  rhs: rhs)
                
                if !success { isValid   = false; return value /*EXIT*/ }
                
                sansFractions[i + 2]       = subVal
                
                i += 2
                
            } else {
                
                sansMltDiv.append(lhs)
                sansMltDiv.append(optor)
                
                i += 2
                
            }
            
        }
        
        sansMltDiv.append(sansFractions.last as! any Operand)
        
// TODO: Clean Up - delete
printLocal("\n-----Post Mult/Div:\n\(sansMltDiv)")
        
        if sansMltDiv.count == 1 { return sansMltDiv[0] as! any Operand /*EXIT*/ }
        
        // 4. Finish Remaining Add/Sub Operations
        var finalVal: any Operand = 0
        i                   = 0
        
        var lhs         = sansMltDiv[i] as! any Operand
        
        while i <= sansMltDiv.lastUsableIndex - 2 {
            
            let optor       = sansMltDiv[i + 1] as! Operator
            let rhs         = sansMltDiv[i + 2] as! any Operand
            
            var success     = true
            (success, finalVal) = tryEval(lhs: lhs, optor: optor, rhs: rhs)
            
            if !success {
                
                isValid = false
                return value /*EXIT*/
                
            }
            
            lhs         = finalVal
            
            i += 2
            
        }
        
// TODO: Clean Up - delete
printLocal("\n-----Final:\n\(sansMltDiv)")

        
        return finalVal /*EXIT*/
        
    }
    
    /// Utility function for processing error prone evals
    func tryEval(lhs: any Operand, 
                 optor: Operator, 
                 rhs: any Operand) -> (success: Bool, value: any Operand) {
        
        do {
            
            return (true, try optor.operate(lhs, rhs))
            
        } catch {
            
            printLocal("Error occured: \(error.localizedDescription) in Expression: '\(self)'")
            
            return (false, value) /*EXIT*/
            
        }
        
    }

}


// - MARK: Protocol Adoption Extensions
extension Expression: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        return lhs.description == rhs.description
        
    }
    
}


extension Expression: CustomStringConvertible {
    
    var description: String {
        
        "\(components.reduce(""){ $0 + $1.description + " " })"
        
    }
    
    var evaluatedDescription: String {
        
        "\(components.reduce(""){ $0 + $1.description + " " }) = \(value)"
        
    }
    
    var evaluatedWithComplexityDescription: String {
        
        "\(components.reduce(""){ $0 + $1.description + " " }) = \(value) :: complexity: \(self.complexity)"
        
    }
    
}


// - MARK: Helper Data Structures
/// Data structure for managing the simplest atomic `Expression` comprised
/// entire of a left and right hand `Int` operands and an `Operator`
/// e.g. 1+2, 9/3, 10-5, 2 *10, etc.
// TODO: Clean Up - delete?
//fileprivate struct SubExpression {
//    
//    var rhs: Int?
//    var lhs: Int?
//    var `operator`: Operator?
//    
//    func evaluate() throws -> Int {
//        
//        let value = try `operator`!.operate(lhs!, rhs!)
//        
//        printLocal("SubExpression: \(lhs!) \(self.operator!) \(rhs!) = \(value)")
//        
//        return value
//        
//    }
//    
//}
