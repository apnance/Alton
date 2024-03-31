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
            
            if let digit = Int(String(char)) {
                operands.append(digit)
            }
            
        }
        
        if operands.count == 4 {
            
            let solver = Solver(operands[0],operands[1],operands[2],operands[3])
            
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
        
        inputTextField.layer.borderColor    = UIColor.gray.cgColor
        inputTextField.layer.borderWidth    = 1
        inputTextField.layer.cornerRadius   = 4
        inputTextField.clipsToBounds        = true
        
        displayTextView.layer.borderColor   = UIColor.gray.cgColor
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
