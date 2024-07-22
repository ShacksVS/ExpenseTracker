//
//  NetworkManager.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/22/24.
//

import Foundation

final class NetworkManager {
    static var shared = NetworkManager()
    
    private init() {}
    
    func fetchBitcoinRate() async throws -> String {
        let endpoint = "https://api.coindesk.com/v1/bpi/currentprice.json"
        guard let url = URL(string: endpoint) else {
            throw NetworkErrors.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.requestFailed
        }
        
        let decoder = JSONDecoder()
        do {
            let bitcoinPriceIndex = try decoder.decode(BitcoinRate.self, from: responseData)
            let bitcoinRateUSD = bitcoinPriceIndex.bpi.usd.rate
            print("Bitcoin rate in USD: \(bitcoinRateUSD)")
            return bitcoinRateUSD
        } catch {
            throw NetworkErrors.decodeResponseFailed
        }
    }
}
