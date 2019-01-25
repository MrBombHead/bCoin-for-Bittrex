//
//  BittrexResponses.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/19/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation

public struct BittrexResponse<T : Decodable> : Decodable {
    let success: Bool
    let message: String
    let result: T?
}

public struct BittrexArrayResponse<T : Decodable> : Decodable {
    let success: Bool
    let message: String
    let result: [T]?
}
