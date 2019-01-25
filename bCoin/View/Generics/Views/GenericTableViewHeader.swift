//
//  GenericTableViewHeader.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/4/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation
import UIKit

class GenericTableViewHeader: GenericView {
    
    var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        sv.spacing = 8
        return sv
    }()
    
    var headerItems = [String]() {
        didSet {
            headerItems.forEach { (item) in
                let label = UILabel(withTextColor: .white, alignment: .right, fontSize: 14)
                label.text = item
                stackView.addArrangedSubview(label)
            }            
            let label = stackView.arrangedSubviews[0] as! UILabel
            label.textAlignment = .left
        }
    }

    override func setUpView() {
        super.setUpView()
        backgroundColor = .orange
        addSubview(stackView)
        stackView.pin(to: self)
    }

}
