//
//  UIViewX.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/28/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    public func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    public func pin(to view: UIView, withPadding padding: CGFloat) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
            ])
    }
    
    func addBorders(edges: [UIRectEdge], color: UIColor, thickness: CGFloat) {
        
        for edge in edges {
            
            let border = UIView()
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(border)
            
            switch edge {
            case .top:
                border.topAnchor.constraint(equalTo: topAnchor).isActive = true
                border.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                border.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            case .bottom:
                border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                border.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                border.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            case .left:
                border.topAnchor.constraint(equalTo: topAnchor).isActive = true
                border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                border.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            case .right:
                border.topAnchor.constraint(equalTo: topAnchor).isActive = true
                border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                border.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            default:
                break
            }
            
        }
    }
    
}
