//
//  Helper.swift
//  BCoin
//
//  Created by Craig Cornwell on 1/5/19.
//  Copyright © 2019 Craig Cornwell. All rights reserved.
//

import Foundation

struct Keys {
    static let publicKey    = "publicAPIKey"
    static let privateKey   = "privateAPIKey"
    static let favourites   = "favs"
}

class Helper {
    
    static let defaults = UserDefaults.standard
    
    
    public static func addAPIKeysToUserDefaults(apiKeys keys: APIInfo) {
        defaults.set(keys.publicKey, forKey: Keys.publicKey)
        defaults.set(keys.privateKey, forKey: Keys.privateKey)
    }
    
    
    public static func removeAPIKeysFromUserDefaults() {
        defaults.removeObject(forKey: Keys.publicKey)
        defaults.removeObject(forKey: Keys.privateKey)
    }

    public static func getAPIKeysFromUserDefaults() -> APIInfo? {
        if let publicKey = defaults.string(forKey: Keys.publicKey),
            let privateKey = defaults.string(forKey: Keys.privateKey) {
            
            return APIInfo(publicKey: publicKey, privateKey: privateKey)
        }
        return nil
    }
    
    public static func getFavCoinsFromUserDefaults() -> [String]? {
        return defaults.stringArray(forKey: Keys.favourites)
    }
    
    public static func removeCoinFromFavs(_ coin: String) {
        if var array = getFavCoinsFromUserDefaults() {
            array.removeAll { (itemString) -> Bool in
                return itemString == coin
            }
            defaults.set(array, forKey: Keys.favourites)
        }
    }
    
    public static func addCoinToFavCoins(_ coin: String) {
        if var array = getFavCoinsFromUserDefaults() {
            if !array.contains(coin) {
                array.append(coin)
                defaults.set(array, forKey: Keys.favourites)
            }
        } else {
            let array = [coin]
            defaults.set(array, forKey: Keys.favourites)
        }
    }
    
    
}
