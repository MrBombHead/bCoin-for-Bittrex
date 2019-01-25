//
//  HUDLoadingView.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 6/7/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class HUDLoadingView: GenericView {
    
//    deinit {
//        print("HUDLoadingView DEINIT")
//    }
    
    override func setUpView() {
        let stack = UIStackView(distribution: .fillEqually, alignment: .fill, axis: .vertical)
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        let label = UILabel(withTextColor: .orange, alignment: .center, fontSize: 16)
        
        backgroundColor = .black
        activity.startAnimating()
        label.text = "Loading..."
        
        stack.addArrangedSubview(activity)
        stack.addArrangedSubview(label)
        
        addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        layer.cornerRadius = 10
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 6

        
        
    }
    
    func showInView(_ view: UIView) {
        if !view.subviews.contains(self) {
            view.addSubview(self)
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.widthAnchor.constraint(equalToConstant: 120).isActive = true
            self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
    }

    
    func hide() {
        UIView.animate(withDuration: 0.4, animations: {
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.alpha = 0
        }) { (_) in
            self.transform = CGAffineTransform.identity
            self.alpha = 1
            self.removeFromSuperview()
        }
    }


}
