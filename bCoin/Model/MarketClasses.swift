//
//  MarketClasses.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/15/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation

public struct Withdrawal: Decodable {
    let PaymentUuid: String? //" : "b52c7a5c-90c6-4c6e-835c-e16df12708b1",
    let Currency: String //" : "BTC",
    let Amount: Double //" : 17.00000000,
    let Address: String? //" : "1DeaaFBdbB5nrHj87x3NHS4onvw1GPNyAu",
    let Opened: String? //" : "2014-07-09T04:24:47.217",
    let Authorized: Bool? //" : true,
    let PendingPayment: Bool? //" : false,
    let TxCost: Double? //" : 0.00020000,
    let TxId: String //" : null,
    let Canceled: Bool? //" : true,
    let InvalidAddress: Bool? //" : false
    
}
    


public struct Deposit: Decodable {
    
    let Id: Int //":75872461,
    let Amount: Double //":0.01000000,
    let Currency: String //":"BTC",
    let Confirmations: Int //":3,
    let LastUpdated: String //":"2018-07-24T17:56:18.737",
    let TxId: String //":"befe0a3371079239a7a7e6a21feb2ad3e0433cda1a0fc9237fcd795bc1ad17ed",
    let CryptoAddress: String //":"1NLxGCZXX5HGBAjGywjfnwjvPP6UCgVwKY"
}

public struct HistoricOrder: Decodable {
    let OrderUuid: String //" : "fd97d393-e9b9-4dd1-9dbf-f288fc72a185",
    let Exchange: String //" : "BTC-LTC",
    let TimeStamp: String //" : "2014-07-09T04:01:00.667",
    let OrderType: String //" : "LIMIT_BUY",
    let Limit: Double //" : 0.00000001,
    let Quantity: Double //" : 100000.00000000,
    let QuantityRemaining: Double //" : 100000.00000000,
    let Commission: Double //" : 0.00000000,
    let Price: Double //" : 0.00000000,
    let PricePerUnit: Double? // : null,
    let IsConditional: Bool //" : false,
    let Condition: String? //" : null,
    let ConditionTarget: Double? //" : null,
    let ImmediateOrCancel: Bool //" : false
}


public struct OpenOrder: Decodable {
    let Uuid: String? //:null,
    let OrderUuid: String //":"63f4c85d-f724-4567-9a1b-0c8f81e07254",
    let Exchange: String //":"BTC-BITB",
    let OrderType: String //":"LIMIT_SELL",
    let Quantity: Double //":1000.00000000,
    let QuantityRemaining: Double //":1000.00000000,
    let Limit: Double //":0.00051000,
    let CommissionPaid: Double //":0.00000000,
    let Price: Double //":0.00000000,
    let PricePerUnit: String? //":null,
    let Opened: String //":"2018-07-15T15:32:26.527",
    let Closed: String? //:null,
    let CancelInitiated: Bool //":false,
    let ImmediateOrCancel: Bool //":false,
    let IsConditional: Bool //":false,
    let Condition: String //":"NONE",
    let ConditionTarget: String? //":null}
    
    var Filled: Double {
        return Quantity - QuantityRemaining
    }
    var Total: Double {
        return Quantity * Limit
    }
    var CommissionEstimate: Double {
        return Total * 0.0025
    }
    var TotalReturn: Double {
        return Total - CommissionEstimate
    }
}

struct OrderRef: Decodable {
    let uuid: String
}
