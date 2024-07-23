# Bitcoin Wallet App

## Overview
This Bitcoin Wallet application allows users to manage their Bitcoin balance, track transactions, and view the current Bitcoin to USD exchange rate. The app features two main screens: a Balance Screen and a Transaction Screen.

## Requirements
### Screen 1: Balance Screen
- **Balance Display**: Shows the current Bitcoin balance with a button to deposit more Bitcoin.
- **Deposit Button**: Opens a pop-up for the user to enter the amount of Bitcoin to deposit.
- **Add Transaction Button**: Navigates to the Transaction Screen.
- **Transaction List**: Displays all transactions, grouped by days from newest to oldest. Each transaction shows the time, amount, and category (groceries, taxi, electronics, restaurant, other).
- **Pagination**: Loads transactions in batches of 20 as the user scrolls.
- **Bitcoin Exchange Rate**: Shows the current Bitcoin to USD exchange rate, updated every session but not more than once per hour. The exchange rate is fetched from a specified API.

### Screen 2: Transaction Screen
- **Transaction Amount Input**: Field to enter the transaction amount.
- **Category Selection**: Options to select the transaction category (groceries, taxi, electronics, restaurant, other).
- **Add Button**: Adds the transaction and navigates back to the Balance Screen with updated information.

## Technical Specifications
- **Language**: Swift
- **Data Storage**: Core Data
- **Architecture**: MVVM
- **UI**: Implemented programmatically without XIBs or Storyboards
- **Dependencies**: No third-party libraries used

## Getting Started
### Prerequisites
- Xcode 12.0 or later
- iOS 14.0 or later

### Installation
1. Clone the repository:
 ```bash
 git clone https://github.com/yourusername/bitcoin-wallet-app.git
 ```
2. Open the project in Xcode:
  ```bash
  cd ExpenseTracker
  ```
  ```bash
  open ExpenseTracker.xcodeproj
  ```
3.	Build and run the project on your preferred simulator.
