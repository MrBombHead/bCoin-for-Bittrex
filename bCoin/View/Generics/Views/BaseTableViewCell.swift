//
//  BaseTableViewCells.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/21/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit


class BaseTableViewCell<U>: UITableViewCell {
    var item: U!
    
    var stack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.distribution = .fillEqually
        s.isLayoutMarginsRelativeArrangement = true
        s.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        s.spacing = 8
        return s
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(stack)
        stack.pin(to: self)
    }
}
