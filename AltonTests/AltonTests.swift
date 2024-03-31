//
//  AltonTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 5/22/23.
//

import XCTest
@testable import Alton

final class AltonTests: XCTestCase {
    
    func testSolver1() {
        
        
        let testOperands =  [
            
            [3,5,7,8],  // Probably requires fractional solution
            [4,4,4,4],  // Requires deferred/parenthetical processing of mult/division operations
            [1,2,3,4],
            [2,2,4,4],
            [3,3,6,7]
        ]
        
        for op in testOperands {
            
            let solver = Solver(op[0],op[1],op[2],op[3])
            
            solver.echoResults(op)
            
            XCTAssert(solver.fullySolved, "\(op) missing solution(s) for: \(solver.missingSolution)")
            
        }
        
    }
    
}
