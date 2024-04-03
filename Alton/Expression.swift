//
//  Expression.swift
//  Alton
//
//  Created by Aaron Nance on 3/28/24.
//

import Foundation
import APNUtil

// TODO: Clean Up - rename migrate ComponentStack to using APNUtil implementation of Stack that uses generics.
fileprivate struct ComponentStack {
    
    private var items: [Component] = [] // Array to hold stack values
    
    func peek() -> Component? {
        return items.last // Peek at the top-most element
    }
    
    mutating func pop() -> Component? {
        return items.popLast() // Remove and return the top item
    }
    
    mutating func push(_ item: Component) {
        items.append(item) // Add a value to the top of the stack
    }
    
}

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
    mutating fileprivate func evaluate() -> Int {
        
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
                    
                    // Sub-Expression Components
                    var lhs: Int?
                    var rhs: Int?
                    var optor: Operator?
                    
                    while let next = stack.pop(),
                          !next.isCloseParen() {
                        
                        // Build Sub-Expression
                        if next.isNum() {   // Operand
                            
                            if rhs.isNil { rhs = next as? Int}
                            else { lhs = next as? Int}
                            
                        } else {            // Operator
                            
                            optor = next as? Operator
                            
                        }
                        
                        // Evaluate Sub-Expression
                        if lhs.isNotNil {
                            
                            let result: Int
                            
                            do {
                                
                                result = try optor!.operate(lhs!, rhs!)
                                
                            } catch {
                                
                                if Configs.Test.printTestMessage {
                                    
                                    print("Error occured: \(error.localizedDescription) in Expression: '\(self)'")
                                    
                                }
                                
                                isValid = false
                                
                                return value /*EXIT*/
                                
                            }
                            
                            stack.push(result)
                            
                            // Reset Sub-Expression Components
                            lhs     = nil
                            rhs     = nil
                            optor   = nil
                            
                        }
                        
                    }
                    
                    stack.push(rhs!)
                    
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

