//
//  File.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 8/21/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit


class OpenOrdersViewController: GenericTableViewController<OpenOrderCell, OpenOrder> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle = "Open Orders"
    }
    
    override func loadData() {
        super.loadData()
        if let api = apiKeys {
            BCoin.loadOpenOrders(forAPIDetails: api) { (orders, message)  in
                if let ords = orders {
                    self.items = ords
                    self.reloadTableViewOnMainThread()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = GenericTableViewHeader()
        header.headerItems = ["Currency", "Type", "Amount", "Price"]
        return header
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let api = apiKeys else { return }
            
            headsUpLoadingView.showInView(view)
            
            let item = items[indexPath.row]
            
            BCoin.cancelOrder(forOrderID: item.OrderUuid, withAPIDetails: api) { (response) in
                if response.success {
                    self.items.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                DispatchQueue.main.async {
                    self.headsUpLoadingView.hide()
                }
            }
        }
    }
}
