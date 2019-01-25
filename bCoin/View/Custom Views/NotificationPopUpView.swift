//
//  NotificationPopUpView.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/6/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class NotificationPopUpView: GenericView {
    
    var height: CGFloat = 50
    var notificationText: String = "Great Notification..." {
        didSet {
            textLabel.text = notificationText
        }
    }
    
    fileprivate var textLabel: UILabel = {
        let label = UILabel(withTextColor: .white, alignment: .center, fontSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    


    func showNotificationWith(text: String, forDuration duration: TimeInterval, inView view: UIView) {
        

        
        alpha = 1
        notificationText = text
        
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
        
        animateNotificationBar(withDuration: duration)
    }
    
    
    func animateNotificationBar(withDuration duration : Double) {
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5,
                       options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        self.transform = CGAffineTransform(translationX: 0, y: -self.height)
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 2, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.textLabel.alpha = 0
                self.transform = CGAffineTransform.identity
            }) { (_) in
                self.textLabel.alpha = 1
                self.removeFromSuperview()
            }
        }
    }
    
    override func setUpView() {
        backgroundColor = .orange
        alpha = 1
        addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
