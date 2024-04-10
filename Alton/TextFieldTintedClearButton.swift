//
//  TextFieldTintedClearButton.swift
//  Alton
//
//  Created by Aaron Nance on 4/10/24.
//

import UIKit

/// Renders a UITextField with the the clear button tinted to the IB specified color.
/// - Note: the specified color has its alpha value reduced to half.
class TextFieldTintedClearButton: UITextField {
    
    @IBInspectable var clearButtonColor: UIColor = UIColor.orange.halfAlpha
    @IBInspectable var clearButtonAlpha: Double = 0.5
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        for view in subviews {
            
            if let button = view as? UIButton {
                
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = clearButtonColor.withAlphaComponent(clearButtonAlpha)
                
            }
            
        }
        
    }
    
}
