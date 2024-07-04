//
//  ArchivedPuzzle.swift
//  Alton
//
//  Created by Aaron Nance on 6/25/24.
//

import Foundation
import APNUtil

/// Simple data structure to capture pertinent Puzzle information suitable for archiving.
struct ArchivedPuzzle: Managable {
    
    let digits: [Int]
    let date: Date
    let difficulty: Int
    
    var puzzleNum: Int { PuzzleArchiver.calcPuzzleNum(forDate: date) }
    
    var managedID: ManagedID?
    
    static func == (lhs: ArchivedPuzzle, rhs: ArchivedPuzzle) -> Bool {
        
        lhs.digits.sorted() == rhs.digits.sorted()
        
    }
    
}

extension ArchivedPuzzle: CustomStringConvertible {
    
    var description: String {
        
        let delimitedDigits = (digits.sorted() as [CustomStringConvertible]).asDelimitedString("")
        
        return "\(delimitedDigits);\(difficulty);\(date.simple);\(puzzleNum)"
        
    }
    
}
