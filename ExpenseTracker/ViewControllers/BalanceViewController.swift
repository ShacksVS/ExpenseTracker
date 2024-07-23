//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/22/24.
//

import UIKit
import CoreData

class BalanceController: UIViewController {
    
    // MARK: - Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var transactions: [Transaction] = []
    var balance: Balance?
    var BTCrate: String = "0.0" {
        didSet {
            DispatchQueue.main.async {
                self.bitcoinValueView.text = "BTC = \(self.BTCrate)$"
            }
        }
    }
    let fetchLimit = 20
    var currentOffset = 0
    var isFetchingMoreTransactions = false
    var allFound = false
    
    // MARK: - Views
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
        label.text = "Loading BTC rate.."
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
    
    lazy private var balanceLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Balance: \(balance?.amountBTC ?? 0.0) BTC"
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
        let stackView = UIStackView(
            arrangedSubviews: [
                balanceLabelView,
                addBalanceButtonView
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .trailing
//        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateBitcoinRate()
        fetchBalance()
        do {
            try loadTransactions(offset: currentOffset)
        } catch {
            print("Cannot load: \(error)")
        }
        
        // Register for an observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBitcoinRate),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTable()
    }
    
    // Remove observer
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    private func updateTable() {
        self.tableView.reloadData()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = UIColor.systemBackground
        
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
    
    // MARK: - Update balance
    @objc
    private func addBalanceButtonPressed(sender: UIButton!) {
        let alert = UIAlertController(
            title: "Deposit",
            message: "Enter the amount to deposit",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        let addAction = UIAlertAction(
            title: "Recieve",
            style: .default
        ) { [weak self, weak alert] _ in
            if let textField = alert?.textFields?.first, let amount = textField.text, !amount.isEmpty {
                print("Amount to deposit: \(amount)")
                guard 
                    let self = self,
                    let amount = Float(amount),
                    amount > 0
                else { return }
                
                do {
                    try self.createTransaction(
                        amount: amount,
                        transactionDate: Date()
                    )
                    self.increaseBalance(amount: amount)
                } catch {
                    print("Error fetching Bitcoin rate: \(error)")
                }
                self.updateTable()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func increaseBalance(amount: Float) {
        balance?.amountBTC += amount
        do {
            try context.save()
            updateBalanceLabel()
        } catch {
            print("Cannot update balance")
        }
    }
    
    private func decreaseBalance(amount: Float) -> Bool {
        guard 
            let amountBtc = balance?.amountBTC,
            amount <= amountBtc
        else { return false }
        
        balance?.amountBTC -= amount
        do {
            try context.save()
            updateBalanceLabel()
            return true
        } catch {
            print("Cannot update balance")
            return false
        }
    }
    
    private func updateBalanceLabel() {
        balanceLabelView.text = "Balance: \(balance?.amountBTC ?? 0.0) BTC"
    }
    
    // MARK: - Transaction button function
    @objc
    private func addTransactionButtonPressed(sender: UIButton!){
        let transactionVC = TransactionViewController()
        transactionVC.context = self.context
        transactionVC.delegate = self
        self.navigationController?.pushViewController(transactionVC, animated: true)
    }
    
    // MARK: - Core Data
    private func loadTransactions(offset: Int) throws {
        do {
            let request = Transaction.fetchRequest(limit: fetchLimit, offset: offset)
            let newTransactions = try context.fetch(request)
            if !newTransactions.isEmpty {
                self.transactions.append(contentsOf: newTransactions)
                currentOffset += fetchLimit
            } else {
                allFound = true
            }
            self.isFetchingMoreTransactions = false
            updateTable()
        } catch {
            print("Error fetching transactions: \(error)")
            throw CoreDataErrors.failedToFetchTransactions
        }
    }
    
    private func createTransaction(amount: Float, transactionDate: Date) throws{
        let newTransaction = Transaction(context: context)
        newTransaction.amount = amount
        newTransaction.transactionDate = Date()
        newTransaction.category = "Received"
        
        do {
            try context.save()
            self.transactions.insert(newTransaction, at: 0)
            updateTable()
        } catch {
            print("Cannot save")
            throw CoreDataErrors.failedToSave
        }
    }
    
    private func fetchBalance() {
        let request: NSFetchRequest<Balance> = Balance.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let fetchedBalance = results.first {
                balance = fetchedBalance
            } else {
                // Create a new balance if not existing
                balance = Balance(context: context)
                balance?.amountBTC = 0.0
                try context.save()
            }
            updateBalanceLabel()
        } catch {
            print("Error while fetching a balance: \(error)")
        }
    }
    
    @objc private func updateBitcoinRate() {
        let fetchRequest: NSFetchRequest<BtcRate> = BtcRate.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            if let btcRate = results.first {
                let lastUpdate = btcRate.lastUpdated ?? Date.distantPast
                let oneHourAgo = Date().addingTimeInterval(-3600)
                
                if lastUpdate < oneHourAgo {
                    fetchBitcoinRate()
                } else {
                    print("Using cached Bitcoin rate: \(btcRate.rate)")
                    self.BTCrate = String(btcRate.rate)
                }
            } else {
                fetchBitcoinRate()
            }
        } catch {
            print("Error fetching BTC rate: \(error)")
        }
    }
    
    private func saveBTCRate(rate: Float) {
        let fetchRequest: NSFetchRequest<BtcRate> = BtcRate.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            if let btcRate = results.first {
                btcRate.rate = rate
                btcRate.lastUpdated = Date()
            } else {
                let newRate = BtcRate(context: context)
                newRate.rate = rate
                newRate.lastUpdated = Date()
            }
            try context.save()
            print("BTC rate and update Date saved in Core Data")
        } catch {
            print("Error saving BTC rate: \(error)")
        }
    }
    
    // MARK: - Fetch BTC rate from network
    private func fetchBitcoinRate() {
        print("Updating BTC rate")
        Task {
            do {
                let rate = try await NetworkManager.shared.fetchBitcoinRate()
                self.BTCrate = String(rate)
                saveBTCRate(rate: rate)
            } catch {
                print("Error fetching Bitcoin rate: \(error)")
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension BalanceController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.configure(with: transactions[indexPath.item])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BalanceController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UIScrollViewDelegate
extension BalanceController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            if !isFetchingMoreTransactions && !allFound {
                isFetchingMoreTransactions = true
                do {
                    try loadTransactions(offset: currentOffset)
                } catch {
                    print("Cannot load: \(error)")
                }
            }
        }
    }
}

// MARK: - TransactionViewControllerDelegate
extension BalanceController: TransactionViewControllerDelegate {
    func didUpdateBalance(_ amount: Float) -> Bool {
        let updated = decreaseBalance(amount: amount)
        return updated
    }
    
    func didAddTransaction(_ transaction: Transaction) {
        self.transactions.insert(transaction, at: 0)
        updateTable()
    }
}
