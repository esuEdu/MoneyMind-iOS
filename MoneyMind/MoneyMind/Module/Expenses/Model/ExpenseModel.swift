//
//  ExpenseModel.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

import Foundation

enum Expense {
    struct Request {
        let filterDate: Date?
    }
    
    struct Response {
        let expenses: [ExpenseEntity]
    }
    
    struct ViewModel {
        let title: String
        let amount: String
        let date: String
    }
}

struct ExpenseEntity: Codable {
    let id: String
    let title: String
    let amount: Double
    let date: String
    let category: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case amount
        case date
        case category
        case description
    }
}







