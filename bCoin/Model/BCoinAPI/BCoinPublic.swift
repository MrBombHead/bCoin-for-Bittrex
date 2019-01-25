//
//  BCoinPublic.swift
//  BCoin
//
//  Created by Craig Cornwell on 1/5/19.
//  Copyright © 2019 Craig Cornwell. All rights reserved.
//

import Foundation

extension BCoin {
    
    public static func loadMarkets(completion: @escaping ([String : [Coin]]?, String?) -> Void) {
        fetchCryptoData(urlString: MARKETS_URL, withAPIDetails: nil) { (response: BittrexArrayResponse<Coin>) in
            if response.success {
                if let markets = response.result {
                    let dictionary = Dictionary(grouping: markets, by: { $0.BaseCurrency })
                    completion(dictionary, nil)
                }
            } else {
                completion(nil, response.message)
            }
        }
    }
    
    public static func getMarketSummary(forMarket market: String, completion: @escaping (CoinDetails?, String?) -> Void) {
        let market_url = MARKET_SUMMARY_URL + "?market=\(market)"
        fetchCryptoData(urlString: market_url, withAPIDetails: nil) { (response: BittrexArrayResponse<CoinDetails>) in
            if response.success {
                if let coinDetails = response.result {
                    completion(coinDetails.first, nil)
                }
            } else {
                completion(nil, response.message)
            }
        }
    }
    
    public static func getMarketSummaries(completion: @escaping (Dictionary<String, CoinDetails>?, String?) -> Void) {
        fetchCryptoData(urlString: MARKET_SUMMARIES_URL, withAPIDetails: nil) { (response: BittrexArrayResponse<CoinDetails>) in
            if response.success {
                if let summary = response.result {
                    var dictionary = [String : CoinDetails]()
                    for item in summary {
                        dictionary[item.MarketName] = item
                    }
                    completion(dictionary, nil)
                }
            } else {
                completion(nil, response.message)
            }
        }
    }
    
    public static func getTicker(forMarket market: String, completion: @escaping (Ticker?, String?) -> ()) {
        let ticketUrl = "https://bittrex.com/api/v1.1/public/getticker?market=\(market)"
        fetchCryptoData(urlString: ticketUrl, withAPIDetails: nil) { (response: BittrexResponse<Ticker>) in
            if response.success {
                if let tick = response.result {
                    completion(tick, nil)
                } else {
                    completion(nil, response.message)
                }
            } else {
                completion(nil, response.message)
            }
        }
    }

}




