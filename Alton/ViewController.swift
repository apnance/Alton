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

// - MARK: TEST
extension ViewController {
    
    func test() {
  
        let exp0 = Expression("(2_4)/(1_2)")
        print(exp0.evaluatedDescription)
        assert(exp0.value == 1)
        
        let exp1 = Expression("8_2 / 4_2")
        assert(exp1.value == 2)
        print(exp1.evaluatedDescription)
        
        let exp2 = Expression("1_4")
        print(exp2.evaluatedDescription)
        assert(exp2.value == Configs.Expression.invalidValue)
        
        let exp3 = Expression("44 / 11")
        assert(exp3.value == 4)
        print(exp3.evaluatedDescription)
        
        let exp4 = Expression("7_1/(7_5)")
        print(exp4.evaluatedDescription)
        assert(exp4.value == 5, "Expected \(5) - Actual: \(exp4.value)")
        
        let solver = Solver([3,5,7,8])
        solver.echoResults() // Requires fractional operands!
    
    }
    
}
