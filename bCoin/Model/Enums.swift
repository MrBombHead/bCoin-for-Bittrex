//
//  Enums.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/1/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation


enum TradeType {
    case Buy
    case Sell
}

public struct APIInfo {
    let publicKey: String
    let privateKey: String
}

public struct Trade {
    let market: String
    let quantity: Double
    let rate: Double
    let api: APIInfo
    let tradeType: TradeType
}

