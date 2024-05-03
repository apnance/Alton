//
//  ExpressionDeduper.swift
//  Alton
//
//  Created by Aaron Nance on 5/2/24.
//

import Foundation

/// Manages an array of `Expression`s,  preventing addition of duplicative entries.
///
/// The purpose of this data structure is performance optimization.
struct ExpressionDeduper {
    
    /// Array of non-duplicative `Expression`s
    private(set) var uniques     = [Int : [Expression]]()
    
    // Optimization mechanism to prevent duplicative initalization of the
    // same Expression which is relatively cpu intensive.
    private var existingExpressionHashes = Set<String>()
    
    init() {
        
        (1...10).forEach{ uniques[$0] = [Expression]() }
        
    }
    
    // Adds an `Expression` to `uniques` if it is not already found.
    mutating func addExpressionFrom(_ components: [Component]) {
        
        let currentExpressionHash = components.reduce(""){ $0 + $1.description }
        
        if !existingExpressionHashes.contains(currentExpressionHash) {
            
            let exp = Expression(components)
            existingExpressionHashes.insert(currentExpressionHash)
            
            if let solution = exp.answer {
                
                uniques[solution]?.append(exp)
                
            }
            
        }
        
    }
    
}
