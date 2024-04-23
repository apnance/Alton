//
//  SolverTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 5/22/23.
//

import XCTest
@testable import Alton

final class SolverTests: XCTestCase {
    
    private func echoAssert(_ originals: [Int]...) {
        
        for original in originals {
            
            let solver = Solver(original)
            
            solver.echoResults()
            
            XCTAssert(solver.fullySolved,
                        """
                        \(solver.originalOperands) \
                        missing solution(s) for: \
                        \(solver.missingSolution)
                        """)
            
        }
        
    }
    
    func testGeneral() {
        
        echoAssert([1,2,3,4],
                   [2,2,4,4],
                   [3,3,6,7],
                   [2,3,5,8],
                   [4,4,4,4],
                   [1,3,6,6],   // 04.09.24
                   [3,5,5,8],   // 04.10.24
                   [4,5,6,6])   // 04.22.24
        
    }
    
    /// Checks for solutions to actual puzzles from All Ten
    func testHistoric() {
        
        echoAssert([3,5,7,8],   // 10.04.22 - only 2 solutions for 7 both require fractions
                   [1,3,6,6],   // 04.09.24
                   [3,5,5,8],   // 04.10.24 - required fractions for 7
                   [2,3,4,6],   // 04.11.24
                   [2,3,4,5])   // 04.12.24
    }
    
    func testNeedsParentheticalSubExpressions() {
        
        echoAssert(
            [4,4,4,4],   // Requires deferred/parenthetical processing of mult/division operations
            [2,4,4,8])   // Requires deferred/parenthetical processing of mult/division operations
        
    }
    
    func testNeedsFractionalOperands() {
        
        echoAssert([3,5,7,8]) // Can't solve 5
        echoAssert([3,5,5,8]) // Can't solve 7
        
    }
    
    func testSpeed1() {
        
        // ran in 1.624s 04/06/24
        // ran in 2.261s 04/09/24
        // ran in 2.238s 04/09/24
        // ran in 6.621s 04/10/24
        // ran in 6.689s 04/10/24
        // ran in 6.689s 04/10/24
        // ran in 8.054s 04/13/24
        // ran in 7.072s 04/13/24
        // ran in 7.044s 04/13/24
        // ran in 6.775s 04/22/24 - BEFORE optimization
        // ran in 6.871s 04/22/24 - BEFORE optimization
        // ran in 5.300s 04/22/24 - AFTER optimization
        // ran in 5.271s 04/22/24 - AFTER optimization
        echoAssert([1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4])
        
    }
    
    func testSpeed2() {
        
        // ran in 13.090s 04/06/24
        // ran in 17.094s 04/06/24
        // ran in 13.749s 04/06/24
        // ran in 22.828s 04/09/24
        // ran in 20.974s 04/09/24
        // ran in 52.136s 04/10/24
        // ran in 56.788s 04/13/24
        // ran in 57.976s 04/22/24 - BEFORE optimizations
        // ran in 56.728s 04/22/24 - BEFORE optimizations
        // ran in 45.934s 04/22/24 - AFTER optimizations
        // ran in 43.776s 04/22/24 - AFTER optimizations
        echoAssert([1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4])
        
    }
    
}
