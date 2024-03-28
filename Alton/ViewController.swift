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
        
//        testPermute()
        
//        let solver = Solver(1,2,3,4) // 120 operands
//        let solver = Solver(2,2,4,4) // 30 operands
//        let solver = Solver(5,5,5,9) // 20 operands
//        let solver = Solver(6,7,7,7) // 20 operands
//        let solver = Solver(8,8,8,8) // 5 operands
//        let solver = Solver(0,11,22,333) // 108 operands
//        let solver = Solver(1,11,22,333) // 110 operands
        let solver = Solver(5,11,22,333) // 120 operands
        
        solver.printOperands()
        
//        print(solver.operands)
        
    }
    
    // MARK: - Custom Methods
//    func testPermute() {
//        
//        func format<Permutable: Equatable & 
//                        CustomStringConvertible>(_ array: [[Permutable]]) -> String {
//            
//            array.map{$0.map{ $0.description }.joined(separator: " > ") }.joined(separator: "\n")
//            
//        }
//        
//        for toPerm in [[1,2,3,4],
//                       [2,2,4,4],
//                       [9,8,7],
//                       [11,22,33,44]] {
//            
////        for toPerm in [["A","B","C","A"],
////                       ["W","X","Y","Z"],
////                       ["Beatrix", "Leeatrix", "Aarotrix"]] {
//            
//            let duped   = toPerm.permuted()
//            let deDuped = toPerm.permuteDeduped()
//            
//            print("""
//                original: \(toPerm)
//                =======================
//                duped [\(duped.count)]:
//                -------
//                \(format(duped))
//                - - - -
//                deduped [\(deDuped.count)]:
//                =========
//                \(format(deDuped))
//                =======================
//                
//                """)
//        }
//        
//    }
    
}
