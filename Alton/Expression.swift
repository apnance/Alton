//
//  Expression.swift
//  Alton
//
//  Created by Aaron Nance on 3/28/24.
//

import Foundation
import APNUtil

struct Expression {
    
    var components  = [Component]()
    var value       = -1279
    var isValid     = true
    
    /// Initializes an `Expression` from the input.
    init(_ components: [Component]) {
        
        self.components = components
        value           = evaluate()
        
    }
    
    /// Parses a string containing an expression and returns the corresponding expression.
    init(_ string: String) {
        
        self.init(Expression.parse(string))
        
    }
    
    /// Evaluates the `Expression` returning the value.
    /// - Important: `evaluate` does treats floating point results from
    /// sub-expression evaluation as errors resulting in the return value of -1279
    mutating fileprivate func evaluate2() -> Int {
        
        var stack = ComponentStack()
        
        func evaluateSub() -> Bool {
            
            var sub = SubExpression()
            
            while let next = stack.pop(),
                  !next.isOpenParen() {
                
                // Build Sub-Expression
                if next.isNum() {   // Operand
                    
                    if sub.rhs.isNil { sub.rhs = next as? Int}
                    else { sub.lhs = next as? Int}
                    
                } else {            // Operator
                    
                    sub.operator = next as? Operator
                    
                }
                
                // Evaluate Sub-Expression
                if sub.lhs.isNotNil {
                    
                    let subResult: Int
                    
                    do {
                        
                        subResult = try sub.evaluate()
                        
                    } catch {
                        
                        if Configs.Test.printTestMessage {
                            
                            print("Error occured: \(error.localizedDescription) in Expression: '\(self)'")
                            
                        }
                        
                        isValid = false
                        
                        return false /*EXIT*/
                        
                    }
                    
                    // Push Result
                    stack.push(subResult)
                    
                    // Reset Sub-Expression
                    sub = SubExpression()
                    
                }
                
            }
            
            stack.push(sub.rhs!)
            
            return true /*EXIT*/
        }
        
        // Wrap Expression in Parentheses - Simplifies Evaluation
        var wrappedComponents = components
        wrappedComponents.insert(Operator.ope, at: 0)
        wrappedComponents.append(Operator.clo)
        
        for (i, comp) in wrappedComponents.enumerated() {
            
            let isLastComp = i == wrappedComponents.lastUsableIndex
            
            if comp.isNum() {
                
                stack.push(comp)
                
            } else {
                
                let optor = comp as! Operator
                
                if !optor.isCloseParen() { stack.push(optor) } // push anything not close parens on stack
                else {
                    
                    if !evaluateSub() { return value /*EXIT*/ }
                    
                }
                
            }
            
        }
        
        value = stack.pop() as! Int
        if !value.isBetween(1, 10) { isValid = false }
        
        return value
        
    }

    // TODO: Clean Up - delete evaluateOLD sometime post 04/20/24
    /// Evaluates the `Expression` returning the value.
    /// - Important: `evaluate` does treats floating point results from
    /// sub-expression evaluation as errors resulting in the return value of -1279
    mutating fileprivate func evaluate1() -> Int {
        
        var stack = ComponentStack()
        
        // Wrap Expression in Parentheses - Simplifies Evaluation
        var wrappedComponents = components
        wrappedComponents.insert(Operator.ope, at: 0)
        wrappedComponents.append(Operator.clo)
        
        for comp in wrappedComponents {
            
            if comp.isNum() {
                
                stack.push(comp)
                
            } else {
                
                let optor = comp as! Operator
                
                if !optor.isCloseParen() { stack.push(optor) } // push anything not close parens on stack
                else {
                    
                    // Sub-Expression
                    var sub = SubExpression()
                    
                    while let next = stack.pop(),
                          !next.isOpenParen() {
                        
                        // Build Sub-Expression
                        if next.isNum() {   // Operand
                            
                            if sub.rhs.isNil { sub.rhs = next as? Int}
                            else { sub.lhs = next as? Int}
                            
                        } else {            // Operator
                            
                            sub.operator = next as? Operator
                            
                        }
                        
                        // Evaluate Sub-Expression
                        if sub.lhs.isNotNil {
                            
                            let subResult: Int
                            
                            do {
                                
                                subResult = try sub.evaluate()
                                
                            } catch {
                                
                                if Configs.Test.printTestMessage {
                                    
                                    print("Error occured: \(error.localizedDescription) in Expression: '\(self)'")
                                    
                                }
                                
                                isValid = false
                                
                                return value /*EXIT*/
                                
                            }
                            
                            stack.push(subResult)
                            
                            // Reset Sub-Expression
                            sub = SubExpression()
                            
                        }
                        
                    }
                    
                    stack.push(sub.rhs!)
                    
                }
                
            }
            
        }
        
        value = stack.pop() as! Int
        if !value.isBetween(1, 10) { isValid = false }
        
        return value
        
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
    
}

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
    
}

