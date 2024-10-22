//
//  TransactionViewController.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/22/24.
//

import Foundation
import UIKit
import CoreData

class TransactionViewController: UIViewController {
    
    // MARK: - Properties
    var context: NSManagedObjectContext!
    weak var delegate: TransactionViewControllerDelegate?

    // MARK: - Category options
    enum Category: String, CaseIterable {
        case groceries = "Groceries"
        case taxi = "Taxi"
        case electronics = "Electronics"
        case restaurant = "Restaurant"
        case other = "Other"
    }
    
    // MARK: - Views
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Make a new transaction"
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Select category"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy private var addNewTransactionButtonView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.buttonSize = .medium

        config.cornerStyle = .medium
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        
        config.title = "Create"
        
        button.configuration = config
        button.addTarget(self, action: #selector(createTransactionButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                amountTextField,
                categoryTextField
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCategoryPicker()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(textLabel)
        view.addSubview(stackView)
        view.addSubview(addNewTransactionButtonView)
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            
            addNewTransactionButtonView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            addNewTransactionButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addNewTransactionButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Setup Picker
    private func setupCategoryPicker() {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        toolbar.setItems([doneButton], animated: true)
        
        categoryTextField.inputView = pickerView
        categoryTextField.inputAccessoryView = toolbar
    }
    
    @objc
    private func donePicker() {
        categoryTextField.resignFirstResponder()
    }
    
    // MARK: - Transaction button pressed fucntion
    @objc
    private func createTransactionButtonPressed() {
        guard
            let amount = amountTextField.text,
            let category = categoryTextField.text,
            amount != "",
            let amount = Float(amount),
            category != ""
        else { return }
        
        print(amount, category)
        
        do {
            let updated = delegate?.didUpdateBalance(amount)
            guard 
                let updated = updated,
                updated
            else {
                print("Dont have enough in balance")
                showInsufficientBalanceAlert()
                return
            }
            
            let transaction = try createTransaction(
                amount: amount,
                transactionDate: Date(),
                category: category
            )
            
            delegate?.didAddTransaction(transaction)

        } catch {
            print("Failed to create: \(error)")
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Core Data
    private func createTransaction(amount: Float, transactionDate: Date, category: String) throws -> Transaction {
        let newTransaction = Transaction(context: context)
        newTransaction.amount = amount
        newTransaction.transactionDate = transactionDate
        newTransaction.category = category

        do {
            try context.save()
            return newTransaction
        } catch {
            print("Cannot save")
            throw CoreDataErrors.failedToSave
        }
    }
    
    // MARK: - Insufficient Balance Alert
    private func showInsufficientBalanceAlert() {
        let alertController = UIAlertController(
            title: "Insufficient Balance",
            message: "You do not have enough BTC to make this transaction.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UIPickerViewDataSource
extension TransactionViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
}

// MARK: - UIPickerViewDelegate
extension TransactionViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = Category.allCases[row].rawValue
    }
}
