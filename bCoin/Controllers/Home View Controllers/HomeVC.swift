//
//  HomeController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 3/16/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class HomeVC: BHViewController {
    
    lazy var marketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
        cv.backgroundColor = .white
        cv.register(CryptoMarketsListCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.definesPresentationContext = true
        search.searchBar.placeholder = "Search coins"
        search.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        return search
    }()
    
    lazy var menuBar: MenuBar = {
        let menuBar = MenuBar()
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.delegate = self
        menuBar.sections = ["Loading data"]
        return menuBar
    }()
    
    lazy var header: MarketTableHeader = {
        let h = MarketTableHeader()
        h.delegate = self
        return h
    }()
    
    var coinSortType = CoinSortType.MarketName
    let cellId = "cellId"
    var timer = Timer()
    var marketNames: [String] = []
    var marketsDictionary = [String : [Coin]]()
    var filteredMarketsDictionary = [String : [Coin]]()
    var marketSummaryDictionary = [String : CoinDetails]()
    var searchFilteredMarketArray: [Coin] = []
    var isFiltering = false
    var lastUpdated: Date?
    
    var tempSelectedIndexPath: IndexPath?

    var tickerDictionary = [String : Ticker]() {
        didSet {
            print("Ticker loaded")
        }
    }

    //MARK: - View setup and updates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        loadMarketList()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLastUpdatedTime()
    }
    
    func setupNavigationBar() {

        navigationItem.title = "Home"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Account", style: .done, target: self, action: #selector(accountButtonTapped))
        
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.orange, NSAttributedStringKey.font:UIFont(name: fontName, size: 22)!]
        
        let largeTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.orange, NSAttributedStringKey.font:UIFont(name: fontName, size: 30)!]
        
        
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = largeTextAttributes
        

        

    }
    

    
    func setupViews() {
        
        view.addSubview(menuBar)
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(header)
        header.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        header.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        
        
//        let toolbar = UIView()
//        toolbar.translatesAutoresizingMaskIntoConstraints = false
//        toolbar.backgroundColor = .white
//        toolbar.addBorders(edges: [.top], color: .orange, thickness: 1)
//
//        view.addSubview(toolbar)
//        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        toolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
//
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        if let image = UIImage(named: "more") {
//            button.setImage(image, for: .normal)
//        }
//
//
//        toolbar.addSubview(button)
//        button.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 8).isActive = true
//        button.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        
        
        
 
        view.addSubview(marketCollectionView)
        marketCollectionView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        marketCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        marketCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        marketCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        
        
        
        
        
        
        
    }
    
    func checkLastUpdatedTime() {
        guard let updated = lastUpdated else { return }
        
        if let seconds = Calendar.current.dateComponents([.second], from: updated, to: Date()).second {
            if seconds > 20 {
                loadLatestMarketPrices()
            } else {
                startTimer()
            }
        }
    }

    @objc func accountButtonTapped() {
        let destVC = MyAccountVC()
        navigationController?.pushViewController(destVC, animated: true)
    }

    func sortMarketDictionary() {
        if isFiltering {
            filteredMarketsDictionary = sortDictionary(filteredMarketsDictionary, bySortType: coinSortType)
        } else {
            marketsDictionary = sortDictionary(marketsDictionary, bySortType: coinSortType)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.updateHorizontalBar(withNewLocation: scrollView.contentOffset.x)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let menuPosition = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(menuPosition), section: 0)
        menuBar.selectItem(at: indexPath)
    }
    
    func startLoadingUIUpdates() {
        DispatchQueue.main.async {
            self.headsUpLoadingView.showInView(self.view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func stopLoadingUIUpdates() {
        DispatchQueue.main.async {
            self.headsUpLoadingView.hide()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: REFRESH_INTIVAL, repeats: true) { (timer) in
            self.loadLatestMarketPrices()
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.sortMarketDictionary()
            self.marketCollectionView.reloadData()
        }
    }
    
    func returnArrayForCurrencyPair(section: Int) -> [Coin] {
        let market = marketNames[section]
        if let array = isFiltering ? filteredMarketsDictionary[market] : marketsDictionary[market] {
            return array
        }
        return [Coin]()
    }

}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marketNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CryptoMarketsListCell
        cell.marketsArray = returnArrayForCurrencyPair(section: indexPath.item)
        cell.marketTicker = tickerDictionary[marketNames[indexPath.item]]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
