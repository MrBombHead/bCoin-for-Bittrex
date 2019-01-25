//
//  DepositsViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/21/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit


class DepositsViewController: GenericTableViewController<DepositWithdrawalCell, Deposit> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle = "Deposit History"
    }
    
    override func loadData() {
        super.loadData()
        if let api = apiKeys {
            BCoin.loadDepositHistory(forAPIDetails: api) { (deposits) in
                self.items = deposits
                self.reloadTableViewOnMainThread()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = GenericTableViewHeader()
        header.headerItems = ["Currency", "Amount", "Date"]
        return header
    }
}
