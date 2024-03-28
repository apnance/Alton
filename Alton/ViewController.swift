//
//  ViewController.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let testOperands =  [
//                            [1,2,3,4],
//                            [2,2,4,4],
//                            [5,5,5,9],
//                            [6,7,7,7],
//                            [8,8,8,8],
                            [0,11,22,333],
                            [1,11,22,333],
                            [5,11,22,333]
                            ]
        
        
        assert(1.isBetween(1, 1))
        assert(1.isBetween(0, 1))
        assert(1.isBetween(10, 1))
        assert(1.isBetween(-1000, 15333))
        assert(1.isBetween(Int.min, Int.max))
        assert(1.isBetween(0, Int.max))

        assert(!1.isBetween(Int.min, 0))
        assert(!1.isBetween(Int.max, 2))
        assert(!1.isBetween(0, 0))
        assert(!1.isBetween(2, 2))
        
        for op in testOperands {
            
            let _ = Solver(op[0],op[1],op[2],op[3])
            
        }
        
//        let solver = Solver(2,2,4,4) // 30 operands
        
//        let solver = Solver(5,5,5,9) // 20 operands
//        let solver = Solver(6,7,7,7) // 20 operands
//        let solver = Solver(8,8,8,8) // 5 operands
//        let solver = Solver(0,11,22,333) // 108 operands
//        let solver = Solver(1,11,22,333) // 110 operands
//        let solver = Solver(5,11,22,333) // 120 operands

// TODO: Clean Up - uncomment below for testing
//        solver.solutions.forEach{ $0.value.forEach{ print("\($0)") } }        
        print("Finito!")
        
// TESTING SOLUTION
//        let solution1 = Solution(operands: [4,2,2,4], operators: [.add, .sub, .mlt])
//        print(solution1)
//        (4 + 2) - 2) * 4 = 8
//        (4 + 2) / 2) - 4 = 4
//        (4 + 2) * 2) - 4 = 4
        
        
        
        
    }
    
    // MARK: - Custom Methods
    
}
