//
//  CoinCell.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 3/16/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class CryptoCoinCell: BaseCollectionViewCell {
    
    var marketNameLabel = UILabel(withTextColor: .black, alignment: .left, fontSize: 12)
    var lastLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 12)
    var lastUSDLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 12)
    var percentageLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 12)
    
    
    var marketCoin: Coin? = nil {
        didSet {
            populateCell()
        }
    }
    
    var ticker: Ticker? = nil {
        didSet {
            if ticker != nil {
                self.lastUSDLabel.isHidden = false
                populateCell()
            } else {
                lastUSDLabel.isHidden = true
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        addBorders(edges: [.bottom], color: UIColor.black.withAlphaComponent(0.1), thickness: 1)

        addSubview(percentageLabel)
        percentageLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        percentageLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        percentageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        percentageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true

        addSubview(lastLabel)
        lastLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lastLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lastLabel.trailingAnchor.constraint(equalTo: percentageLabel.leadingAnchor, constant: -8).isActive = true
        lastLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true

        addSubview(marketNameLabel)
        marketNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        marketNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        marketNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        marketNameLabel.trailingAnchor.constraint(equalTo: lastLabel.leadingAnchor, constant: -8).isActive = true
    }
    
    func setLabelColor(color: UIColor) {
        lastLabel.textColor = color
        percentageLabel.textColor = color
    }
    
    func populateCell() {
        if let coin = marketCoin {
            marketNameLabel.text = "\(coin.MarketCurrencyLong) (\(coin.MarketCurrency))"
            
            if coin.isInFavourites {
                backgroundColor = UIColor.orange.withAlphaComponent(0.15)
            } else {
                backgroundColor = .white
            }
            
            if let x = coin.MarketSummary {
                lastLabel.text = x.lastString
                percentageLabel.text = x.differencePercentageString
                setLabelColor(color: x.differencePercentage > 0 ? myGreen : myRed)
                
                if let tick = ticker {
                    lastUSDLabel.text = "~USD \((x.Last * tick.Last).string(byDecimalPoints: 2))"
                }
            }
        }
    }

}
