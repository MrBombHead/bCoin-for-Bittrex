//
//  DoubleLabel.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/7/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class DoubleLabel: GenericView {
    
    var bigTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .orange
        label.text = "6,651.15"
        label.font = UIFont(name: fontNameBold, size: 34)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        return label
    }()
    
    var smallTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = UIColor.black.withAlphaComponent(0.8)
        label.text = "Current rate US$"
        label.font = UIFont(name: fontNameBoldItalic, size: 14)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        return label
    }()
    
    var textAlignment: NSTextAlignment = NSTextAlignment.left {
        didSet {
            bigTextLabel.textAlignment = textAlignment
            smallTextLabel.textAlignment = textAlignment
        }
    }
    
    var text: String = "" {
        didSet {
            bigTextLabel.text = text
        }
    }
    
    var subText: String = "" {
        didSet {
            smallTextLabel.text = subText
        }
    }

    override func setUpView() {
        backgroundColor = .clear
        
        addSubview(bigTextLabel)
        addSubview(smallTextLabel)
        
        bigTextLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bigTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        bigTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        bigTextLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        
        smallTextLabel.topAnchor.constraint(equalTo: bigTextLabel.bottomAnchor, constant: -5).isActive = true
        smallTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        smallTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        smallTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    convenience init(withLargeText largeText: String, andSmallText smallText: String) {
        self.init(frame: .zero)
        self.text = largeText
        self.subText = smallText
        self.bigTextLabel.text = self.text
        self.smallTextLabel.text = self.subText
    }

}

