//
//  BalanceViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/21/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import Foundation
import UIKit

class WalletViewController: GenericTableViewController<WalletCell, AccountCoin> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle = "Wallet"
    }
    
    override func loadData() {
        super.loadData()
        if let api = apiKeys {
            BCoin.getAccountBalances(withAPIDetails: api) { (coins, message) in
                if let balance = coins {
                    self.items = balance
                    self.reloadTableViewOnMainThread()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = GenericTableViewHeader()
        header.headerItems = ["Currency", "Balance", "Available"]
        return header
    }
    
}
