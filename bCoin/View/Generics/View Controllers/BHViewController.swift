//
//  BHViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/25/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class BHViewController: UIViewController {
    
    var headsUpLoadingView: HUDLoadingView = {
        let h = HUDLoadingView()
        h.translatesAutoresizingMaskIntoConstraints = false
        return h
    }()
    
    var notificationBar: NotificationPopUpView = {
        let bar = NotificationPopUpView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}
