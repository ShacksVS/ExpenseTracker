//
//  BitcoinRate.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/22/24.
//

import Foundation

struct BitcoinRate: Codable {
    let bpi: BPI
}

struct BPI: Codable {
    let usd: Currency

    private enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct Currency: Codable {
    let rate: String
}
