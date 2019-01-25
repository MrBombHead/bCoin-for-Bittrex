//
//  Functions.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 6/30/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation

//func backwards(_ s1: String, _ s2: String) -> Bool { return s1 > s2}


enum CoinSortType {
    case MarketName
    case Last
    case PercentageChange
}




func sortDictionary(_ dictionary: [String : [Coin]], bySortType type: CoinSortType) -> [String : [Coin]] {
    var returnDictionary = [String : [Coin]]()
    
    for (key, values) in dictionary {
        let array = values.sorted { (c1, c2) -> Bool in
            if let sum1 = c1.MarketSummary, let sum2 = c2.MarketSummary {
                switch type {
                case .MarketName:
                    return c1.MarketName < c2.MarketName
                case .Last:
                    return sum1.Last > sum2.Last
                case .PercentageChange:
                    return sum1.differencePercentage > sum2.differencePercentage
                }
            } else {
                return false
            }
        }
        returnDictionary[key] = array
    }
    return returnDictionary
}
