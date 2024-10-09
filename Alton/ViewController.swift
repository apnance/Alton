//
//  ViewController.swift
//  Alton
//
//  Created by Aaron Nance on 5/22/23.
//

import UIKit
import APNUtil
import ConsoleView

class ViewController: UIViewController {
    
    // MARK: - Properties
    var solver: Solver?
    
    // MARK: - Outlets
    @IBOutlet weak var consoleView: ConsoleView!
    @IBOutlet weak var digitsLabel: UILabel!
    @IBOutlet weak var displayTextView: UITextView!
    @IBOutlet weak var altonLogo: UILabel!
    
    @IBOutlet weak var summaryButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tenButton: UIButton!
    
    @IBOutlet var buttonsCollection: [UIButton]!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiInit()
        
    }
    
    @objc private func handleDisplayTap(_ sender: UITextView) {
        
        consoleView.showHide(.show)
        
    }
    
    // MARK: - Custom Methods
    private func uiInit() {
        
        // Console - Configurators
        AltonConsoleConfigurator(consoleView: consoleView,
                                 archiver: PuzzleArchiver.shared)
        DataManagerConfigurator(consoleView: consoleView,
                                data: PuzzleArchiver.shared)
        
        // Console - UI
        consoleView.showHide(.hide)
        consoleView.layer.cornerRadius  = Configs.UI.View.cornerRadius
        
        digitsLabel.textColor               = UIColor.white.pointSevenAlpha
        
        displayTextView.layer.borderColor   = Configs.UI.View.borderColor
        displayTextView.layer.borderWidth   = Configs.UI.View.borderWidth
        displayTextView.layer.cornerRadius  = Configs.UI.View.cornerRadius
        displayTextView.clipsToBounds       = true
        
        displayTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, 
                                                                    action: #selector(handleDisplayTap(_:))))
        
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
    
    private func uiSetButtons(showSummaryButton: Bool? = nil,
                              showDeleteButton: Bool? = nil) {
        
        if let summary = showSummaryButton { summaryButton.isEnabled = summary }
        else { summaryButton.isEnabled = solver.isNil ? false : true }
        
        if let delete = showDeleteButton { deleteButton.isEnabled = delete }
        else { deleteButton.isEnabled = digitsLabel.text!.count > 0 }
        
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
                
                PuzzleArchiver.shared.confirmSave(self.solver?.puzzle)
                
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
                
                tenButton.isEnabled = false
                
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
        
        displayTextView.attributedText  = puzzle.colorizeSolutions()
        
        uiSetButtons(showSummaryButton: false,
                     showDeleteButton: true)
        
        tenButton.isEnabled = true
        
    }
    
    /// Displays all solutions for the given answer number.
    /// - Parameter answer: answer number for which solutions should be d
    fileprivate func displaySolutionsFor(_ answer: Int) {
        
        guard let puzzle = solver?.puzzle
        else { return /*EXIT*/ }
        
        displayTextView.attributedText  = puzzle.colorizeSolutions(forAnswer: answer)
        
        uiSetButtons(showSummaryButton: true, 
                     showDeleteButton: true)
        
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
