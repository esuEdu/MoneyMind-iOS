//
//  ExpenseViewController.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

import UIKit

protocol ExpensesDisplayLogic: AnyObject {
    func displayExpenses(_ viewModels: [Expense.ViewModel])
    func displayError(message: String)
}

final class ExpensesViewController: UIViewController, ExpensesDisplayLogic {
    var interactor: ExpensesBusinessLogic?
    private var expenses: [Expense.ViewModel] = []
    
    private var fetchTask: Task<Void, Never>?
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchExpenses()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func fetchExpenses() {
        let request = Expense.Request(filterDate: nil)
        fetchTask = Task {
            await interactor?.fetchExpenses(request: request)
        }
    }
    
    func concelRequest() {
        fetchTask?.cancel()
    }
    
    // MARK: - ExpensesDisplayLogic
    func displayExpenses(_ viewModels: [Expense.ViewModel]) {
        expenses = viewModels
        tableView.reloadData()
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ExpensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let expense = expenses[indexPath.row]
        cell.textLabel?.text = "\(expense.title) - \(expense.amount)"
        cell.detailTextLabel?.text = expense.date
        return cell
    }
}
