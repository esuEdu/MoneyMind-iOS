//
//  ExpenseAPI.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

import Foundation

enum ExpensesAPI: APIRequest {
    var baseURL: String { "https://onn5nxytud.execute-api.us-east-1.amazonaws.com/dev" }
    
    case fetchExpenses(filter: Date?)
    case createExpense(ExpenseEntity)
    
    var path: String {
        switch self {
        case .fetchExpenses: return "/expenses"
        case .createExpense: return "/expense"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchExpenses: return .get
        case .createExpense: return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchExpenses(let filter):
            return filter != nil ? ["date": filter!.ISO8601Format()] : nil
            
        case .createExpense(let expense):
            return [
                "title": expense.title,
                "amount": expense.amount,
                "date": expense.date.ISO8601Format(),
            ]
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
