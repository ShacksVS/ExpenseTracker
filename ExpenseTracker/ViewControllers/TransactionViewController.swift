//
//  TransactionViewController.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/22/24.
//

import Foundation
import UIKit

class TransactionViewController: UIViewController {
    
    enum Category: String, CaseIterable {
        case groceries = "Groceries"
        case taxi = "Taxi"
        case electronics = "Electronics"
        case restaurant = "Restaurant"
        case other = "Other"
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCategoryPicker()
    }
    
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
    
    @objc
    private func createTransactionButtonPressed() {
        guard
            let amount = amountTextField.text,
            let category = categoryTextField.text,
            amount != "",
            category != ""
        else { return }
        
        print(amount, category)
        navigationController?.popViewController(animated: true)
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
