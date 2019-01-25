//
//  BHTextField.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/28/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation
import UIKit

class BHTextField: UITextField {
    
    var labelText: String? {
        didSet {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 60))
            label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            label.textColor = .white
            label.text = labelText
            label.textAlignment = .center
            label.font = UIFont(name: fontName, size: 18)
            rightView = label
            rightViewMode = .always
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    convenience init(withPlaceholder placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
//        setupTextField()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }

    func setupTextField() {
        borderStyle = .none
        tintColor = .white
        textColor = .orange
        backgroundColor = .white
        layer.borderColor = (UIColor.black.withAlphaComponent(0.3)).cgColor
        layer.borderWidth = 1
        
        
        font = UIFont.boldSystemFont(ofSize: 16)
        autocorrectionType = .no
        autocapitalizationType = .none
        clearButtonMode = .whileEditing
        clipsToBounds = true
        
        
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 4
        

        let placeholder = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont = UIFont(name: fontName, size: 16)!
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor : UIColor.black.withAlphaComponent(0.3),
            .font : placeholderFont])

        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        leftViewMode = .always

    }
    

}
