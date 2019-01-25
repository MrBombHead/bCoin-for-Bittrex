//
//  TraderViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/17/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

class CryptoTraderVC: BHViewController {
    
    var priceView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addBorders(edges: [.bottom], color: .orange, thickness: 1)
        return view
    }()
    
    var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var buySellStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Buy", for: .normal)
        button.backgroundColor = tradeGreen
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleBuyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var sellButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sell", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(handleSellButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var tradeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Place order", for: .normal)
        button.backgroundColor = tradeGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTradeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var quantityTextField: BHTextField = {
        let text = BHTextField(withPlaceholder: "Quantity")
        text.delegate = self
        text.addTarget(self, action: #selector(recalculateTotal), for: .editingChanged)
        text.keyboardAppearance = UIKeyboardAppearance.dark
        text.keyboardType = .decimalPad
        return text
    }()
    
    lazy var priceTextField: BHTextField = {
        let text = BHTextField(withPlaceholder: "Price")
        text.delegate = self
        text.addTarget(self, action: #selector(recalculateTotal), for: .editingChanged)
        text.keyboardAppearance = UIKeyboardAppearance.dark
        text.keyboardType = .decimalPad
        return text
    }()
    
    var totalCostField: BHTextField = {
        let label = BHTextField(withPlaceholder: "Total")
        label.isUserInteractionEnabled = false
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        return label
    }()
    
    var bidLabel: DoubleLabel = {
        let label = DoubleLabel()
        label.textAlignment = .center
        label.text = "0.0"
        label.subText = "Bid"
        label.smallTextLabel.textColor = .white
        return label
    }()
    
    var lastLabel: DoubleLabel = {
        let label = DoubleLabel()
        label.textAlignment = .center
        label.text = "0.0"
        label.subText = "Last"
        label.smallTextLabel.textColor = .white
        return label
    }()
    
    var askLabel: DoubleLabel = {
        let label = DoubleLabel()
        label.textAlignment = .center
        label.text = "0.0"
        label.subText = "Ask"
        label.smallTextLabel.textColor = .white
        return label
    }()

    
    var tradeMode: TradeType = .Buy {
        didSet {
            toggleButtons()
        }
    }
    
    var marketCoin: Coin? {
        didSet {
            populateInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleRefresh))
                
        setupView()
        
//        setupPriceView()
        setupMainView()
        loadBalances()
    }
    
    
    func setupView() {
        view.addSubview(mainView)
        mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupPriceView() {
        let stack = UIStackView(arrangedSubviews: [bidLabel, lastLabel, askLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        
        priceView.addSubview(stack)
        stack.pin(to: priceView)
    }
    
    func setupMainView() {

        let rowHeight: CGFloat = 55
        let spacing: CGFloat = 8
        let padding: CGFloat = 8
        

        
        let views = [buySellStackView, quantityTextField, priceTextField, totalCostField, tradeButton]
        
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        }

        let stack = UIStackView(arrangedSubviews: views)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = spacing
        
        
        mainView.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        
        let height = (CGFloat(views.count) * rowHeight) + (padding * 2) + (spacing * (CGFloat(views.count) - 1))
        
        
        
        stack.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
        
        
        
        buySellStackView.addArrangedSubview(buyButton)
        buySellStackView.addArrangedSubview(sellButton)
        

        if let coin = marketCoin {
            quantityTextField.labelText = coin.MarketCurrency
            priceTextField.labelText = coin.BaseCurrency
            totalCostField.labelText = coin.BaseCurrency
        }
    }
    
    
    
    
    
    fileprivate func toggleButtons() {
        let lightBlack = UIColor.black.withAlphaComponent(0.5)
        buyButton.backgroundColor = tradeMode == .Buy ? tradeGreen : lightBlack
        sellButton.backgroundColor = tradeMode == .Buy ? lightBlack : tradeRed
        tradeButton.backgroundColor = tradeMode == .Buy ? tradeGreen : tradeRed
    }
    
    
    fileprivate func placeOrder() {
        
        
        
    }
    
    
    
    @objc func handleTradeButtonTapped() {
        view.endEditing(true)
        
        
        
        
        
        
        
        
        
        guard let apiInfo = Helper.getAPIKeysFromUserDefaults() else {
            notificationBar.showNotificationWith(text: "API Details missing", forDuration: 3, inView: view)
            return
        }
        guard let quantity = quantityTextField.text, let bidPrice = priceTextField.text else { print("Issue with price or quantity") ; return }
        
        guard let coin = marketCoin else { return }
        
        
        headsUpLoadingView.showInView(view)
        
        if let qty = Double(quantity), let price = Double(bidPrice) {
            
            let trade = Trade(market: coin.MarketName,
                              quantity: qty,
                              rate: price,
                              api: apiInfo,
                              tradeType: tradeMode)
            
            BCoin.placeTradeOrder(withTradeDetails: trade) { (success, message) in
                DispatchQueue.main.async {
                    self.headsUpLoadingView.hide()
                    self.notificationBar.showNotificationWith(text: success ? "Successful" : message, forDuration: 3, inView: self.view)

                    if success {
                        self.resetTradeForm()
                    }
                }
                
            }

        }
    }
    
    

    @objc func handleSellButtonTapped() {
        tradeMode = .Sell
        recalculateTotal()
    }
    
    @objc func handleBuyButtonTapped() {
        tradeMode = .Buy
        recalculateTotal()
    }
    
    
    
    
    
    @objc func handleRefresh() {
        guard let coin = marketCoin else {return}
        
        headsUpLoadingView.showInView(view)
        
        BCoin.getMarketSummary(forMarket: coin.MarketName) { (coinDetails, message) in
            if let coinInfo = coinDetails {
                self.marketCoin?.MarketSummary = coinInfo
            }
            DispatchQueue.main.async {
                self.headsUpLoadingView.hide()
            }
        }
        loadBalances()
    }
    
    
    
    
    
    func populateInfo() {
        if let coin = marketCoin, let coinDetails = coin.MarketSummary {
            DispatchQueue.main.async {
                self.navigationItem.title = coin.MarketName
                self.bidLabel.text = coinDetails.bidString
                self.lastLabel.text = coinDetails.lastString
                self.askLabel.text = coinDetails.askString
            }
        }
    }
    
    var baseCurrencyBalance: AccountCoin?
    var marketCurrencyBalance: AccountCoin?
    
    
    func loadBalances() {
        
        guard let coin = marketCoin, let api = Helper.getAPIKeysFromUserDefaults() else { return }
        
        
        BCoin.getAccountBalance(forCurrency: coin.BaseCurrency,
                                withAPIDetails: api) { (response, message) in
            if let res = response {
                self.baseCurrencyBalance = res
            }
        }
        
        BCoin.getAccountBalance(forCurrency: coin.MarketCurrency,
                                withAPIDetails: api) { (response, message) in
            if let res = response {
                self.marketCurrencyBalance = res
            }
        }
        
        
    }
    
    
    
    
    
    func resetTradeForm() {
        priceTextField.text = ""
        quantityTextField.text = ""
        totalCostField.text = "0.0"
    }
    
    
    @objc func recalculateTotal() {
        guard let quantity = quantityTextField.text, let bidPrice = priceTextField.text else {
            print("Issue with price or quantity")
            return
        }
        if let qty = Double(quantity), let price = Double(bidPrice) {
            let total = qty * price
            let commision = total * BITTREX_TX_FEE
            let totalWithCommision = tradeMode == .Buy ? total + commision : total - commision

            totalCostField.text = "\(totalWithCommision.string(byDecimalPoints: 8))"
        }
    }
}

extension CryptoTraderVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
