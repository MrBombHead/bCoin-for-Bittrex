//
//  WithdrawalsViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/21/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit


class WithdrawalsViewController: GenericTableViewController<WithdrawalCell, Withdrawal> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle = "Withdrawal History"
    }
    
    override func loadData() {
        super.loadData()
        if let api = apiKeys {
            BCoin.loadWithdrawalHistory(forAPIDetails: api) { (withdrawals) in
                self.items = withdrawals
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
