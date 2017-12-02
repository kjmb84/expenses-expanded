//
//  ExpensesViewController.swift
//  Expenses
//
//  Created by Tech Innovator on 11/30/17.
//  Copyright © 2017 Tech Innovator. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController {
    
    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    var expenses = [Expense]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.expensesTableView.delegate = self
        self.expensesTableView.dataSource = self
        
        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveExpenses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SingleExpenseViewController,
            let selectedRow = self.expensesTableView.indexPathForSelectedRow?.row else {
                return
        }
        
        destination.existingExpense = expenses[selectedRow]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteExpense(at: indexPath)
        }
    }
    
    func retrieveExpenses() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            expenses = try managedContext.fetch(fetchRequest)
            expensesTableView.reloadData()
            totalCostLabel.text = String(expenses.reduce(0, { x, y in
                return x + y.amount
            }))
        } catch {
            print("failed at fetch")
        }
    }
    
    @IBAction func addNewExpense(_ sender: Any) {
        performSegue(withIdentifier: "showExpense", sender: self)
    }
    
    func deleteExpense(at indexPath: IndexPath) {
        let expense = expenses[indexPath.row]
        if let managedContext = expense.managedObjectContext {
            managedContext.delete(expense)
            do {
                try managedContext.save()
                self.expenses.remove(at: indexPath.row)
                expensesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                expensesTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

}

extension ExpensesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expensesTableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        let expense = expenses[indexPath.row]
        
        if let name = expense.name {
            cell.textLabel?.text = name
            cell.textLabel?.text = (cell.textLabel?.text)! + " - $" + "\(expense.amount)"
            cell.backgroundColor = UIColor.blue.
        }
        
        if let date = expense.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
}

extension ExpensesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showExpense", sender: self)
    }
}
