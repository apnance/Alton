//
//  GapFinder.swift
//  Alton
//
//  Created by Aaron Nance on 6/26/24.
//

import Foundation

// TODO: Clean Up - MOVE TO APNUtil
// TODO: Clean Up - add unit tests
struct GapFinder {
    
    /// Data structure describing missing numeric entries in presumed consecutive sequence of `Int`.
    ///
    /// e.g. when searched over the range 1..10, the sequence 1,2,3,5,10 would return 2 `Gap`s:  [4], and [6...9]
    struct Gap: CustomStringConvertible {
        
        var startIndex: Int
        var endIndex: Int
        var size: Int { endIndex - startIndex }
        
        var description: String {
            
            var output = ""
            
            func centerPad(_ subject: CustomStringConvertible) -> String {
                
                "\(subject.description.centerPadded(toLength: GapFinder.paddWidth))\n"
                
            }
            
            if size == 0  {
                
                output += centerPad(startIndex)
                
            } else {
                
                output += centerPad(startIndex)
                output += centerPad("⇣")
                output += centerPad(endIndex)
                
            }
            
            return output
            
        }
        
        var descriptionSimple: String {
            
            var output = ""
            
            func centerPad(_ subject: CustomStringConvertible) -> String {
                
                "[\(subject.description.centerPadded(toLength: GapFinder.paddWidth))]"
                
            }
            
            if size == 0  {
                
                output += centerPad(startIndex)
                
            } else {
                
                output += centerPad(startIndex)
                output += "← \(size) →".centerPadded(toLength: GapFinder.paddWidth + 4)
                output += centerPad(endIndex)
                
            }
            
            return output
            
        }
        
    }
    
    /// Finds and returns a list of all `Gap`s contained in sequence `in`
    /// - Parameters:
    ///   - toCheck: sequence of presumed consecutive `Int`s to be checked for
    ///   "gaps" in consecutivity.
    ///   - usingRange: the range of `Int` to consider when checking for consecuitivy.
    /// - Returns: An array of `Gap`s
    static func find(in toCheck: [Int],
                     usingRange: ClosedRange<Int>) -> [Gap] {
        
       lastUsedIndex    = 0
        
        var toCheck     = toCheck
        toCheck.append(usingRange.upperBound)
        
        var gaps        = [Gap]()
        
        for int in toCheck {
            
            if let gap = check(index: int) {
                
                gaps.append(gap)
                
            }
            
        }
        
        return gaps
        
    }
    
    private static var lastUsedIndex = 0
    
    fileprivate static var paddWidth: Int { lastUsedIndex.descriptionCharCount + 4 }
    
    private static func check(index: Int) -> Gap? {
        
        if index - lastUsedIndex > 1 {
            
            let gap = Gap(startIndex: lastUsedIndex + 1,
                          endIndex: index - 1)
            
            lastUsedIndex = index // Update
            
            return gap
            
        }
        
        lastUsedIndex = index // Update
        
        return nil
        
    }
    
    /// Creates a visual representation of missing elements in sequence.
    static func describeGaps(in toCheck: [Int],
                         usingRange range: ClosedRange<Int>) -> String {
        
        let gaps = find(in: toCheck,
                        usingRange: range)
        
        var output      = ""
        let paddWidth   = paddWidth - 2
        let line        = String(repeating:"─", count: paddWidth)
        let top         =   "┌\(line)┐\n"
        let bot         = "\n└\(line)┘\n"
        
        var lastNum = -1
        
        func centered(_ num: Int, isTop: Bool) -> String {
            
            var centered    = num.description.centerPadded(toLength: paddWidth)
            let arrow       = "⇣".centerPadded(toLength: paddWidth)
            
            if isTop {
                
                centered = "\(top)│\(centered)│"
                
            } else {
                
                if lastNum == num {
                    
                    centered = "\(bot)"
                    
                } else if num == range.lowerBound {
                    
                    centered = "\(top)│\(centered)│\(bot)"
                    
                } else {
                    
                    centered = "\n│\(arrow)│\n│\(centered)│\(bot)"
                    
                }
                
            }
            
            lastNum = num
            
            return centered
        }
        
        var needsBottom = false
        
        // Edge Case: first 2+ items are present
        if gaps.first!.startIndex > range.lowerBound + 1 {
        
            output   += centered(range.lowerBound, isTop: true)
            
        }
        
        for gap in gaps {
            
            let prev = gap.startIndex - 1
            let next = gap.endIndex + 1
            
            if prev >= range.lowerBound {
                
                output   += centered(prev, isTop: false)
                
                needsBottom = false
                
            }
            
            output += gap.description
            
            if next < range.upperBound {
                
                output += centered(next, isTop: true)
                
                needsBottom = true
                
            }
            
        }
        
        // Edge Case: last number
        let lastPuzzNum = range.upperBound - 1
        if gaps.last!.endIndex < lastPuzzNum {
        
            output   += centered(lastPuzzNum, isTop: false)
            needsBottom = false
            
        }
        
        output += needsBottom ? bot : ""
        
        return output
    }
    
    
    
    /// Creates a more horizontal `String` representation of all missing elements
    ///  compared to `describeGaps(in:)`
    static func compactDescribeGaps(in toCheck: [Int],
                             usingRange range: ClosedRange<Int>) -> String {
        
        var output = ""
        
        let gaps = find(in: toCheck,
                        usingRange: range)
        
        for gap in gaps {
            
            output += "\(gap.descriptionSimple)\n"
            
        }
        
        if !output.isEmpty {
            
            output = "Gaps:\n\(output)"
            
        }
        
        return output
        
    }
    
}
