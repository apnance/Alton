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
                        \(solver.unsolved)
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
                   [3,5,5,8])   // 04.10.24
        
    }
    
    /// Checks for solutions to actual puzzles from All Ten
    func testHistoric() {
        
        echoAssert([3,5,7,8],   // 10.04.22 - only 2 solutions for 7 both require fractions
                   [1,3,6,6],   // 04.09.24
                   [3,5,5,8],   // 04.10.24 - required fractions for 7
                   [2,3,4,6],   // 04.11.24
                   [2,3,4,5],   // 04.12.24
                   [4,5,6,6],   // 04.22.24
                   [2,5,6,7],   // 04.23.24
                   [2,2,4,5],   // 04.24.24
                   [5,6,7,7])   // 04.27.24
        
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
        // ran in 5.289s 04/22/24 - AFTER optimization
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
        
        // ran in 18.817s 04/26/24 - AFTER Solver.buildExpressions() optimizations
        // ran in 19.053s 04/26/24 - AFTER Solver.buildExpressions() optimizations
        // ran in 18.499s 04/26/24 - AFTER Solver.buildExpressions() optimizations
        
        // ran in 21.613s 04/28/24
        // ran in 21.349s 04/28/24
        // ran in 21.198s 04/28/24
        // ran in 21.339s 04/28/24
        
        // ran in 19.202s 04/29/24
        // ran in 19.572s 04/29/24
        // ran in 18.777s 04/29/24
        // ran in 18.318s 04/29/24
        // ran in 18.478 s 04/29/24
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
    
    
    func testSolutionDifficulty() {
        
        var output = ""
        
        func checkMax(_ operands: [Int]) {
            
            let solver  = Solver(operands)
            
            output += "\(operands) Difficulty: \(solver.estimatePuzzleDifficulty()) / \(Configs.Puzzle.Difficulty.maxTheoretical)\n"
            
        }
        
        checkMax([1,2,3,4])
        checkMax([1,3,6,6]) //04.09.24
        checkMax([2,3,4,6]) // 04.11.24
        checkMax([2,3,4,5]) // 04.12.24
        checkMax([4,5,6,6]) // 04.22.24
        checkMax([2,5,6,7]) // 04.23.24
        checkMax([2,2,4,5]) // 04.24.24
        
        checkMax([4,4,4,4])
        checkMax([3,3,3,3])
        checkMax([3,5,7,8]) // 10.04.22
        checkMax([3,5,5,8]) // 04.10.24 - required fractions for 7
        checkMax([1,1,1,1]) // not fully solved
        
        print("""
                ---------
                \(output)
                ---------
                """)
        
    }
    
    func testDifficultyNormalization() {
        
        var printHeader = true
        func test(_ digits: [Int], 
                  _ expectedNormalized: Int,
                  _ expectedRaw: Int) {
            
            if printHeader {
                printHeader = false
                print("\nDigits\tNormalized\tRaw Diff")
                print("----------------------------")
            }
            let solver = Solver(digits)
            let stringDigits = digits.reduce(""){ "\($0)\($1)"}
            // let stringDigits = digits.description
            
            let actualNormalized = solver.estimatePuzzleDifficulty()
            XCTAssert(actualNormalized == expectedNormalized,
                      "\(digits) Expected: \(expectedNormalized) - Actual: \(actualNormalized)")
            
            print("\(stringDigits)\t\(solver.estimatePuzzleDifficulty())\t\t\t\(expectedRaw)")
            
        }
        
        let unsolvableDiff = Int(Configs.Expression.Difficulty.unsolvable)
        
        test([9,9,9,9], unsolvableDiff, unsolvableDiff)
        test([7,7,7,7], 10, 54)
        test([4,4,4,4], 9, 50)
        test([9,9,9,2], 9, 49)
        test([7,5,5,5], 9, 48)
        test([8,7,7,5], 8, 46)
        test([6,6,4,6], 8, 45)
        test([7,5,5,7], 8, 44)
        test([4,6,4,9], 8, 43)
        test([5,9,7,8], 7, 42)
        test([9,8,5,6], 7, 41)
        test([7,7,3,5], 7, 40)
        test([8,4,4,4], 7, 39)
        test([7,9,5,6], 6, 38)
        test([8,5,8,4], 6, 37)
        test([7,6,5,4], 6, 36)
        test([3,7,5,8], 6, 35)
        test([8,6,1,8], 5, 34)
        test([5,7,1,9], 5, 33)
        test([8,4,8,6], 5, 32)
        test([7,2,7,1], 5, 31)
        test([8,6,4,4], 5, 30)
        test([9,2,3,8], 4, 29)
        test([7,8,5,2], 4, 28)
        test([9,3,5,2], 4, 27)
        test([8,3,9,6], 4, 26)
        test([8,1,7,2], 3, 25)
        test([7,4,6,1], 3, 24)
        test([5,4,1,7], 3, 23)
        test([7,5,6,2], 3, 22)
        test([6,4,2,4], 3, 21)
        test([9,4,3,6], 2, 20)
        test([2,2,1,5], 2, 19)
        test([4,8,2,4], 2, 18)
        test([3,4,2,2], 2, 17)
        test([6,1,3,9], 2, 16)
        test([4,1,3,6], 1, 15)
        test([4,1,2,4], 1, 14)
        test([2,5,3,1], 1, 13)
        test([6,1,2,1], 1, 12)
        test([8,2,4,1], 1, 11)
        test([6,4,3,2], 1, 10)
        test([4,1,2,1], 1, 9)
        test([4,1,2,3], 1, 8)
        
    }
    
    
    func testAllPuzzles() {
        
        var solver = Solver([1,2,3,4])
        
        // Use start point to run testAllPuzzles from that puzzle on.
        // e.g. startPoine = [7,7,7,7] starts with puzzle 7777 and goes to 9999
        var startPoint: Int?    = nil
        var unsolvableCount     = 0
        var testedCount         = 0
        var printCSVHeader      = true
        
        for i in 1...9 {
        
            for j in 1...9 {
                
                for k in 1...9 {
                    
                    for l in 1...9 {
                        
                        if startPoint.isNotNil {
                            
                            let num = i.concatonated(j)!.concatonated(k)!.concatonated(l)!
                            
                            print(num)
                            
                            if num == startPoint {
                                
                                startPoint = nil
                                
                            } else { continue /*SKIP*/ }
                            
                        }
                        
                        solver = Solver([i,j,k,l],
                                        shouldPrintDiffInfo: true,
                                        shouldPrintDiffHeader: printCSVHeader)
                        
                        printCSVHeader = false
                        
                        testedCount += 1
                        // if testedCount % 100 == 0 { print("Tested Count: \(testedCount)")}
                        
                        if !solver.fullySolved {
                        
                            unsolvableCount += 1
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        XCTAssert(unsolvableCount == 1126, "EXpected: 1126 - Actual: \(unsolvableCount)")
        
        print("EXpected: 1126 - Actual: \(unsolvableCount)")
        print("Finito!")
        
    }
    
}
