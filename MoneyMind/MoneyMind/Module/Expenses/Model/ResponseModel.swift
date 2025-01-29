//
//  ResponseModel.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

struct ExpenseResponse: Codable {
    let message: String
    let expense: ExpenseData
}

struct ExpenseData: Codable {
    let count: Int
    let items: [ExpenseEntity]
}
