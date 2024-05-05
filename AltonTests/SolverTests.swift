//
//  SolverTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 5/22/23.
//

import XCTest
import APNUtil
@testable import Alton

final class SolverTests: XCTestCase {
    
    private func echoAssert(_ originals: [Int]...,
                            useBruteForce: Bool = false) {
        
        for original in originals {
            
            let solver = Solver(original, 
                                useBruteForce: useBruteForce)
            let puzzle = solver.puzzle
            
            puzzle.echoResults()
            
            let loopCountText = "~Loop Count:\(solver.loopCount)~".centerPadded(toLength: 20)
            
            print("\(loopCountText)\n")
            
            XCTAssert(puzzle.isFullySolved,
                        """
                        \(puzzle.digits) \
                        missing solution(s) for: \
                        \(puzzle.unsolved)
                        """)
            
        }
        
    }
    
    /// Test for specific solutions
    func testSpecificAnswers() {
        
        let solver = Solver([1,1,1,1])
        
        let actualSolutions     = Set<Expression>(solver.puzzle.solutions[4]!)
        let expectedSolutions   = [Expression("1+1+1+1"), Expression("(1+1)*(1+1)")]
        
        for expected in expectedSolutions {
            
            XCTAssert(actualSolutions.contains(expected), 
                      "\n\(solver.puzzle.digits):\nExpected to find solution: \(expected)")
            
        }
        
    }
    
    func testGeneral() {
        
        echoAssert([1,2,3,4],
                   [1,2,7,9],
                   [2,2,4,4],
                   [3,3,6,7],
                   [3,3,3,3],
                   [2,3,5,8],
                   [4,4,4,4],
                   [7,7,7,7])
        
    }
    
