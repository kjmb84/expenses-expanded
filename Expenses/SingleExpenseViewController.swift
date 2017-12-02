//
//  SingleExpenseViewController.swift
//  Expenses
//
//  Created by Tech Innovator on 11/30/17.
//  Copyright © 2017 Tech Innovator. All rights reserved.
//

import UIKit

class SingleExpenseViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reasonTextField: UITextField!
    
    var existingExpense: Expense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        amountTextField.delegate = self
        
        nameTextField.text = existingExpense?.name
        reasonTextField.text = existingExpense?.reason
        if let amount = existingExpense?.amount {
            amountTextField.text = "\(amount)"
        }
        
        if let date = existingExpense?.date {
            datePicker.date = date
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func saveExpense(_ sender: Any) {
        let name = nameTextField.text
        let amount = Double(amountTextField.text ?? "") ?? 0.0
        let date = datePicker.date
        let reason = reasonTextField.text
        
        var expense: Expense?
        
        if let existingExpense = existingExpense {
            existingExpense.name = name
            existingExpense.amount = amount
            existingExpense.date = date
            existingExpense.reason = reason
            expense = existingExpense
        } else {
            expense = Expense(name: name, amount: amount, date: date, reason: reason)
        }
        
        if let expense = expense {
            do {
                let managedContext = expense.managedObjectContext
                
                try managedContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Context could not be saved")
            }
            
        }
    }
}

extension SingleExpenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
