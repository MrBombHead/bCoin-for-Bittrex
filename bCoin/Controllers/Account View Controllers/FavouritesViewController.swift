//
//  FavouritesViewController.swift
//  BCoin
//
//  Created by Craig Cornwell on 1/12/19.
//  Copyright © 2019 Craig Cornwell. All rights reserved.
//

import UIKit

class FavouritesViewController: GenericTableViewController<FavouriteCell, String> {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourite Coins"
    }

    override func loadData() {
        if let favCoins = Helper.getFavCoinsFromUserDefaults() {
            items = favCoins
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = GenericTableViewHeader()
        header.headerItems = ["Coin Name"]
        return header
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let coinName = items[indexPath.row]

            Helper.removeCoinFromFavs(coinName)
            
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    
    
    
}
