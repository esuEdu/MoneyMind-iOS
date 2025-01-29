//
//  ExpenseRouter.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

import UIKit

protocol ExpensesRouterProtocol {
    static func createModule() -> UIViewController
}

class ExpensesRouter: ExpensesRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = ExpensesViewController()
        let interactor = ExpensesInteractor()
        let presenter = ExpensesPresenter(view: view)

        view.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = view
        
        return view
    }
}
