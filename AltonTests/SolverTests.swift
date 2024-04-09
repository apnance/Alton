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
                   [2,3,5,8])
        
    }
    
    func testNeedsParentheticalSubExpressions() {
        
        echoAssert(
            [4,4,4,4],   // Requires deferred/parenthetical processing of mult/division operations
            [2,4,4,8])   // Requires deferred/parenthetical processing of mult/division operations
        
    }
    
    func testNeedsFractionalOperands() {
        
        echoAssert([3,5,7,8])
        
    }
    
    func testSpeed1() {
        
        // ran in 1.624s 04/06/24
        echoAssert([1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4])
        
    }
    
    func testSpeed2() {
        
        // ran in 13.090s 04/06/24
        // ran in 17.094s 04/06/24
        // ran in 13.749s 04/06/24
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
