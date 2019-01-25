//
//  MarketTableHeader.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 2/24/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit


protocol MarketTableHeaderDelegate {
    func coinNameSortButtonTapped()
    func priceSortButtonTapped()
    func percentageSortButtonTapped()
}

class MarketTableHeader: GenericView {
    
    var delegate: MarketTableHeaderDelegate?
    
    let coinNameLabel: UILabel = {
        let label = UILabel(withTextColor: .white, alignment: .left)
        label.text = "Coin Name (Code)"
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: fontNameBold, size: 15)
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel(withTextColor: .white, alignment: .right)
        label.text = "Last Price"
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: fontNameBold, size: 15)
        return label
    }()
    
    let percentageLabel: UILabel = {
        let label = UILabel(withTextColor: .white, alignment: .right)
        label.text = "24h"
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: fontNameBold, size: 15)
        return label
    }()

    override func setUpView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .orange
        
        addSubview(percentageLabel)
        percentageLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        percentageLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        percentageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        percentageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
        
        addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: percentageLabel.leadingAnchor, constant: -8).isActive = true
        priceLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        
        addSubview(coinNameLabel)
        coinNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        coinNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        coinNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        coinNameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8).isActive = true
        

        coinNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCoinSort)))
        priceLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePriceSort)))
        percentageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePercentageSort)))
    }
    
    @objc func handlePriceSort() {
        delegate?.priceSortButtonTapped()
    }
    @objc func handlePercentageSort() {
        delegate?.percentageSortButtonTapped()
    }
    @objc func handleCoinSort() {
        delegate?.coinNameSortButtonTapped()
    }
}