/// Expression-specific Stack data structure
fileprivate struct ComponentStack {
    
    private var items: [Component] = [] // Array to hold stack values
    
    func peek() -> Component? {
        return items.last // Peek at the top-most element
    }
    
    mutating func pop() -> Component? {
        printLocal("pop:\t\(peek()!)")
        return items.popLast() // Remove and return the top item
    }
    
    mutating func push(_ item: Component) {
        printLocal("push:\t\(item)")
        items.append(item) // Add a value to the top of the stack
    }
    
}

/// Data structure for managing the simplest atomic `Expression` comprised
/// entire of a left and right hand `Int` operands and an `Operator`
/// e.g. 1+2, 9/3, 10-5, 2 *10, etc.
fileprivate struct SubExpression {
    
    var rhs: Int?
    var lhs: Int?
    var `operator`: Operator?
    
    func evaluate() throws -> Int {
        
        let value = try `operator`!.operate(lhs!, rhs!)
        
        printLocal("SubExpression: \(lhs!) \(self.operator!) \(rhs!) = \(value)")
        
        return value
        
    }
    
}

// TODO: Clean Up - delete after fixing the multipilcation/division precedence bug
/// A utility method for printing purely test messages with ability to silence all attempts to print via
/// `Configs.Test.printTestMessage` flag in configs.
/// - Parameter toPrint: `String` to print
func printLocal(_ toPrint: String) {
    
    if Configs.Test.printTestMessage { print("PL: \(toPrint)") }
    
}

// TODO: Clean Up - move up into main scope out of extension
extension Expression {
    
    mutating func evaluate() -> Int {
        
        // Replace parentheticals with their evalated selves
        var parenCount = 0
        
        let exp = self.components
        var sansParens = [Component]()
        var subExp = [Component]()
        
        if exp.count == 3 {
            
            let lhs     = exp[0] as! Int
            let optor   = exp[1] as! Operator
            let rhs     = exp[2] as! Int
            
            let (success, subVal)   = tryEval(lhs: lhs,
                                              optor: optor,
                                              rhs: rhs)
            
            if !success { isValid   = false }
            return subVal /*EXIT*/
            
            
        }
        
        // 1. Replace Parentheticals with Their Values
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
                    
                    let subResult = sub.value
                    
                    sansParens.append(subResult)
                    
                    // Reset Sub-Expression
                    subExp = []
                    
                } else { subExp.append(component) }
                
            } else {
                
                // Append Component
                if parenCount > 0 { subExp.append(component)}
                else { sansParens.append(component) }
                
            }
            
        }
        
        if sansParens.count == 1 { return sansParens[0] as! Int /*EXIT*/ }
        
        // 2. Work Through currentExp doing mult/div first
        var sansMltDiv      = [Component]()
        var i               = 0
        
        while i <= sansParens.lastUsableIndex - 2 {
            
            let lhs         = sansParens[i]     as! Int
            let optor  = sansParens[i + 1] as! Operator
            let rhs         = sansParens[i + 2] as! Int
            
            if optor.precedence == .mltDiv {
                
                let (success, subVal)   = tryEval(lhs: lhs,
                                                  optor: optor,
                                                  rhs: rhs)
                
                if !success { isValid   = false; return value /*EXIT*/ }
                
                sansParens[i + 2]       = subVal
                
// TODO: Clean Up - delete
/*
                sansParens[i+2] = try! optor.operate(lhs, rhs)
                
                 do {
                     
                     sansParens[i+2] = try optor.operate(lhs, rhs)
                     
                 } catch {
                     
                     if Configs.Test.printTestMessage {
                         
                         print("Error occured: \(error.localizedDescription) in Expression: '\(self)'")
                         
                     }
                     
                     isValid = false
                     
                     return value /*EXIT*/
                     
                 }
                 */
                
                i += 2
                
            } else {
                
                sansMltDiv.append(lhs)
                sansMltDiv.append(optor)
                
                i += 2
                
            }
            
        }
        
        sansMltDiv.append(sansParens.last as! Int)
        
        if sansMltDiv.count == 1 { return sansMltDiv[0] as! Int /*EXIT*/ }
        
        // 3. Finish with remaining addition/subtraction
        var finalVal        = 0
        i                   = 0
        
        var lhs         = sansMltDiv[i] as! Int
        
        while i <= sansMltDiv.lastUsableIndex - 2 {
            
            let optor       = sansMltDiv[i + 1] as! Operator
            let rhs         = sansMltDiv[i + 2] as! Int
            
            var success     = true
            (success, finalVal) = tryEval(lhs: lhs, optor: optor, rhs: rhs)
            
            if !success {
                
                isValid = false
                return value /*EXIT*/
                
            }
            
            lhs         = finalVal
            
            i += 2
            
        }
        
        return finalVal /*EXIT*/
        
    }
    
    
    func tryEval(lhs: Int, optor: Operator, rhs: Int) -> (success: Bool, value: Int) {
        
        do {
            
            return (true, try optor.operate(lhs, rhs))
            
        } catch {
            
            if Configs.Test.printTestMessage {
                
                print("Error occured: \(error.localizedDescription) in Expression: '\(self)'")
                
            }
            
            return (false, value) /*EXIT*/
            
        }
        
    }
    
}
