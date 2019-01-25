//
//  CoinInfoViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 5/25/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit
import CommonCrypto


protocol CoinToggleProtocol {
    func handleCoinToggle()
}

class CryptoDetailsVC: BHViewController {
    
    let coinName = DoubleLabel(withLargeText: "BTC", andSmallText: "USDT-BTC")
    let percentageChangeLabel = UILabel(withTextColor: myGreen, alignment: .right, fontSize: 20)
    
    let currentRateLabel = DoubleLabel(withLargeText: "0000.00", andSmallText: "Last price in X")
    let baseVolumeLabel = DoubleLabel(withLargeText: "0000.00", andSmallText: "Volume 24hr in X")
    let volumeLabel = DoubleLabel(withLargeText: "0000.00", andSmallText: "Volume 24hr in X")
    
    let lastUpdatedLabel = DoubleLabel(withLargeText: "", andSmallText: "")
    let highDoubleLabel = DoubleLabel(withLargeText: "0000.00", andSmallText: "Last updated")
    let lowDoubleLabel = DoubleLabel(withLargeText: "0000.00", andSmallText: "Last updated")
    
    var balanceLabel: DoubleLabel = {
        let label = DoubleLabel(withLargeText: "...", andSmallText: "Wallet Balance")
        label.textAlignment = .right
        return label
    }()
    
//    var coinImage: UIImageView = {
//        let img = UIImageView()
//        return img
//    }()
    
    var delegate: CoinToggleProtocol?
    
    var tradeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Trade", for: .normal)
        button.backgroundColor = tradeGreen
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showTraderView), for: .touchUpInside)
        return button
    }()
    
    var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    var mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var favButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "fav_image"),
                                     style: UIBarButtonItemStyle.plain,
                                     target: self,
                                     action: #selector(handleFav))
        return button
    }()
    
    lazy var previewActions: [UIPreviewActionItem] = {
        var buttonTitle = "Set as favourite"
        var buttonStyle = UIPreviewAction.Style.default
        
        if marketCoin.isInFavourites {
            buttonTitle = "Remove favourite"
            buttonStyle = .destructive
        }
        
        let actionFav = UIPreviewAction(title: buttonTitle, style: buttonStyle, handler: { (previewAction, viewController) in
            guard let view = viewController as? CryptoDetailsVC else { return }
            view.toggleFav()
        })
        
        return [actionFav]
    }()
    
    var marketCoin: Coin!

    override var previewActionItems : [UIPreviewActionItem] { return previewActions }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewLayout()
        loadBalance()
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleRefresh))
        
        navigationItem.rightBarButtonItems = [refresh, favButton]
        
        populateCoinData()
