//
//  ExpressionTests.swift
//  AltonTests
//
//  Created by Aaron Nance on 4/3/24.
//

import XCTest
@testable import Alton

final class ExpressionTests: XCTestCase { 
    
    func test(_ expression: String, _ expectedSolution: Int) {
        
        let exp             = Expression(expression)
        let actualSolution  = exp.answer ?? Configs.Expression.invalidAnswer
        
        XCTAssert(expectedSolution == actualSolution,
                  "'\(exp)' Expected: \(expectedSolution) - Actual: \(actualSolution)")
        
        print("\(exp) == \(expectedSolution)")
        
    }
    
    /// These Expressions have been returning expected answer.
    func testWorkingExpressions() {
        
        // Passing
        test("(((1 + 2)))", 3)
        test("1 + 2", 3)
        test("(1 + 2) + (3 / 3)", 4)
        test("(4+2) / (1+2)", 2)
        test("1 + (3 + 3) / 3", 3)
        test("1 + 1 + 1 + 24", 27)
        test("1 + (2 + 3) / 5", 2)
        test("1 + ((3 + 3) / 3)", 3)
        
        test("(4 + 4) / (3 + 1)", 2)
        test("((3 + 3) / 3) + 1", 3)
        test("(3 + 3 * 3)", 12)
        
    }
    
    /// These Expressions have been returning erroneous answers.
    /// - Note: this is likely caused by precedence bug
    func testBrokenExpressions() {
        
        // Broken
        test("(3 + 3 * 3 + 2)", 14) // Expected 14 - Actual 18
        test("(3 + 3) * 3 + 1", 19) // Expected 19 - Actual 24
        test("(3 + 3) / 3 + 1", 3)  // Expected 3 - Actual Expression.invalidAnswer
                                    // breaks because it operates in left to
                                    // right order except that parentheticals
                                    // are evaluated as they are encountered.
                                    // So here we calculate (3 + 3), then 3 + 1, then (3 + 3) / (3 + 1)
        
    }
    
    func testMultDivPrecedence() {
        
        test("2 * 2 * 3 * 4", 48)
        test("((2 * 5) / 2) * 3", 15)
        
        test("(2 * 4) + 3 / 3 + 1", 10)
        test("2 * 4 + 3 / 3", 9)
        test("50 / 2 / 5 / 5", 1)
        
        test("2 * 4 + 3 / 3", 9)
        test("(2+1) / 3", 1)
        
    }
    
    func testFractionalExpressions() {
        
        test("8_2 / 4_2", 2)
        test("1_4", Configs.Expression.invalidAnswer)
        test("1_4 * 4", 1)
        test("4_3 * 3", 4)
        test("15_3 / 5", 1)
        test("44 / 11",4)
        test("8 _ 2 * 2", 8)
        test("((2+2)*2)_2", 4)
        test("(5+5+5+5)_(10/5)",10)
        test("(10_3 / 5_3)", 2)
        test("(2_4) / (1_2)",1)
        test("(2 _  4)", Configs.Expression.invalidAnswer)
        test("3_3 + 7", 8)
        test("4_3 + 2", Configs.Expression.invalidAnswer)
        
        test("7/(3-8_5)", 5)
        test("7/(7_5)", 5)
    }
    
    func testExtraneousButCorrectParens() {
        
        test("((3) + (((3) * (3))) + 2)", 14)
        
    }
    
    func testComplexityGeneral() {
        
        print("---------------")
        utilTestComplexity("3-2-25",    "32-25", >)
        utilTestComplexity("32-25",     "3-25", >)
        utilTestComplexity("3/2-2-5",   "32/25", >)
        utilTestComplexity( "3/35",     "3/5", >)
        utilTestComplexity("32/35",     "3/35", >)
        
        utilTestComplexity("3/5",       "3+5", >)
        utilTestComplexity("3/35",      "3/5", >)
        
        utilTestComplexity("3/5",       "3+5", >)
        utilTestComplexity("3/5",       "3-5", >)
        utilTestComplexity("3/5",       "3*5", >)
        utilTestComplexity("3/5",       "3_5", <)
        
        utilTestComplexity("3*5",       "3+5", >)
        utilTestComplexity("3*5",       "3-5", >)
        utilTestComplexity("3*5",       "3/5", <)
        utilTestComplexity("3*5",       "3_5", <)
        
        utilTestComplexity("1+2+3+4",   "1-2-3-4", <)
        utilTestComplexity("1+2+3+4",   "1+2+3-4", <)
        
        utilTestComplexity("1-2-3-4",   "1-2-3*4", <)
        utilTestComplexity("1+2+3+4",   "1_4", <)
        utilTestComplexity("1_4",       "11_4", <)
        
        utilTestComplexity("(1+2)+3+4", "1+2+3+4", >)
        utilTestComplexity("(1*1)",     "2_5", <)
        print("---------------")
        
    }
    
    func testMaxComplexity() {
        
        var maxComplexity = 0
        var mostComplex: Alton.Expression?
        
        func checkMax(_ operands: [Int]) {
            
            let puzzle  = Solver(operands).puzzle
            let exps    = puzzle.solutions.keys.reduce([Alton.Expression]()){ $0 + (puzzle.solutions[$1] ?? [])}.sorted{ $0.complexity < $1.complexity }
            
            for exp in exps {
            
                if exp.complexity > maxComplexity {
                    
                    maxComplexity = exp.complexity
                    mostComplex = exp
                    
                }
                
                print("\(exp) :: \(exp.complexity) / \(Expression.maxComplexity)")
                
                XCTAssert(exp.complexity < Expression.maxComplexity,
                          "\(exp) complexity(\(exp.complexity)) exceeds Expression.maxComplexity(\(Expression.maxComplexity))")
                
            }
            
        }
        
        checkMax([1,2,3,4])
        checkMax([3,5,7,8]) // 10.04.22
        checkMax([1,3,6,6]) // 04.09.24
        checkMax([3,5,5,8]) // 04.10.24 - required fractions for 7
        checkMax([2,3,4,6]) // 04.11.24
        checkMax([2,3,4,5]) // 04.12.24
        checkMax([4,5,6,6]) // 04.22.24
        checkMax([2,5,6,7]) // 04.23.24
        checkMax([2,2,4,5]) // 04.24.24
        
        print("""
                
                Most Complex: '\(mostComplex!)' \
                -- Complexity: \(maxComplexity) / \(Expression.maxComplexity)
                
                """)
        
    }
    
}

extension ExpressionTests {
    
    func utilTestComplexity(_ lhs: String,
                        _ rhs: String,
                        _ test: (Int, Int) -> Bool) {
        
        let exp1 = Expression(lhs)
        let exp2 = Expression(rhs)
        
        let com1 = exp1.complexity
        let com2 = exp2.complexity
        
        XCTAssert(test(com1,com2),
                  """
                    
                    Expression\tComplexity
                    \(exp1.evaluatedDescription)\t\t\t\(com1)
                    \(exp2.evaluatedDescription)\t\t\t\(com2)
                    """)
        
        print("\(exp1.evaluatedDescription) complexity: \(com1)")
        print("\(exp2.evaluatedDescription) complexity: \(com2)")
        print("---\n")
        
    }
    
}
