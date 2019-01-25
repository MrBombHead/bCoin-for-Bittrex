//
//  BittrexEngine.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/27/17.
//  Copyright © 2017 Craig Cornwell. All rights reserved.
//

import UIKit

public class BCoin {

    public static func fetchCryptoData<T: Decodable>(urlString: String, withAPIDetails api: APIInfo?, completion: @escaping (T) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url, timeoutInterval: TimeInterval(20))
        
        if let apiInfo = api {
            guard let hash = urlString.hmac(key: apiInfo.privateKey, algorithm: .sha512) else { return }
            request.addValue(hash, forHTTPHeaderField: "apisign")
        }

        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to fetch data - ", err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
            } catch let jsonErr {
                print("Failed to decode json", jsonErr)
                if let jsonError = String(data: data, encoding: .utf8) {
                    print(jsonError)
                }
            }
            
            session.invalidateAndCancel()
            }.resume()
    }
    
    

    
    
    
    
    


    
    
    
    
    
    
}
