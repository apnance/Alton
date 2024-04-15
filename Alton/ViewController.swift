//
//  ViewController.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var displayTextView: UITextView!
    
    // MARK: - Actions
    
    // MARK: - Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiInit()
        
    }
    
    // MARK: - Custom Methods
    func processInput() -> Bool {
        
        let text = inputTextField.text!
        var operands = [Int]()
        
        for char in text {
            
            if let digit = Int(String(char)) { operands.append(digit) }
            
        }
        
        if operands.count == 4 {
            
            let solution                    = Solver(operands).generateDisplay()
            displayTextView.attributedText  = formatSolution(solution)
            
            return true
            
        } else {
            
            if operands.count == 0 { 
                
                displayTextView.attributedText = NSAttributedString("")
                
            }
            else {
                
                var error   = AttributedString("Bad Input '\(text)'")
                error.foregroundColor = UIColor.yellow
                error.font  = UIFont(name: "Menlo",
                                     size: 21)
                
                displayTextView.attributedText = NSAttributedString(error)
                
            }
            
            return false
            
        }
        
    }
    
    /// Colorizes and formats the display text.
    /// - Parameter text: display text to format.
    /// - Returns: colorized/formatted `NSAttributedString` version of `text`
    private func formatSolution(_ text: String) -> NSAttributedString {
        
        var buffer      = ""
        var formatted   = AttributedString()
        
        func flushBuffer() {
            
            if buffer.count > 0 {
                
                var attBuffer               = AttributedString(buffer)
                attBuffer.foregroundColor   = UIColor.white
                formatted.append(attBuffer)
                buffer                      = ""
                
            }
            
        }
        
        let lines = text.split(separator: "\n")
        assert(lines.count == 12, "Expected 12 lines, Actual: \(lines.count)")
        
        for (num, text) in lines.enumerated() {
            
            if num < 2 {    // Heading
                
                var att = AttributedString(text)
                att.foregroundColor = num == 0 ? UIColor.white : UIColor.white.pointFourAlpha
                formatted.append(att)
                
            } else {        // Body
                
                for char in text {
                    
                    let strChar = String(char)
                    
                    if let color = Operator.colorFor(char) {
                        
                        // Buffer
                        flushBuffer()
                        
                        var colorized               = AttributedString(strChar)
                        colorized.foregroundColor   = color
                        formatted.append(colorized)
                        
                    }
                    else { buffer += strChar }
                }
                
                // Buffer
                flushBuffer()
                
            }
            
            // New Line
            formatted.append(AttributedString("\n"))
            
        }
        
        // Global Font Size
        formatted.font = UIFont(name: "Menlo", size: 21)
        
        return NSAttributedString(formatted)
        
    }
    
    func uiInit() {
        
        inputTextField.addTarget(self,
                                 action: #selector(handleTap(sender:)), for: .editingChanged)
        
        inputTextField.layer.borderColor    = UIColor.orange.halfAlpha.cgColor
        inputTextField.layer.borderWidth    = 1
        inputTextField.layer.cornerRadius   = 4
        inputTextField.clipsToBounds        = true
        
        displayTextView.layer.borderColor   = UIColor.orange.halfAlpha.cgColor
        displayTextView.layer.borderWidth   = 1
        displayTextView.layer.cornerRadius  = 4
        displayTextView.clipsToBounds       = true
        
    }
    
    @objc func handleTap(sender: UITextField) {
        
        if processInput() {
            
            inputTextField.resignFirstResponder()
            
        }
        
    }
    
}

