//
//  ExpensesPresenter.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//


import Foundation

protocol ExpensesPresentationLogic {
    func expensesFetched(expenses: [ExpenseEntity])
    func presentError(_ error: Error)
}

class ExpensesPresenter: ExpensesPresentationLogic {
    
    weak var viewController: ExpensesDisplayLogic?
    
    init(view: ExpensesDisplayLogic) {
        self.viewController = view
    }
    
    func expensesFetched(expenses: [ExpenseEntity]) {
        let viewModels = expenses.map { entity in
            Expense.ViewModel(
                title: entity.title,
                amount: String(format: "$%.2f", entity.amount),
                date: DateFormatter.localizedString(
                    from: entity.date,
                    dateStyle: .medium,
                    timeStyle: .none
                )
            )
        }
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayExpenses(viewModels)
        }
    }
    
    func presentError(_ error: Error) {
        let message = error.localizedDescription
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayError(message: "Error: \(message)")
        }
    }
}