    /// Checks for solutions to actual puzzles from All Ten
    func testHistoric() {
        
        echoAssert([3,5,7,8], // 10.04.22 - only 2 solutions for 5 - both require fractions
                   [1,3,6,6], // 04.09.24
                   [3,5,5,8], // 04.10.24 - only 1 solution for 7 - requires fraction
                   [2,3,4,6], // 04.11.24
                   [2,3,4,5], // 04.12.24
                   [4,5,6,6], // 04.22.24
                   [2,5,6,7], // 04.23.24
                   [2,2,4,5], // 04.24.24
                   [5,6,7,7], // 04.27.24
                   [3,3,3,8], // 04.29.24
                   [4,5,8,8], // 04.30.24
                   [3,3,3,6], //05.01.24
                   [2,5,7,9], //05.02.24
                   [2,7,8,9]) //05.03.24
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
    
    /// Tests speed of evaluating `Puzzle`s
    func testSpeedShort() {
        
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
        
        // ran in 8.983s 05/02/24 - W/ Brute Force Expression Creation
        // ran in 9.094s 05/02/24 - W/ Brute Force Expression Creation
        // ran in 2.492s 05/02/24 - WO/ Brute Force Expression Creation
        // ran in 2.482s 05/02/24 - WO/ Brute Force Expression Creation
        
        // ran in 2.425s 05/03/24 - WO/ Brute Force Expression Creation
        
        // ran in 2.647s 05/04/24 - WO/ Brute Force Expression Creation
        echoAssert([1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   [1,2,3,4],
                   useBruteForce: false)
        
    }
    
    /// Tests speed of evaluating `Puzzle`s
    func testSpeedLong() {
        
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
        // ran in 18.478s 04/29/24
        
        // ran in 20.682s 04/30/24
        
        // ran in 19.824s 05/02/24
        
        // ran in 74.023s 05/02/24        // W/ Brute Force
        // ran in 19.967s 05/02/24        // W/O Brute Force
        // ran in 19.788s 05/02/24        // W/O Brute Force
        
        // ran in 20.812s 05/02/24        // W/O Brute Force
        
        // ran in 20.263s 05/04/24        // W/O Brute Force (henceforth only test w/ brute force will be commented)
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
                   [1,2,3,4],
                   useBruteForce: false)
        
    }
    
    /// Test that Difficulty's are evaluated as expected by comparing against known values for a range of
    /// `Puzzle`s of estimated difficulies ranging from 1-10 and including unsolvable Puzzles.
    ///
    /// - note: The  test calls in this method can be re-generated using testAllPlusPlus() below.
    func testDifficulty() {
        
        var rows    = [[String]]()
        let headers = ["Puzzle",
                       "Diff",
                       "Total Solutions",
                       "Scarcity",
                       "Complexity",
                       "% Max"]
        
        /// - Note: data marked with asterices in final report are discrepant. The number
        /// of asterices on either side of the Puzzle value indicates the number of discrepant
        ///  columns for that puzzle.
        func test(_ digits:[Int],
                  _ expDifficulty: Int,
                  _ expTotalSolutionCount: Int,
                  _ expScarcity: Double,
                  _ expComplexity: Double,
                  _ expPercentMax: Double) {
            
            // Print
            print("Testing Difficulty: \(digits)")
            
            var row = ["\(digits[0])\(digits[1])\(digits[2])\(digits[3])"]
            
            func process(testType: String, expectedVal: CustomStringConvertible, actualVal: CustomStringConvertible) {
                
                XCTAssert(expectedVal.description    == actualVal.description,
                          "\(testType) :: Expected: \(expectedVal) - Actual: \(actualVal)")
                
                var (t1,t2,t3) = (" ","="," ")
                if expectedVal.description != actualVal.description {
                    
                    row[0] = "*\(row[0])*"
                    (t1,t2,t3) = ("*","*","*")
                    
                }
                
                row.append("\(t1)\(expectedVal)\(t2)\(actualVal)\(t3)")
                
            }
            
            let actDiff     = Solver(digits).puzzle.difficulty!
            
            // Estimated Difficulty
            process(testType: "EstimatedDifficulty",
                    expectedVal: expDifficulty,
                    actualVal: actDiff.estimated)
            
            // Solution Count
            process(testType:   "Total Solution Count",
                    expectedVal:    expTotalSolutionCount,
                    actualVal:      actDiff.totalSolutionCount)
            
            // Scarcity Component
            process(testType:       "Scarcity",
                    expectedVal:    expScarcity,
                    actualVal:      actDiff.scarcityComponent.roundTo(3))
            
            // Complexity Component
            process(testType:       "Complexity",
                    expectedVal:    expComplexity,
                    actualVal:      actDiff.complexityComponent.roundTo(3))
            
            // % Max
            process(testType:       "Percent of Max",
                    expectedVal:    expPercentMax,
                    actualVal:      actDiff.percentMax.roundTo(3))
         
            rows.append(row)
            
        }
        
        // This commented block is data with intentional errors used
        // for testing that the tests above are working.
        /*
         
         // Inalid Data - Should Fail
         test([1,1,2,3], 1, 1645, 0.127, 0.107, 0.115) // correct
         
         test([1,1,2,3], 999, 1645, 0.127, 0.107, 0.115)
         test([1,1,2,3], 1, 999, 0.127, 0.107, 0.115)
         test([1,1,2,3], 1, 1645, 0.999, 0.107, 0.115)
         test([1,1,2,3], 1, 1645, 0.127, 0.999, 0.115)
         test([1,1,2,3], 1, 1645, 0.127, 0.107, 0.999)
         
         test([1,1,2,3], 1, 999, 0.127, 0.107, 0.999)
         test([1,1,2,3], 999, 1645, 999, 0.107, 0.999)
         
         test([1,1,2,3], 999, 999, 0.999, 0.999, 0.999)
         */
        
        /**/
        // Valid Data - Should Pass
        test([1,1,1,1], 999, 195, 20.405, 0.073, 8.206)
        test([9,9,3,1], 999, 603, 5.515, 0.134, 2.286)
        test([9,9,7,6], 999, 164, 5.736, 0.166, 2.394)
        test([9,6,8,6], 999, 228, 5.672, 0.153, 2.361)
        test([9,9,1,4], 999, 544, 10.464, 0.151, 4.276)
        test([8,5,8,6], 999, 188, 10.612, 0.154, 4.337)
        test([9,4,1,4], 999, 638, 5.471, 0.107, 2.253)
        test([9,9,5,7], 999, 136, 5.764, 0.199, 2.425)
        test([9,9,5,5], 999, 235, 10.603, 0.154, 4.334)
        test([9,5,5,5], 999, 98, 5.802, 0.181, 2.43)
        test([7,7,7,7], 10, 73, 0.927, 0.283, 0.541)
        test([2,9,9,9], 9, 145, 0.855, 0.25, 0.492)
        test([4,4,4,4], 9, 118, 0.882, 0.243, 0.499)
        test([5,5,5,7], 9, 100, 0.9, 0.214, 0.488)
        test([5,5,7,5], 9, 100, 0.9, 0.214, 0.488)
        test([5,7,5,5], 9, 100, 0.9, 0.214, 0.488)
        test([7,5,5,5], 9, 100, 0.9, 0.214, 0.488)
        test([9,2,9,9], 9, 145, 0.855, 0.25, 0.492)
        test([9,9,2,9], 9, 145, 0.855, 0.25, 0.492)
        test([9,9,9,2], 9, 145, 0.855, 0.25, 0.492)
        test([2,2,2,9], 8, 125, 0.875, 0.189, 0.464)
        test([9,6,8,8], 8, 147, 0.853, 0.175, 0.446)
        test([8,8,9,6], 8, 147, 0.853, 0.175, 0.446)
        test([8,7,7,5], 8, 152, 0.848, 0.196, 0.457)
        test([8,6,7,8], 8, 190, 0.81, 0.191, 0.438)
        test([9,2,2,2], 8, 125, 0.875, 0.189, 0.464)
        test([3,3,3,8], 8, 143, 0.857, 0.178, 0.45)
        test([8,5,5,7], 8, 222, 0.778, 0.213, 0.439)
        test([8,6,8,7], 8, 190, 0.81, 0.191, 0.438)
        test([7,8,5,7], 8, 152, 0.848, 0.196, 0.457)
        test([1,1,6,7], 7, 521, 0.725, 0.177, 0.396)
        test([9,9,6,4], 7, 254, 0.746, 0.173, 0.402)
        test([8,8,4,7], 7, 198, 0.802, 0.154, 0.413)
        test([6,7,5,5], 7, 227, 0.773, 0.156, 0.403)
        test([8,7,8,4], 7, 198, 0.802, 0.154, 0.413)
        test([9,6,8,5], 7, 309, 0.736, 0.177, 0.401)
        test([9,6,5,5], 7, 186, 0.814, 0.161, 0.422)
        test([9,6,5,8], 7, 309, 0.736, 0.177, 0.401)
        test([9,3,3,3], 7, 300, 0.701, 0.193, 0.396)
        test([9,6,4,9], 7, 254, 0.746, 0.173, 0.402)
        test([1,1,1,9], 6, 497, 0.655, 0.184, 0.373)
        test([9,7,9,1], 6, 550, 0.655, 0.163, 0.36)
        test([9,5,9,2], 6, 358, 0.642, 0.177, 0.363)
        test([9,1,7,7], 6, 584, 0.621, 0.186, 0.36)
        test([8,7,7,4], 6, 259, 0.741, 0.157, 0.391)
        test([9,4,5,4], 6, 319, 0.715, 0.152, 0.377)
        test([9,7,3,5], 6, 429, 0.608, 0.179, 0.35)
        test([9,5,7,3], 6, 429, 0.608, 0.179, 0.35)
        test([9,7,7,2], 6, 321, 0.717, 0.169, 0.388)
        test([9,8,1,1], 6, 563, 0.697, 0.164, 0.377)
        test([1,1,1,4], 5, 629, 0.523, 0.16, 0.305)
        test([8,7,5,3], 5, 556, 0.474, 0.222, 0.323)
        test([9,7,5,1], 5, 454, 0.57, 0.143, 0.314)
        test([9,9,1,2], 5, 636, 0.577, 0.154, 0.323)
        test([8,6,4,6], 5, 469, 0.542, 0.178, 0.324)
        test([9,8,5,3], 5, 479, 0.545, 0.16, 0.314)
        test([8,6,8,1], 5, 645, 0.562, 0.175, 0.33)
        test([9,5,3,8], 5, 479, 0.545, 0.16, 0.314)
        test([9,4,6,8], 5, 394, 0.606, 0.154, 0.335)
        test([9,3,7,4], 5, 489, 0.535, 0.158, 0.309)
        test([1,1,3,8], 4, 616, 0.425, 0.163, 0.268)
        test([9,2,4,8], 4, 578, 0.512, 0.147, 0.293)
        test([9,7,6,3], 4, 527, 0.495, 0.156, 0.291)
        test([9,8,4,3], 4, 549, 0.498, 0.138, 0.282)
        test([9,7,3,2], 4, 527, 0.511, 0.136, 0.286)
        test([9,8,2,7], 4, 573, 0.453, 0.148, 0.27)
        test([9,2,3,7], 4, 527, 0.511, 0.136, 0.286)
        test([9,6,2,8], 4, 533, 0.491, 0.141, 0.281)
        test([9,2,8,6], 4, 533, 0.491, 0.141, 0.281)
        test([9,5,3,2], 4, 571, 0.463, 0.129, 0.263)
        test([1,1,2,2], 3, 988, 0.368, 0.134, 0.228)
        test([9,1,8,7], 3, 933, 0.345, 0.137, 0.22)
        test([8,6,7,1], 3, 924, 0.349, 0.134, 0.22)
        test([8,4,2,8], 3, 860, 0.378, 0.138, 0.234)
        test([9,6,1,2], 3, 787, 0.381, 0.126, 0.228)
        test([8,9,6,3], 3, 636, 0.408, 0.138, 0.246)
        test([8,4,2,7], 3, 669, 0.439, 0.13, 0.253)
        test([9,1,2,7], 3, 788, 0.441, 0.116, 0.246)
        test([8,3,5,2], 3, 729, 0.38, 0.125, 0.227)
        test([9,5,6,3], 3, 689, 0.335, 0.15, 0.224)
        test([1,1,2,7], 2, 1004, 0.216, 0.169, 0.188)
        test([7,1,4,2], 2, 958, 0.298, 0.12, 0.191)
        test([8,4,4,2], 2, 971, 0.25, 0.142, 0.185)
        test([9,4,2,3], 2, 726, 0.324, 0.12, 0.202)
        test([8,1,2,2], 2, 1024, 0.238, 0.119, 0.167)
        test([9,1,4,3], 2, 897, 0.269, 0.122, 0.181)
        test([9,3,2,4], 2, 726, 0.324, 0.12, 0.202)
        test([8,3,1,6], 2, 969, 0.279, 0.126, 0.187)
        test([8,6,1,4], 2, 1064, 0.245, 0.117, 0.168)
        test([8,4,2,5], 2, 779, 0.34, 0.119, 0.207)
        test([1,1,2,3], 1, 1645, 0.127, 0.107, 0.115)
        test([8,3,2,4], 1, 1032, 0.178, 0.116, 0.141)
        test([6,4,2,3], 1, 1410, 0.067, 0.116, 0.096)
        test([6,3,4,2], 1, 1410, 0.067, 0.116, 0.096)
        test([5,1,6,3], 1, 1142, 0.237, 0.112, 0.162)
        test([6,1,2,4], 1, 1673, 0.123, 0.106, 0.113)
        test([6,4,2,8], 1, 1425, 0.06, 0.151, 0.115)
        test([9,3,2,1], 1, 1214, 0.103, 0.119, 0.113)
        test([7,3,1,2], 1, 1049, 0.157, 0.105, 0.126)
        test([6,3,2,1], 1, 1907, 0.079, 0.102, 0.093)
         /**/
        
        print(Report.columnateAutoWidth(rows,
                                        headers: headers,
                                        title: "Difficulty Calculations",
                                        dataPadType: .center))
        
    }
    
    /// Runs all possible `Puzzle` digit combinations, checks that the expected
    /// number are solvable  and optionally generates text for export to .CSV
    /// and function calls to be used in `testDifficulty()`
    func testAllPlusPlus() {
        
        let shouldEchoForCSV            = true
        let shouldGenerateNormTestFuncs = true
        
        var puzzle = Puzzle([1,2,3,4])
        
        var normalizationData = [ 999 : [String]()]
        
        for i in 1...10 {
            
            normalizationData[i] = [String]()
            
        }
        
        func addNormTestFuncData(_ puzzle: Puzzle) {
            
            let difficulty = puzzle.difficulty!.estimated
            
            if normalizationData[difficulty]!.count < 10 {
                
                normalizationData[difficulty]!.append(puzzle.descriptionForTesting)
                
            } else if Int.random(min: 1, max: 100) <= 15 {
                
                // Occasionally use random data to avoid all low digit
                normalizationData[difficulty]![Int.random(min: 1, max: 9)] = puzzle.descriptionForTesting
                
            }
            
        }
        
        func pasteboardNormData() {
            
            var buffer = ""
            
            let keys = normalizationData.keys.sorted{$0 > $1}
            for key in keys {
                
                normalizationData[key]!.forEach{ buffer += $0.description }
                
            }
            
            print("--------------")
            print(buffer)
            printToClipboard(buffer)
            print("--------------")
            
        }
        
        // Use start point to run testAllPlusPlus from that puzzle on.
        // e.g. startPoine = [7,7,7,7] starts with puzzle 7777 and goes to 9999
        var startPoint: Int?        = nil
        var actualUnsolvableCount   = 0
        let expectedUnsolvableCount = 1006
        var testedCount             = 0
        
        if shouldEchoForCSV { print(Difficulty.header) }
        
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
                        
                        puzzle = Solver([i,j,k,l], useBruteForce: false).puzzle
                        
                        // Normalization Data Test Func Generate?
                        if shouldGenerateNormTestFuncs { addNormTestFuncData(puzzle) }
                        
                        testedCount += 1
                        
                        // Echo .CSV?
                        if shouldEchoForCSV { print("\(puzzle.descriptionVerbose)") }
                        else if testedCount % 100 == 0 { print(testedCount) }
                        
                        if !puzzle.isFullySolved {
                        
                            actualUnsolvableCount += 1
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        // Normalization Test Funcs -> Pasteboard
        if shouldGenerateNormTestFuncs { pasteboardNormData() }
        
        XCTAssert(actualUnsolvableCount == expectedUnsolvableCount,
                  "EXpected: \(expectedUnsolvableCount) - Actual: \(actualUnsolvableCount)")
        
        print("EXpected: \(expectedUnsolvableCount) - Actual: \(actualUnsolvableCount)")
        print("Finito!")
        
    }
    
    /// Tests all Puzzle combinations similar to testAllPlusPlus with the exception
    /// that it also further scrutinizes puzzles that  `testAllPlusPlus` would
    /// simply deem `unsolvable`. Puzzles deemed unsolvable using regular
    /// `Solver.solve(bruteForce:false)` are futher evaluated via
    /// `Solver.solve(bruteForce:true)`
    ///
    /// - important: the purpose of this method is to check that `Solver.solve(:)`
    /// is getting as many solutions as possible by comparing against the outcome using
    /// `Solver.buildExpressionsBruteForce()`
    ///
    /// - Note: to turn on/off use of brute force expression generation, pass the appropriate flag
    /// into the `Solver` initailizer.
    func testAllBruteForce() {
        
        var puzzle = Puzzle([1,2,3,4])
        
        var actualUnsolvableCount   = 0
        let expectedUnsolvableCount = 1005 // as of 05.02.24, 1 less than expected w/o brute force
        var testedCount             = 0
        
        print(Difficulty.header)
        
        var bruteForceSolved = ""
        
        for i in 1...9 {
        
            for j in 1...9 {
                
                for k in 1...9 {
                    
                    for l in 1...9 {
                        
                        testedCount += 1
                        
                        // Regulare Force
                        puzzle = Solver([i,j,k,l],
                                        useBruteForce: false).puzzle
                        
                        if testedCount % 50 == 0 {
                            
                            print(testedCount)
                            if bruteForceSolved.count > 0 { print(bruteForceSolved) }
                            
                        }
                        
                        if puzzle.isFullySolved {
                            
                            // Print
                            print("\(puzzle.descriptionVerbose)")
                            
                        } else { // Try the BRUTAL FORCE!!
                            
                            let brutePuzzle = Solver([i,j,k,l],
                                            useBruteForce: true).puzzle
                            
                            // Print
                            print("\(brutePuzzle.descriptionVerbose)")
                            
                            if !brutePuzzle.isFullySolved {
                                
                                actualUnsolvableCount += 1
                                
                            } else {
                                
                                bruteForceSolved += "\(brutePuzzle.digits) "
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        XCTAssert(actualUnsolvableCount == expectedUnsolvableCount,
                  "EXpected: \(expectedUnsolvableCount) - Actual: \(actualUnsolvableCount)")
        
        print("EXpected: \(expectedUnsolvableCount) - Actual: \(actualUnsolvableCount)")
        
        if !bruteForceSolved.isEmpty {
            
            print("Solved Via Brute Force:\n\(bruteForceSolved)\n")
            
        }
        
        print("Finito!")
        
    }
    
}