//        loadImage()
    }
    
    
    @objc func handleFav() {
        toggleFav()
    }
    
    func toggleFav() {
        if marketCoin.isInFavourites {
            Helper.removeCoinFromFavs(marketCoin.MarketCurrency)
        } else {
            Helper.addCoinToFavCoins(marketCoin.MarketCurrency)
        }
        toggleFavButtonImage()
        delegate?.handleCoinToggle()
    }
    
    func toggleFavButtonImage() {
        if marketCoin.isInFavourites {
            let img = UIImage(named: "fav_set")
            favButton.image = img
        } else {
            let img = UIImage(named: "fav_false")
            favButton.image = img
        }
    }
    
    //MARK: View Setup
    func setupViewLayout() {
        
        view.addSubview(titleView)
        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        titleView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15).isActive = true
        
        view.addSubview(mainContainerView)
        mainContainerView.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        mainContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mainContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        setupTitleView()
        setupMainView()
    }
    
    func setupTitleView() {
        
        let titleStack = UIStackView(distribution: .fillEqually, alignment: .center, axis: .horizontal)
        let percentageInfoStack = UIStackView(distribution: .fillEqually, alignment: .fill, axis: .vertical)
        
        let percentageDescriptionLabel = UILabel(withTextColor: .orange, alignment: .right, fontSize: 12)
        percentageDescriptionLabel.text = "change in day US$"
        
        titleView.addSubview(titleStack)
        titleStack.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        titleStack.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 16).isActive = true
        titleStack.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -8).isActive = true
        titleStack.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        
        percentageInfoStack.addArrangedSubview(percentageChangeLabel)
        percentageInfoStack.addArrangedSubview(percentageDescriptionLabel)
        
        titleStack.addArrangedSubview(coinName)
        titleStack.addArrangedSubview(percentageInfoStack)
    }
    
    func setupMainView() {
        let stack = UIStackView(distribution: .equalSpacing, alignment: .fill, axis: .vertical)
        stack.spacing = 10
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stack.addBorders(edges: [.top], color: .orange, thickness: 1)
        stack.addBackgroundColor(.yellow)
        mainContainerView.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: mainContainerView.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor).isActive = true
        
        let tempStack = UIStackView()
        tempStack.axis = .horizontal
        tempStack.distribution = .fillEqually
        tempStack.addArrangedSubview(currentRateLabel)
        tempStack.addArrangedSubview(balanceLabel)
        
        stack.addArrangedSubview(tempStack)
        stack.addArrangedSubview(volumeLabel)
        stack.addArrangedSubview(baseVolumeLabel)
        stack.addArrangedSubview(lastUpdatedLabel)
        
        mainContainerView.addSubview(tradeButton)
        tradeButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 8).isActive = true
        tradeButton.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: 8).isActive = true
        tradeButton.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -8).isActive = true
        tradeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func loadImage() {
        if let urlString = marketCoin.LogoUrl {
            if let url = URL(string: urlString) {
                DispatchQueue.main.async {
                    if let data = try? Data(contentsOf: url) {
                        print(data)
                        if let image = UIImage(data: data) {
                            print(image)
//                            self.coinImage.image = image
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    @objc func handleRefresh() {
        reloadCoinInfo()
    }
    
    @objc func showTraderView() {
        let dest = CryptoTraderVC()
        dest.marketCoin = self.marketCoin
        navigationController?.pushViewController(dest, animated: true)
    }
    
    
    func reloadCoinInfo() {
        headsUpLoadingView.showInView(view)
        
        BCoin.getMarketSummary(forMarket: marketCoin.MarketName) { (coinDetails, error) in
            if let details = coinDetails {
                self.marketCoin.MarketSummary = details
            } else {
                print("An error has occured: \(error!)")
            }
            DispatchQueue.main.async {
                self.headsUpLoadingView.hide()
                self.populateCoinData()
            }
        }
    }
    
    
    
    func loadBalance() {
        if let api = Helper.getAPIKeysFromUserDefaults() {
            
            tradeButton.isHidden = false
            
            BCoin.getAccountBalance(forCurrency: marketCoin.MarketCurrency, withAPIDetails: api) { (coin, message) in
                if let c = coin {
                    DispatchQueue.main.async {
                        self.balanceLabel.text = c.balanceString
                    }
                }
            }
        } else {
            tradeButton.isHidden = true
        }
    }
    
    
    
    
    
    
    func populateCoinData() {
        if let coinInfo = marketCoin.MarketSummary {
            
            toggleFavButtonImage()
            
            navigationItem.title = marketCoin.MarketCurrencyLong
            
            coinName.text = marketCoin.MarketCurrency
            coinName.subText = marketCoin.MarketName
            coinName.smallTextLabel.textColor = .white
            
            percentageChangeLabel.text = "\(coinInfo.differenceValue > 0 ? "+" : "")\(coinInfo.differenceValueString) (\(coinInfo.differencePercentageString))"
            percentageChangeLabel.textColor = coinInfo.differencePercentage > 0 ? myGreen : myRed
            
            currentRateLabel.text = coinInfo.lastString
            currentRateLabel.subText = "Latest price in \(marketCoin.BaseCurrency)"
            
            volumeLabel.text = coinInfo.Volume.abbreviatedString
            volumeLabel.subText = "24hr volume in \(marketCoin.MarketCurrency)"
            
            baseVolumeLabel.text = coinInfo.BaseVolume.abbreviatedString
            baseVolumeLabel.subText = "24hr volume in \(marketCoin.BaseCurrency)"
            
            let formatter = DateFormatter(withDateStringFormat: BITTREX_TIMESTAMP_FORMAT)
            
            if let updatedDate = formatter.date(from: coinInfo.TimeStamp) {
                
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "HH:mm:ss"
                
                lastUpdatedLabel.subText = "Last Updated: \(formatter.string(from: updatedDate))"
            } else {
                lastUpdatedLabel.text = "..."
            }
        } else {
            print("CoinInfo not loaded")
            reloadCoinInfo()
        }
    }
    
}
