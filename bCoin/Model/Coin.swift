//
//  Markets.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 9/8/17.
//  Copyright © 2017 Craig Cornwell. All rights reserved.
//

import Foundation

public struct Coin: Decodable {

    let MarketCurrency: String //": "LTC",
    let BaseCurrency: String //": "BTC",
    let MarketCurrencyLong: String //"Litecoin",
    let BaseCurrencyLong: String
    let MarketName: String //"BTC-LTC",
    let IsActive: Bool //true,
    let LogoUrl: String?
    var MarketSummary: CoinDetails?
    
    
    var isInFavourites: Bool {
        get {
            if let coins = Helper.getFavCoinsFromUserDefaults() {
                return coins.contains(MarketCurrency)
            }
            return false
        }
    }

    public func doesCoinContain(text t: String) -> Bool {
        let temp = (self.MarketCurrency + " - " + self.MarketCurrencyLong).uppercased()
        return temp.contains(t.uppercased())
    }
    
}
