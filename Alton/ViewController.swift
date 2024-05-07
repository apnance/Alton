//
//  ViewController.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import UIKit
import APNUtil

class ViewController: UIViewController {
    
    // MARK: - Properties
    var solver: Solver?
    
    // MARK: - Outlets
    @IBOutlet weak var digitsLabel: UILabel!
    @IBOutlet weak var displayTextView: UITextView!
    @IBOutlet weak var altonLogo: UILabel!
    
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet var buttonsCollection: [UIButton]!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiInit()
        
    }
    
    // MARK: - Custom Methods
    private func uiInit() {
        
        digitsLabel.textColor                = UIColor.white.pointSevenAlpha
        
        displayTextView.layer.borderColor   = UIColor.orange.halfAlpha.cgColor
        displayTextView.layer.borderWidth   = 1
        displayTextView.layer.cornerRadius  = 4
        displayTextView.clipsToBounds       = true
        
        for button in buttonsCollection {
            
            button.layer.borderColor        = UIColor.orange.halfAlpha.cgColor
            button.layer.borderWidth        = 1
            button.layer.cornerRadius       = 4
            button.tintColor                = UIColor.orange.halfAlpha
            
            button.addTarget(self,
                             action: #selector(tapButton(sender:)),
                             for: .touchUpInside)
            
        }
        
        uiSetButtons()
        uiSetVersion()
        
        Blink.go(altonLogo)
        
    }
    
    private func uiSetButtons() {
        
        returnButton.isEnabled = solver.isNil ? false : true
        deleteButton.isEnabled = digitsLabel.text!.count > 0
        
    }
    
    private func uiSetVersion() {
     
        var formatted = AttributedString("")
        
        let version = "v\(Bundle.appVersion)"
        
        for (i, char) in version.enumerated() {
            
            var att = AttributedString(String(char))
            att.foregroundColor = i % 2 == 0 ? UIColor.systemYellow.pointFourAlpha : UIColor.systemOrange.pointEightAlpha
            formatted.append(att)
            
        }
        
        versionLabel.attributedText = NSAttributedString(formatted)
        
    }
    
    @discardableResult func uiProcessInput() -> Bool {
        
        let text = digitsLabel.text!
        var operands = [Int]()
        
        for char in text {
            
            if let digit = Int(String(char)) { operands.append(digit) }
            
        }
        
        if operands.count == 4 {
            
            DispatchQueue.main.async {
                
                var msg             = AttributedString("\n\n\n\n\n\n\n        ~ Solving \(text) ~")
                msg.foregroundColor = UIColor.systemOrange.pointNineAlpha
                msg.font            = UIFont(name: "Menlo",
                                             size: 21)
                
                let range = msg.range(of: text)
                msg[range!].foregroundColor         = UIColor.systemYellow.pointNineAlpha
                
                self.displayTextView.attributedText = NSAttributedString(msg)
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                self.solver = Solver(operands)
                self.uiSetButtons()
                self.displayCompleteSolution()
                self.pasteBoard(self.solver)
                
            }
            
            return true /*EXIT*/
            
        } else {
            
            displayTextView.attributedText = NSAttributedString("")
            uiSetButtons()
            
            return false /*EXIT*/
            
        }
        
    }
    
    @objc func tapButton(sender: UIButton) {
        
        digitsLabel.text = digitsLabel.text == "--" ? "" : digitsLabel.text
        let numTapped = sender.tag
        
        switch numTapped {
                
            case -1:    // Clear Input
                digitsLabel.text = ""
                solver = nil
                
            case -2:    // Display Sample Solution
                
                displayCompleteSolution()
                return /*EXIT*/
                
            default:    // Enter Digits or Select Answer Number
                
                if digitsLabel.text!.count == 4 {    // Show Answer Subset
                
                    displaySolutionsFor(numTapped)
                    return /*EXIT*/
                    
                } else {                            // Enter Digit
                    
                    digitsLabel.text! += numTapped.description
                    
                }
        }
        
        uiProcessInput()
        
    }
    
    private func displayCompleteSolution() {
        
        guard let puzzle = solver?.puzzle
        else { return /*EXIT*/ }
        
        let solution                    = puzzle.formattedSolutionSummary()
        displayTextView.attributedText  = colorizeSolutions(solution)
        
    }
    
    /// Displays all solutions for the given answer number.
    /// - Parameter answer: answer number for which solutions should be d
    fileprivate func displaySolutionsFor(_ answer: Int) {
        
        guard let puzzle = solver?.puzzle
        else { return /*EXIT*/ }
        
        let solutions                   = puzzle.formattedSolutionsFor(answer)
        displayTextView.attributedText  = colorizeSolutions(solutions)
        
    }
    
    /// Colorizes and formats the display text as an `NSAttributedString`
    /// - Parameter text: display text to format.
    /// - Returns: colorized/formatted `NSAttributedString` version of `text`
    private func colorizeSolutions(_ text: String) -> NSAttributedString {
        
        var buffer      = ""
        var formatted   = AttributedString()
        
        func processBuffer() {
            
            if buffer.count > 0 {
                
                var asBuffer                = AttributedString(buffer)
                asBuffer.foregroundColor    = UIColor.white
                formatted.append(asBuffer)
                
                buffer                      = "" // Clear Buffer
                
            }
            
        }
        
        let lines = text.split(separator: "\n")
        let formatStartBound = 2
        let formatEndBound = String(lines[0]).contains("Found") ? 11 : Int.max
                
        for (num, text) in lines.enumerated() {
            
            if num < formatStartBound || num > formatEndBound { // Heading
                
                var att = AttributedString(text)
                att.foregroundColor = num == 0 ? UIColor.white : UIColor.white.pointFourAlpha
                formatted.append(att)
                
            } else { // Body
                
                for char in text {
                    
                    let strChar     = String(char)
                    if let color    = Operator.colorFor(char) {
                        
                        // Buffer
                        processBuffer()
                        
                        var colorized               = AttributedString(strChar)
                        colorized.foregroundColor   = color
                        formatted.append(colorized)
                        
                    }
                    else { buffer += strChar }
                }
                
                // Buffer
                processBuffer()
                
            }
            
            // New Line
            formatted.append(AttributedString("\n"))
            
        }
        
        // Global Font Size
        formatted.font = UIFont(name: "Menlo", size: 21)
        
        return NSAttributedString(formatted)
        
    }
    
    private func pasteBoard(_ solver: Solver?) {
        
        if let puzzle = solver?.puzzle {
            
            let digits  = puzzle.digits.reduce(""){$0 + $1.description}
            let diff    = puzzle.difficulty!.estimated
            let diffString = diff <= 10 ? diff.description : "@&!~"
            
            printToClipboard("""
                         ~  ~
                         a  ⧂
                               <( \(digits) : \(diffString) )
                         """)
            
        }
        
    }
    
}
