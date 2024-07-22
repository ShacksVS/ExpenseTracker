//
//  TransactionCell.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/22/24.
//

import Foundation
import UIKit

class TransactionCell: UITableViewCell {
    
    // MARK: - Views
    private lazy var transactionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26)
        label.textColor = .red
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Configuration of a cell
    func configure(to name: String) {
        transactionLabel.text = name
    }
    
    private func setupUI() {
        contentView.addSubview(transactionLabel)
        
        NSLayoutConstraint.activate([
            transactionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            transactionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
