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
        
        let expressions = [" 1   +  1 + 24    ",
                           "(1+1+24)",
                           "1+(2+3)/5",
                           "(5 + 5)",
                           "4+4+++++---(((())))",]
        
        for exp in expressions {
            
            print(Expression(exp).evaluatedDescription)
            
        }
        
        // test()
        
    }
    
    // MARK: - Custom Methods
    func processInput() -> Bool {
        
        let text = inputTextField.text!
        var operands = [Int]()
        
        for char in text {
            
            if let digit = Int(String(char)) {
                operands.append(digit)
            }
            
        }
        
        if operands.count == 4 {
            
            let solver = Solver(operands)
            
            displayTextView.text = solver.generateDisplay()
//            displayTextView.text = solver.generateDisplay()
            
            return true
            
        } else {
            
            displayTextView.text = "Error - Bad Input [\(text)]"
            
            return false
            
        }
        
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

// TODO: Clean Up - delete
// - MARK: TEST DELETE THIS SECTION
extension ViewController {
    
    func test() {
        
        // Parenthetical Solutions
        Solver([2,4,4,8]).echoResults() // Requires parenthetical sub-expressions
        Solver([4,4,4,4]).echoResults() // Requires parenthetical sub-expressions
        
        // Fractional Solutions
        Solver([3,5,7,8]).echoResults() // Requires fractional operands!
        
        Solver([1,2,3,4]).echoResults()
        
    }
    
}
