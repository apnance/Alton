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
    fileprivate (set) var value         = Configs.Expression.invalidValue
    fileprivate var result: any Operand = Configs.Expression.invalidValue
    var isValid                         = true
    
    /// Simple means for comparing the relative complexity of generated `Expressions`.
    /// The higher the number the greater the relative complexity.
    var complexity: Int {
        
        components.reduce(0){ $0 + $1.complexity }
        
    }
    
    
    init(_ components: [Component]) {
        
        self.init(components, validate: true)
        
    }
    
    /// Initializes an `Expression` from the input.
    /// - Parameters:
    ///   - components: `Component`s to define the `Expression`
    ///   - validate: Flag used to shunt validation.  Used to prevent atomic `Fraction` sub-`Expression` from being treated as invalid.
    ///  - Important: do not call, call init(components)
    fileprivate init(_ components: [Component],
                     validate: Bool) {
        
        self.components = components
        
        result = eval(components) ?? result
        
        if !validate { return /*EXIT*/ }
        
        if let value = (try? result.asInteger) {
            
            self.value = value
            isValid = true
            
        } else {
            
            isValid = false
            
        }
        
    }
    
    /// Parses a string containing an expression and returns the corresponding expression.
    init(_ string: String) {
        
        self.init(Expression.parse(string))
        
    }
    
    // TODO: Clean Up - Optimize?
    /// Processes self as a mathematical Expression from left to right, observing rules of precedence.
    func eval(_ exp: [Component]) -> (any Operand)? {
        
        var exp     = exp
        
        var (success, value) = evalSimple(exp)
        
        if success { return value /*EXIT*/ }
        
        (success, exp)  = evalParens(exp)
        if !success { return nil /*EXIT*/ }
        else if exp.count == 1 { return exp[0] as? any Operand /*EXIT*/ }
        
        (success, exp) = evalFracts(exp)
        if !success { return nil /*EXIT*/ }
        else if exp.count == 1 {
        
            return exp[0] as? any Operand /*EXIT*/
            
        }
        
        (success, exp) = evalMltDiv(exp)
        if !success { return nil /*EXIT*/ }
        else  if exp.count == 1 { return exp[0] as? any Operand /*EXIT*/ }
        
        return evalAddSub(exp) /*EXIT*/
        
    }
    
    /// Evaluates parentheticals in `exp`, replacing them with their evaluated components
    func evalParens(_ exp: [Component]) -> (success: Bool, exp: [Component]) {
        
        // Replace parentheticals with their evaluated selves
        var parenCount  = 0
        
        var sansParens  = [Component]()
        var subExp      = [Component]()
        
        for component in exp {
            
            if component.isOpenParen() {
                
                if parenCount > 0 { subExp.append(component) } // don't append first paren
                
                // Increment Parentheses Count
                parenCount += 1
                
            } else if component.isCloseParen() {
                
                // Decriment Parentheses Count
                parenCount -= 1
                
                if parenCount == 0 { // don't append terminal paren
                    
                    let sub = Expression(subExp, validate: false)
                    
                    if !sub.isValid { return (false, []) /*EXIT*/ }
                    
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
        
        return (true, sansParens) /*EXIT*/
        
    }
    
    /// Evaluates `Fraction`s in `exp`, replacing them with their evaluated components
    func evalFracts(_ exp: [Component]) -> (success: Bool, exp: [Component]) {
         
        var exp = exp
        var sansFractions   = [Component]()
        
        var i               = 0
        
        while i <= exp.lastUsableIndex - 2 {
            
            let lhs         = exp[i]     as! any Operand
            let optor       = exp[i + 1] as! Operator
            let rhs         = exp[i + 2] as! any Operand
            
            if optor.precedence == .fraction {
                
                let (success, subVal)   = tryEval(lhs: lhs,
                                                  optor: optor,
                                                  rhs: rhs)
                
                if !success { return (false, []) /*EXIT*/ }
                
                exp[i + 2]       = subVal
                
                i += 2
                
            } else {
                
                sansFractions.append(lhs)
                sansFractions.append(optor)
                
                i += 2
                
            }
            
        }
        
        sansFractions.append(exp.last as! any Operand)
         
        return (true, sansFractions)
        
     }
    
     func evalMltDiv(_ exp: [Component]) -> (success: Bool, exp: [Component]) {
         
         var exp            = exp
         var sansMltDiv     = [Component]()
         var i              = 0
         
         while i <= exp.lastUsableIndex - 2 {
             
             let lhs        = exp[i]      as! any Operand
             let optor      = exp[i + 1]  as! Operator
             let rhs        = exp[i + 2]  as! any Operand
             
             if optor.precedence == .multiplicationDivision {
                 
                 let (success, subVal)   = tryEval(lhs: lhs,
                                                   optor: optor,
                                                   rhs: rhs)
                 
                 if !success { return (false, []) /*EXIT*/ }
                 
                 exp[i + 2]       = subVal
                 
                 i += 2
                 
             } else {
                 
                 sansMltDiv.append(lhs)
                 sansMltDiv.append(optor)
                 
                 i += 2
                 
             }
             
         }
         
         sansMltDiv.append(exp.last as! any Operand)
         
         return (true, sansMltDiv)
         
     }
    
    func evalAddSub(_ exp: [Component]) -> (any Operand)? {
        
        var finalVal: any Operand   = 0
        var i                       = 0
        
        var lhs                     = exp[i] as! any Operand
        
        while i <= exp.lastUsableIndex - 2 {
            
            let optor       = exp[i + 1] as! Operator
            let rhs         = exp[i + 2] as! any Operand
            
            var valid       = true
            
            (valid, finalVal) = tryEval(lhs: lhs, optor: optor, rhs: rhs)
            
            if !valid { return nil /*EXIT*/ }
            
            lhs         = finalVal
            
            i += 2
            
        }
        
        return finalVal /*EXIT*/
        
    }
    
    /// Evaluates a simple expression of 3 components, resulting in a single `Operand`
    /// - Parameter exp: An array of `[Component]` containing the `Component`s of
    /// the simplest complete expression. (i.e. [LHS, Operator, RHS])
    /// - Returns: Tuple conaining a success flag and the `Operand` resulting
    /// from  the `Operator` operating on the LHS and RHS `Operands`
    ///
    /// - Important: no validaion is performed on the order and sub-types of the
    /// `[Component]` argument.  It is expected that the first component will be
    /// the LHS `Operand`, the second will be the `Operator` and the third
    /// the RHS `Operand`.
    func evalSimple(_ exp: [Component]) -> (success: Bool, (any Operand)?) {
        
        guard exp.count == 3
        else { return (false, nil) /*EXIT*/ }
        
        let lhs     = exp[0] as! any Operand
        let optor   = exp[1] as! Operator
        let rhs     = exp[2] as! any Operand
        
        return tryEval(lhs: lhs,
                       optor: optor,
                       rhs: rhs)
        
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
    
    /// Parses a string containing an `Expression` before  returning an array of all `Component`s
    /// - Note: rudimentary validation of parenthetical order and balance is
    /// performed however no validation of operator/operand order/balance is done.
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


// - MARK: Protocol Adoption Extensions
extension Expression: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        return lhs.description == rhs.description
        
    }
    
}


extension Expression: CustomStringConvertible {
    
    var description: String {
        
        "\(components.reduce(""){ $0 + $1.description})"
        
    }
    
    var evaluatedDescription: String {
        
        "\(components.reduce(""){ $0 + $1.description}) = \(value)"
        
    }
    
    var evaluatedWithComplexityDescription: String {
        
        "\(components.reduce(""){ $0 + $1.description}) = \(value) :: complexity: \(self.complexity)"
        
    }
    
}
