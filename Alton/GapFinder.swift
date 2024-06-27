//
//  GapFinder.swift
//  Alton
//
//  Created by Aaron Nance on 6/26/24.
//

import Foundation

struct GapFinder {
    
    struct Gap: CustomStringConvertible {
        
        var startIndex: Int
        var endIndex: Int
        var description: String {
            
            func centered(_ num: Int) -> String {
                
                var centered = String(num).centerPadded(toLength: 5)
                centered = "[\(centered)]"
                
                return centered
            }
            
            
            if startIndex == endIndex
            {
                return centered(startIndex) /*EXIT*/
                
            } else if endIndex - startIndex == 1 {
                
                return "\(centered(startIndex))\n\(centered(endIndex))" /*EXIT*/
                
            } else {
                
                return """
                        \(centered(startIndex))
                          ...
                        \(centered(endIndex))
                        """ /*EXIT*/
                
            }
            
        }
        
        static var lastUsedIndex = 0
        
        static func check(index: Int) -> Gap? {
            
            if index - lastUsedIndex > 1 {
                
                let gap = Gap(startIndex: lastUsedIndex + 1, endIndex: index - 1)
                
                lastUsedIndex = index
                
                return gap
                
            }
            
            lastUsedIndex = index
            
            return nil
            
        }
        
    }
    
    static func findGaps(in toCheck: [Int],
                         usingRange: ClosedRange<Int>) -> [Gap] {
        
        Gap.lastUsedIndex   = 0
        
        var toCheck = toCheck
        toCheck.append(usingRange.upperBound)
        
        var gaps        = [Gap]()
        
        for int in toCheck {
            
            if let gap = Gap.check(index: int) {
                
                gaps.append(gap)
                
            }
            
        }
        
//        for gap in gaps {
//            
//            print(gap)
//            
//        }
        
        return gaps
        
    }
}
