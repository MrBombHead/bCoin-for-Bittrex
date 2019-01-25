//
//  UIStackViewX.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/28/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation
import UIKit



extension UIStackView {
    
    func addBackgroundColor(_ color: UIColor) {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = color
        insertSubview(backgroundView, at: 0)
        backgroundView.pin(to: self)
    }
    
    
    
}
