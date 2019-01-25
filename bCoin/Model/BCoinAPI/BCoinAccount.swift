//
//  BCoinAccount.swift
//  BCoin
//
//  Created by Craig Cornwell on 1/5/19.
//  Copyright © 2019 Craig Cornwell. All rights reserved.
//

import Foundation


extension BCoin {

    public static func getAccountBalances(withAPIDetails api: APIInfo, completion: @escaping ([AccountCoin]?, String?) -> ()) {
        let accountURL = "https://bittrex.com/api/v1.1/account/getbalances?apikey=\(api.publicKey)&nonce=\(NSDate().timeIntervalSince1970)"
        fetchCryptoData(urlString: accountURL, withAPIDetails: api) { (response: BittrexArrayResponse<AccountCoin>) in
            if response.success {
                if let coins = response.result {
                    completion(coins.filter({ (coin) -> Bool in
                        if let bal = coin.Balance {
                            return bal > 0.0
                        } else { return false }
                    }), nil)
                } else {
                    completion(nil, "No coins found")
                }
            } else {
                completion(nil, response.message)
            }
        }
    }
    
    public static func getAccountBalance(forCurrency currency: String, withAPIDetails api: APIInfo, completion: @escaping (AccountCoin?, String?) -> ()) {
        let accountURL = "https://bittrex.com/api/v1.1/account/getbalance?currency=\(currency)&apikey=\(api.publicKey)&nonce=\(NSDate().timeIntervalSince1970)"
        fetchCryptoData(urlString: accountURL, withAPIDetails: api) { (response: BittrexResponse<AccountCoin>) in
            if let coin = response.result {
                completion(coin, nil)
            }
        }
    }
    
    public static func loadOrderHistory(forAPIDetails api: APIInfo, completion: @escaping ([HistoricOrder]) -> ()) {
        let openOrdersURL = "https://bittrex.com/api/v1.1/account/getorderhistory?apikey=\(api.publicKey)&nonce=\(NSDate().timeIntervalSince1970)"
        fetchCryptoData(urlString: openOrdersURL, withAPIDetails: api) { (response: BittrexArrayResponse<HistoricOrder>) in
            if let orders = response.result {
                completion(orders)
            }
        }
    }
    
    public static func loadWithdrawalHistory(forAPIDetails api: APIInfo, completion: @escaping ([Withdrawal]) -> ()) {
        let withdrawalsURL = "https://bittrex.com/api/v1.1/account/getwithdrawalhistory?apikey=\(api.publicKey)&nonce=\(NSDate().timeIntervalSince1970)"
        fetchCryptoData(urlString: withdrawalsURL, withAPIDetails: api) { (response: BittrexArrayResponse<Withdrawal>) in
            if let orders = response.result {
                completion(orders)
            }
        }
    }
    
    public static func loadDepositHistory(forAPIDetails api: APIInfo, completion: @escaping ([Deposit]) -> ()) {
        let withdrawalsURL = "https://bittrex.com/api/v1.1/account/getdeposithistory?apikey=\(api.publicKey)&nonce=\(NSDate().timeIntervalSince1970)"
        fetchCryptoData(urlString: withdrawalsURL, withAPIDetails: api) { (response: BittrexArrayResponse<Deposit>) in
            if let orders = response.result {
                completion(orders)
            }
        }
    }
}
