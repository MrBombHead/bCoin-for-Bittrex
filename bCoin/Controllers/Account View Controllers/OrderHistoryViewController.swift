//
//  OrderHistoryViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/21/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit



class OrderHistoryViewController: GenericTableViewController<HistoricOrderCell, HistoricOrder> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle = "Order History"
    }
    
    override func loadData() {
        super.loadData()
        if let api = apiKeys {
            BCoin.loadOrderHistory(forAPIDetails: api) { (orders) in
                self.items = orders
                self.reloadTableViewOnMainThread()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = GenericTableViewHeader()
        header.headerItems = ["Currency", "Type", "Amount", "Price"]
        return header
    }
}
