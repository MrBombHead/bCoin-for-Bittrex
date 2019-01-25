//
//  MarketListCell.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 3/16/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class CryptoMarketsListCell: BaseCollectionViewCell {
    
    let cellId = "marketListID"
    var delegate: UIViewController?
    
    var marketsArray: [Coin]? = nil {
        didSet {
            coinsCollectionView.reloadData()
        }
    }
    
    var marketTicker: Ticker? = nil {
        didSet {
            if let ticker = marketTicker {
                print("Ticker Loaded: \(ticker)")
            }
        }
    }

    lazy var coinsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.bounces = false
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
                
        coinsCollectionView.register(CryptoCoinCell.self, forCellWithReuseIdentifier: cellId)
        coinsCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")

        addSubview(coinsCollectionView)
        coinsCollectionView.pin(to: self)
    }

}

extension CryptoMarketsListCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let testVC = CryptoDetailsVC()

        if let coins = marketsArray {
            testVC.marketCoin = coins[indexPath.item]
        }
        delegate?.navigationController?.pushViewController(testVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = marketsArray?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CryptoCoinCell
        cell.marketCoin = marketsArray?[indexPath.item]
        cell.ticker = marketTicker
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    

}


extension CryptoMarketsListCell: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = coinsCollectionView.indexPathForItem(at: coinsCollectionView.convert(location, from: self)), let cell = coinsCollectionView.cellForItem(at: indexPath) else { return nil}
        
        let peekView = CryptoDetailsVC()
        peekView.preferredContentSize = CGSize(width: 0, height: 340)
        previewingContext.sourceRect = coinsCollectionView.convert(cell.frame, to: self.superview!)
        return peekView
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        delegate?.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}




