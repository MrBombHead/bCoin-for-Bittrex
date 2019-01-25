//
//  Extensions.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 3/2/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation
import UIKit

class UIButtonRounded: UIButton {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.size.height / 2.0
    }
}


extension UITextField {
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    func addDoneButton() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .blackTranslucent
        
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        toolbar.items = items
        
        self.inputAccessoryView = toolbar
    }
}


extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}

extension DateFormatter {
    
    convenience init(withDateStringFormat format: String) {
        self.init()
        self.dateFormat = format
        self.timeZone = TimeZone(abbreviation: "UTC")
    }
    
    func localTimeForDate() {
        self.timeZone = TimeZone.current
    }
}


extension UIStackView {
    
    convenience init(distribution dis: UIStackViewDistribution, alignment align: UIStackViewAlignment, axis a: UILayoutConstraintAxis) {
        self.init()
        self.distribution = dis
        self.alignment = align
        self.axis = a
        translatesAutoresizingMaskIntoConstraints = false
    }
}



extension UILabel {
    
    
    convenience init(withTextColor color: UIColor = .black,
                     alignment align: NSTextAlignment = .left,
                     fontSize: CGFloat = 16) {
        self.init()
        textColor = color
        textAlignment = align
        font = UIFont(name: fontName, size: fontSize)
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
    }
    
    func flash() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.2
        animation.fromValue = 1.0
        animation.toValue = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = 1
        layer.add(animation, forKey: nil)
    }
}


extension Double {
    
    var abbreviatedString: String {
        get {
            var number = self
            
            if number < 1_000 {
                return number.string(byDecimalPoints: number > 1 ? 2 : 4)
            } else if number < 1_000_000 {
                number = number / 1_000
                return "\(number.string(byDecimalPoints: 2))k"
            } else if number > 1_000_000 {
                number = number / 1_000_000
                return "\(number.string(byDecimalPoints: 2))m"
            }
            return ""
        }
    }
    
    
    func stringWithAutomatedDecimal() -> String {
        if abs(self) > 1 {
            return string(byDecimalPoints: 2)
        } else {
            return string(byDecimalPoints: 8)
        }
    }
    
    func string(byDecimalPoints points: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.minimumFractionDigits = points
        numberFormatter.maximumFractionDigits = points
        
        if let string = numberFormatter.string(from: NSNumber(value: self)) {
            return string
        }
        return "\(self)"
    }
}





extension String {
    
    public func returnSecondsSinceDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        if let date = dateFormatter.date(from: self) {
            if let seconds : Int = Calendar.current.dateComponents([.second], from: date, to: Date()).second {
                
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.unitsStyle = .abbreviated
                
                let formattedString = formatter.string(from: TimeInterval(seconds))!
                return formattedString
            }
        }
        return ""
    }
    
}
