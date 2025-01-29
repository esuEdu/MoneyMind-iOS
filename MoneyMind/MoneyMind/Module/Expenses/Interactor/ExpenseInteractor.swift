//
//  ExpenseInteractor.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

import Foundation

protocol ExpensesBusinessLogic {
    func fetchExpenses(request: Expense.Request) async
}

class ExpensesInteractor: ExpensesBusinessLogic {
    var presenter: ExpensesPresentationLogic?
    
    private let networkWorker: NetworkWorkerProtocol
    
    init(networkWorker: NetworkWorkerProtocol = NetworkWorker()) {
        self.networkWorker = networkWorker
    }
    
    func fetchExpenses(request: Expense.Request) async {
        do {
            let response = try await networkWorker.request(
                ExpensesAPI.fetchExpenses,
                responseType: ExpenseResponse.self
            )
            
            print(response)
            
            await MainActor.run {
                presenter?.expensesFetched(expenses: response.expense.items)
            }
        } catch {
            await MainActor.run {
                presenter?.presentError(error)
            }
        }
    }
}
