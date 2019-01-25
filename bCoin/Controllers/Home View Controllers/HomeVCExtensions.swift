//
//  HomeContollerDownload.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 3/16/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

extension HomeVC {

    func loadMarketList() {
        startLoadingUIUpdates()
        BCoin.loadMarkets { (response, errorString) in
            if let dictionary = response {
                self.marketNames = Array(dictionary.keys.sorted())
                self.menuBar.sections = self.marketNames
                self.marketsDictionary = dictionary
                self.reloadCollectionView()
                self.loadLatestMarketPrices()

            } else if let error = errorString {
                self.handleError(withErrorMessage: error)
            }
        }
    }
    
    func loadLatestMarketPrices() {
        startLoadingUIUpdates()

        BCoin.getMarketSummaries { (response, message) in
            if let res = response {
                for (key, values) in self.marketsDictionary {
                    let array = values.map({ (mar) -> Coin in
                        var newMarket = mar
                        newMarket.MarketSummary = res[mar.MarketName]
                        return newMarket
                    })
                    self.marketsDictionary[key] = array
                }
                
                self.lastUpdated = Date()
                self.reloadCollectionView()
                self.stopLoadingUIUpdates()
            } else {
                self.reloadCollectionView()
                self.handleError(withErrorMessage: message!)
            }
            
            
        }

        if !timer.isValid {
            DispatchQueue.main.async {
                self.startTimer()
            }
        }
    }
    
    
    func loadTickers() {
        self.marketNames.forEach({ (market) in
            BCoin.getTicker(forMarket: "USDT-\(market)", completion: { (ticker, message) in
                if let tick = ticker {
                    self.tickerDictionary[market] = tick
                }
            })
        })
    }

    public func handleError(withErrorMessage msg: String) {
        DispatchQueue.main.async {
            self.notificationBar.showNotificationWith(text: msg, forDuration: 5, inView: self.view)
        }
    }
    
    
    
    
}


extension HomeVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText != "" {
                isFiltering = true
                
                for (key, array) in self.marketsDictionary {
                    let newArray = array.filter { (coin) -> Bool in
                        return coin.doesCoinContain(text: searchText)
                    }
                    filteredMarketsDictionary[key] = newArray
                }
            } else {
                isFiltering = false
            }
        }
        reloadCollectionView()
    }
}

extension HomeVC: MenuBarDelegate {
    func scrollToPage(page: Int) {
        let indexPath = IndexPath(item: page, section: 0)
        marketCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

extension HomeVC: MarketTableHeaderDelegate {

    func coinNameSortButtonTapped() {
        coinSortType = .MarketName
        reloadCollectionView()
    }
    
    func percentageSortButtonTapped() {
        coinSortType = .PercentageChange
        reloadCollectionView()
    }
    
    func priceSortButtonTapped() {
        coinSortType = .Last
        reloadCollectionView()
    }
}

extension HomeVC: CoinToggleProtocol {
    func handleCoinToggle() {
        
        if let indexPath = tempSelectedIndexPath {
            print("Preview selected indexpath: \(indexPath)")
            
            reloadCollectionView()
        }
    }
}

extension HomeVC: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let marketID = marketCollectionView.indexPathForItem(at: marketCollectionView.convert(location, from: view)),
            let marketCell = marketCollectionView.cellForItem(at: marketID) as? CryptoMarketsListCell
            else { return nil }
        
        guard let selectedCoinIndex = marketCell.coinsCollectionView.indexPathForItem(at: marketCell.coinsCollectionView.convert(location, from: view)),
            let selectedCoinCell = marketCell.coinsCollectionView.cellForItem(at: selectedCoinIndex) as? CryptoCoinCell
            else { return nil }
        
        
        tempSelectedIndexPath = selectedCoinIndex
        
        let peekView = CryptoDetailsVC()
        peekView.marketCoin = selectedCoinCell.marketCoin!
        peekView.preferredContentSize = CGSize(width: 0, height: 460)
        peekView.delegate = self
        var cellFrameConvertedForView = marketCell.coinsCollectionView.convert(selectedCoinCell.frame, to: view)
        cellFrameConvertedForView.size.height = cellFrameConvertedForView.size.height - 2
        
        previewingContext.sourceRect = cellFrameConvertedForView
        return peekView
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
