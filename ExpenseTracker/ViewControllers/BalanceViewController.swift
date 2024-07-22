//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/22/24.
//

import UIKit

class BalanceController: UIViewController {
    
    let mocks = ["1", "2", "3"]
    let mockBalance = "0.2"
    let mockBitcoinValue = "61232.32"
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        return tableView
    }()
    
    lazy private var bitcoinValueView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BitCoin = \(mockBitcoinValue)$"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    lazy private var titleLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My Wallet"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy private var balanceLableView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Balance: \(mockBalance) BTC"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    lazy private var addBalanceButtonView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.buttonSize = .small
        config.cornerStyle = .medium
        config.image = UIImage(systemName: "arrow.up")
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        
        config.title = "Deposit"
        
        button.configuration = config
        button.addTarget(self, action: #selector(addBalanceButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var addTransactionButtonView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .small

        config.cornerStyle = .medium
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        
        config.title = "Add transaction"
        
        button.configuration = config
        button.addTarget(self, action: #selector(addTransactionButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [balanceLableView, addBalanceButtonView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .trailing
//        stackView.spacing = 20
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(bitcoinValueView)
        view.addSubview(titleLabelView)
        view.addSubview(titleStackView)
        view.addSubview(addTransactionButtonView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            bitcoinValueView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -24),
            bitcoinValueView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabelView.topAnchor.constraint(equalTo: bitcoinValueView.topAnchor, constant: 20),
            titleLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            titleStackView.topAnchor.constraint(equalTo: titleLabelView.topAnchor, constant: 20),
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleStackView.heightAnchor.constraint(equalToConstant: 40),
            
            addTransactionButtonView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10),
            addTransactionButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addTransactionButtonView.widthAnchor.constraint(equalToConstant: 160),
            
            
            tableView.topAnchor.constraint(equalTo: addTransactionButtonView.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc
    private func addBalanceButtonPressed(sender: UIButton!){
       print("add Balance is pressed")
    }
    
    @objc
    private func addTransactionButtonPressed(sender: UIButton!){
       print("add Transaction is pressed")
    }
}

// MARK: - UITableViewDataSource
extension BalanceController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.configure(to: mocks[indexPath.item])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BalanceController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
