//
//  MenuCellCollectionViewCell.swift
//  CodedViews
//
//  Created by Craig Cornwell on 3/10/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class MenuCell: BaseCollectionViewCell {
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Text..."
        label.textAlignment = .center
        label.font = UIFont(name: fontName, size: 18)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectedColor = UIColor.orange
    let notSelectedColor = UIColor.white
    
    override var isHighlighted: Bool {
        didSet {
            textLabel.textColor = isHighlighted ? selectedColor : notSelectedColor
        }
    }
    override var isSelected: Bool {
        didSet {
            textLabel.textColor = isSelected ? selectedColor : notSelectedColor
        }
    }

    override func setupViews() {
        super.setupViews()
        addSubview(textLabel)
        textLabel.pin(to: self)
    }

}
