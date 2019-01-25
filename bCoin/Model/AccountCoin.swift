//
//  Balance.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 9/6/17.
//  Copyright © 2017 Craig Cornwell. All rights reserved.
//

import Foundation

public struct AccountCoin : Decodable {
    let Currency: String
    let Balance: Double?
    let Available: Double?
    let Pending: Double?
    let CryptoAddress: String? // This can be blank in a lot of cases
    
    var balanceString: String {
        get {
            return Balance?.abbreviatedString ?? "0.0"
        }
    }
    
    var availableString: String {
        get {
            return Available?.abbreviatedString ?? "0.0"
        }
    }
}


