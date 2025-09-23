//
//  KeyboardResizeHandler.swift
//  Alton
//
//  Original Source: D8TA
//  Created by Aaron Nance on 6/16/25.
//

import UIKit
import ConsoleView

class KeyboardResizeHandler: CVAConsoleViewResizeHandler {
    
    weak private var consoleView: ConsoleView?
    weak private var cachedConstraint: NSLayoutConstraint?
    private var cachedHeight: CGFloat?
    
    init(consoleView: ConsoleView) { self.consoleView = consoleView }
    
    func keyboardWillAppearWithTopBorderAt(_ topBorderY: CGFloat) { updateBottomEdge(to: topBorderY) }
    func keyboardDidAppearWithTopBorderAt(_ topBorderY: CGFloat) {  /*EMPTY*/ }
    func keyboardWillHide() { restoreToOriginal() }
    
    /// Adjusts the height of ConsoleView such that the view is not obstructed by keyboard/accessory input.
    /// 
    /// - Parameter maxYValue: maximum y value that the bottom of Console can be before being obstructed.
    private func updateBottomEdge(to maxYValue: CGFloat) {
        
        if cachedConstraint.isNil {
            
            if let heightConstraint = consoleView?.constraints.first(where: { $0.identifier == "consoleViewHeight" } ) {
                
                cachedConstraint = heightConstraint
                
            }
            
        }
        
        if let heightConstraint = cachedConstraint {
            
            let padding     = 10.0
            let originY     = consoleView!.frame.origin.y
            let height      = heightConstraint.constant
            let bottomY     = originY   + height
            let heightDiff  = bottomY   - (maxYValue - padding)
            let newHeight   = height    - heightDiff
            
            // Update?
            if newHeight < height {
                
                // Cache
                if cachedHeight.isNil { cachedHeight = height }
                
                heightConstraint.constant = newHeight
                
                animateLayoutChanges()
                
            }
            
        }
        
    }
    
    /// Restores the view's height to its pre-updated value.  Called when keyboard/accessory input are hidden.
    private func restoreToOriginal() {
        
        if let cachedHeight = cachedHeight ,
           let heightConstraint = consoleView?.constraints.first(where: { $0.identifier == "consoleViewHeight" } ) {
            
            heightConstraint.constant = cachedHeight
            
            animateLayoutChanges()
            
        }
        
    }
    
    private func animateLayoutChanges() {
        
        UIView.animate(withDuration: 0.3) { self.consoleView?.superview?.layoutIfNeeded() }
        
    }
    
}
