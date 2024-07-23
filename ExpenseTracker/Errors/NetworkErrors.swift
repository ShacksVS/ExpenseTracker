//
//  NetworkErrors.swift
//  ExpenseTracker
//
//  Created by Viktor Sovyak on 7/22/24.
//

import Foundation

enum NetworkErrors: Error {
    case invalidUrl
    case requestFailed
    case decodeResponseFailed
}
