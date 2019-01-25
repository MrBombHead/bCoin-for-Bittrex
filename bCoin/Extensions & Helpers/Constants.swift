//
//  Constants.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 9/6/17.
//  Copyright © 2017 Craig Cornwell. All rights reserved.
//

import Foundation
import UIKit

//let bCoinFont = UIFont(name: "Avenir Next", size: 16.0)
//let myFont = UIFont(name: "Avenir Next", size: 12.0)
//let myFontBold = UIFont(name: "Avenir Next Demi Bold", size: 12.0)
//let myFontBigBold = UIFont(name: "Avenir Next Demi Bold", size: 14.0)


let myRed = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
let myGreen = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0)
let myBlue = UIColor(red: 34/255, green: 83/255, blue: 142/255, alpha: 1.0)


let tradeGreen = UIColor(red: 0/255, green: 164/255, blue: 91/255, alpha: 1)
let tradeRed = UIColor(red: 247/255, green: 85/255, blue: 53/255, alpha: 1)

let myOrange = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1)
let myOrangeLight = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 0.7)

let black = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)

//
let URL_TIMEOUT = 15.0
let REFRESH_INTIVAL = 10.0


let fontName = "AvenirNext-Medium"
let fontNameBold = "AvenirNext-DemiBold"
let fontNameBoldItalic = "AvenirNext-DemiBoldItalic"



//var marketCellID = "marketCell"

let API_BASE_URL = "https://bittrex.com/api/v1.1"
let MARKETS_URL = "\(API_BASE_URL)/public/getmarkets"
let MARKET_SUMMARIES_URL = "\(API_BASE_URL)/public/getmarketsummaries"
let MARKET_SUMMARY_URL = "\(API_BASE_URL)/public/getmarketsummary"
let BTC_TICKER_URL = "\(API_BASE_URL)/public/getticker?market=USDT-BTCA"

let BITTREX_TIMESTAMP_FORMAT = "yyyy-MM-dd'T'HH:mm:s.SSS"


let TABLE_VIEW_PULL_TO_REFRESH_TEXT = "Pull down to refresh"


let BITTREX_TX_FEE = 0.0025


let API_KEY_LENGTH = 32



