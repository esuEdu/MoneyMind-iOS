//
//  ExpenseInteractor.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

import Foundation

protocol ExpensesBusinessLogic {
    func fetchExpenses(request: Expense.Request)
}

class ExpensesInteractor: ExpensesBusinessLogic {
    var presenter: ExpensesPresentationLogic?
    
    func fetchExpenses(request: Expense.Request) {
        // Simulate async operation
        DispatchQueue.global().async {
            do {
                let expenses = try self.fetchExpensesFromStorage(filterDate: request.filterDate)
                self.presenter?.expensesFetched(expenses: expenses)
            } catch {
                self.presenter?.presentError(error)
            }
        }
    }
    
    private func fetchExpensesFromStorage(filterDate: Date?) throws -> [ExpenseEntity] {
        // Add real data fetching logic here
        return [
            ExpenseEntity(id: UUID(), title: "Groceries", amount: 50.0, date: Date()),
            ExpenseEntity(id: UUID(), title: "Transport", amount: 20.0, date: Date())
        ]
    }
}
