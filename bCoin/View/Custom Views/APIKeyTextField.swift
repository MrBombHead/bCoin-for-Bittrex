//
//  APIKeyTextField.swift
//  BCoin
//
//  Created by Craig Cornwell on 1/12/19.
//  Copyright © 2019 Craig Cornwell. All rights reserved.
//

import UIKit

class APIKeyTextField: UITextField {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = .orange
        tintColor = .black
        clearButtonMode = .always
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        leftViewMode = .always
        
        borderStyle = UITextBorderStyle.line
        
        autocapitalizationType = .none
        autocorrectionType = .no
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
