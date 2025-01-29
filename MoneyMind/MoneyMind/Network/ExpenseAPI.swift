//
//  ExpenseAPI.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

import Foundation

enum ExpensesAPI: APIRequest {
    var baseURL: URL { URL(string: "https://onn5nxytud.execute-api.us-east-1.amazonaws.com/dev")! }
    
    case fetchExpenses
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
        case .fetchExpenses:
            return nil
            
        case .createExpense(let expense):
            return [
                "title": expense.title,
                "amount": expense.amount,
                "date": expense.date,
            ]
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
