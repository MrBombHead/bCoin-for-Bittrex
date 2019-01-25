//
//  GenericView.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/24/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class GenericView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() { }
}
