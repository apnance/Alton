//
//  Blink.swift
//  Alton
//
//  Created by Aaron Nance on 4/16/24.
//

import UIKit

// - MARK: Blink Code

/// Manages Alton's blink animation
struct Blink {
    
    private static var alton: Blink!
    private var frames = [NSAttributedString]()
    private weak var target: UILabel!
    
    static func go(_ target: UILabel) {
        
        alton = Blink(target: target)
        alton.blink(delay: 5)
        
    }
    
    private init(target: UILabel) {
        
        self.target = target
        
        let swaps = [["@","@"],
                     ["-", "-"],
                     ["o","A"]]
        
//        let swaps = [["A","o"],
//                     ["-", "-"]]
        
        for swap in swaps {
            
            var frame               = AttributedString("\(swap.first!)lt\(swap.last!)n")
            frame.foregroundColor   = UIColor.systemYellow
            frame.font              = UIFont(name: "MenloBoldItalic",
                                             size: 30)
            
            for char in swap {
                
                var range = frame.range(of: char)
                frame[range!].foregroundColor = UIColor.white
                
                range = frame.range(of: char, options: [.backwards])
                frame[range!].foregroundColor = UIColor.white
                
            }
            
            frames.append(NSAttributedString(frame))
            
        }
        
    }
    
    private func blink(delay: Double, frame: Int = 1) {
        
        var nextFrame = -1
        var nextDelay = -1.0
        
        if delay < 0.2 {    // -lt-n
            
            let isDoubleBlink = delay < 0.085
            nextFrame = 1
            
            nextDelay = isDoubleBlink
            ? Double.random(min: 0.2, max: 0.25)
            : Double.random(min: 3, max: 12)
            
        } else {            // Alton
            
            nextFrame = 0
            nextDelay = Double.random(min: 0.08, max: 0.14)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            // Animate
            target.attributedText = self.frames[frame]
            
            // Next Call
            self.blink(delay: nextDelay,
                       frame: nextFrame)
            
        }
        
    }
    
}
