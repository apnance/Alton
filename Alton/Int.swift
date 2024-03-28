//
//  Int.swift
//  Alton
//
//  Created by Aaron Nance on 3/28/24.
//

import Foundation

extension Int {
    
    func isBetween(_ first: Int, _ second: Int) -> Bool {
        
        if second < first { return isBetween(second, first) }
        
// TODO: Clean Up - delete
//        if first < second { return first <= self && self <= second }
//        else { return second <= self && self <= first }
        
        return first <= self && self <= second
        
    }
    
}
