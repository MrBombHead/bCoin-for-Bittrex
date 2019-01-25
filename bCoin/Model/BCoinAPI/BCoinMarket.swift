//
//  BCoinMarket.swift
//  BCoin
//
//  Created by Craig Cornwell on 1/5/19.
//  Copyright © 2019 Craig Cornwell. All rights reserved.
//

import Foundation

extension BCoin {
    
    public static func loadOpenOrders(forAPIDetails api: APIInfo, completion: @escaping ([OpenOrder]?, String?) -> ()) {
        let openOrdersURL = "https://bittrex.com/api/v1.1/market/getopenorders?apikey=\(api.publicKey)&nonce=\(NSDate().timeIntervalSince1970)"
        fetchCryptoData(urlString: openOrdersURL, withAPIDetails: api) { (response: BittrexArrayResponse<OpenOrder>) in
            if response.success {
                if let orders = response.result {
                    completion(orders, nil)
                } else {
                    completion(nil, response.message)
                }
            } else {
                completion(nil, response.message)
            }
        }
    }
    
    public static func cancelOrder(forOrderID orderID: String, withAPIDetails api: APIInfo, completion: @escaping (BittrexResponse<Bool>) -> ()) {
        let cancelOrderURL = "https://bittrex.com/api/v1.1/market/cancel?uuid=\(orderID)&apikey=\(api.publicKey)&nonce=\(NSDate().timeIntervalSince1970)"
        fetchCryptoData(urlString: cancelOrderURL, withAPIDetails: api) { (response: BittrexResponse) in
            completion(response)
        }
    }
    
    public static func placeTradeOrder(withTradeDetails trade: Trade, completion: @escaping (Bool, String) -> ()) {
        var urlStart = ""
        if trade.tradeType == .Buy {
            urlStart = "https://bittrex.com/api/v1.1/market/buylimit"
        } else if trade.tradeType == .Sell {
            urlStart = "https://bittrex.com/api/v1.1/market/selllimit"
        }
        
        let orderURL = "\(urlStart)?market=\(trade.market)&quantity=\(trade.quantity)&rate=\(trade.rate)&apikey=\(trade.api.publicKey)&nonce=\(NSDate().timeIntervalSince1970)"
        
        fetchCryptoData(urlString: orderURL, withAPIDetails: trade.api) { (response: BittrexResponse<OrderRef>) in
            completion(response.success, response.message)
        }
    }
    
}
