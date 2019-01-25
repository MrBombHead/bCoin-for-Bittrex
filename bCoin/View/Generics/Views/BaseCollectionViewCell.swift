//
//  BaseCell.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 6/30/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() { }
}
