//
//  Solver.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import Foundation
import APNUtil

//enum Operator: CustomStringConvertible {
//
//    case a, s, m, d
//
//    var description: String {
//        switch self {
//
//            case .a: return "+"
//            case .s: return "-"
//            case .m: return "x"
//            case .d: return "/"
//
//        }
//
//    }
//
//}
//
//
//struct SolverGroup { }
//
//struct Expression: Hashable {
//
//    var l: Int
//    var r: Int
//    var o: Operator
//
//}

//extension Array where Element: Equatable {
//extension Array where Element: Equatable {
//
//    /// Takes an `Array` of `Equatable` and returns an `Array` of all
//    /// possible arrangements of those `Equatable`s *including duplicates*.
//    /// - Parameter nums: `Array` of `Equatable`
//    /// - Returns: `Array` of `Equatable`
//    /// - Note: this function returns duplicative results.  For deduped results call `permuteDe()` instead.
//    ///
//    /// - Important: see Complexity
//    /// - Complexity: O(*n*^2), where *n* is the length of the array.
//    func permute() -> [[Element]] {
//
//        if count == 1 { return [self] /*EXIT*/ }
//
//        var permuted        = [[Element]]()
//
//        for i in 0..<count {
//
//            var elements    = self
//            let first       = elements.remove(at: i)
//            let perms       = elements.permute()
//
//            for perm in perms {
//
//                permuted.append([first] + perm)
//
//            }
//
//        }
//
//        return permuted
//
//    }
//
//    /// Takes an `Array` of `Equatable` and returns a *deduped* `Array`
//    /// of all possible arrangements of those `Equatable`s
//    /// - Parameter nums: `Array` of `Equatable`
//    /// - Returns: Deduped `Array` of `Equatable`
//    ///
//    /// - Important: see Complexity
//    /// - Complexity: O(*n*^2), where *n* is the length of the array.
//    func permuteDe() -> [[Element]] {
//
//        if count == dedupe().count { return permute() }
//        else { return permute().dedupe() }
//
//    }
//
//}

struct Solver{
    
    var operands = [[Int]]()
    
    init(_ operand1: Int,
         _ operand2: Int,
         _ operand3: Int,
         _ operand4: Int) {
        
        let originals = [operand1, operand2, operand3, operand4]
        
        // 1. all single digit combinations
        operands += (originals.permuteDeduped())
        
        // 2.a 2 element arrays of all possible combinations of 2-digit concatenations
        // 2.b 3 element arrays all possible 2-digit + 2 single digit combinations
        //      - e.g. [22, 3, 4], [23, 2, 4], [24, 2, 3]
        // - NOTE: should compute 2.a and 2.b in same pass
        // 1. compute 2.a as 1. the concatenation of the first and second operands, and the third and fourth operands
        //  - SORT THE RESULTING SUB-ARRAYS
        //
        // 2. compute 2.b as the concatenation of all first and second operands combined with the third and fourth elements
        //  - SORT THE RESULTING SUB-ARRAYS
        //  - results of 2. should be appended to the results of 1. then the final array should be deduped
        //
        // 3. depute results
        
        var doubleDigits = [[Int]]()
        
        for operand in operands {
            
            let d1 = operand[0]
            let d2 = operand[1]
            let d3 = operand[2]
            let d4 = operand[3]
            
            let dd1 = d1.concatonated(d2)!
            let dd2 = d2.concatonated(d3)!
            let dd3 = d3.concatonated(d4)!
            
            doubleDigits.append([dd1,   d3,    d4])
            doubleDigits.append([d1,    dd2,   d4])
            doubleDigits.append([d1,    d2,    dd3])
            //            doubleDigits.append([dd1,   dd2])
            doubleDigits.append([dd1,   dd3])
            //            doubleDigits.append([dd2,   dd3])
            
            //            doubleDigits.append([dd1,   dd2])
            //            doubleDigits.append([dd1,   dd3])
            //            doubleDigits.append([dd2,   dd3])
            
        }
        
        doubleDigits = doubleDigits.dedupe()
        
        operands.append(contentsOf: doubleDigits)
        
        // 4. all fractional combinations
        
    }
    
}

// - MARK: Dev Crap
extension Solver {
    
    // TODO: Clean Up - delete this test function eventually
    func printOperands() {
        
        func format<Permutable: Equatable &
                        CustomStringConvertible>(_ array: [[Permutable]]) -> String {
            
            array.map{$0.map{ $0.description }.joined(separator: " > ") }.joined(separator: "\n")
            
        }
        
        Swift.print("""
        =======================
        Results [\(operands.count)]:
        -------
        \(format(operands))
        =======================
        
        """)
    }
    
}
