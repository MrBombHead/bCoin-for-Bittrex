//
//  File.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/27/17.
//  Copyright © 2017 Craig Cornwell. All rights reserved.
//

import Foundation

public struct CoinDetails: Decodable {
    let MarketName: String
    let High: Double
    let Low: Double
    let Volume: Double
    let Last: Double
    let BaseVolume: Double
    let TimeStamp: String
    let Bid: Double
    let Ask: Double
    let OpenBuyOrders: Int
    let OpenSellOrders: Int
    let PrevDay: Double
    let Created: String
    
    
    //This could get a bit messy - maybe look at options for using generics
    
//    fileprivate func valueAsString(_ value: Double) -> String {
//
//
//        if MarketName.contains("USD") {
//            return value.string(byDecimalPoints: 2)
//        }
//
//
//        if value > 1 {
//            return value.string(byDecimalPoints: 2)
//        } else if value > 0.5 {
//            return value.string(byDecimalPoints: 4)
//        } else {
//            return value.string(byDecimalPoints: 8)
//        }
//    }
    
    
    var lastString: String {
        get {
            if MarketName.contains("USD") {
                return self.Last.string(byDecimalPoints: 2)
            }
            return self.Last.stringWithAutomatedDecimal()
        }
    }
    
    var bidString: String {
        get {
            return self.Bid.stringWithAutomatedDecimal()
        }
    }
    
    var askString: String {
        get {
            return self.Ask.stringWithAutomatedDecimal()
        }
    }

    
    var volumeString: String {
        get {
            return Volume.abbreviatedString
        }
    }
    
    var baseVolumeString: String {
        get {
            return BaseVolume.abbreviatedString
        }
    }
    

    
    var differenceValue: Double {
        get {
            return Last - PrevDay
        }
    }
    
    var differenceValueString: String {
        get {
            let absoluteValue = abs(differenceValue)
            
            if absoluteValue > 1 {
                return differenceValue.string(byDecimalPoints: 2)
            } else {
                return differenceValue.string(byDecimalPoints: 8)
            }
        }
    }
    
    
    
    var differencePercentage: Double {
        get {
            return (differenceValue / PrevDay) * 100
        }
    }
    var differencePercentageString: String {
        get {
            return "\(differencePercentage.string(byDecimalPoints: 1))%"
        }
    }

}
