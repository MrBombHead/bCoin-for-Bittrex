//
//  GenericViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 7/20/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit


class GenericTableViewController<T: BaseTableViewCell<U>,U>: BHViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellID = "cellId"
    var apiKeys: APIInfo?


    var viewTitle: String = "Generic Title" {
        didSet {
            navigationItem.title = viewTitle
        }
    }

    var items = [U]()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.register(T.self, forCellReuseIdentifier: cellID)
        tv.tableFooterView = UIView()
        return tv
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black.withAlphaComponent(0.7)])
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresh
    }()
    
    
    @objc func handleRefresh() {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.refreshControl = refreshControl
        tableView.frame = view.frame
        loadData()
    }
    
    func reloadTableViewOnMainThread() {

        DispatchQueue.main.async {

            self.tableView.reloadData()
            self.headsUpLoadingView.hide()
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func loadData() {
        headsUpLoadingView.showInView(view)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return items.count }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 50 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 33 }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 50 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { }
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return GenericTableViewHeader()
//    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! T
        cell.item = items[indexPath.row]
        return cell
    }
    
    
    lazy var footer: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionFooterHeight))
        label.text = "Loading"
        label.textAlignment = .center
        label.font = UIFont(name: fontNameBold, size: 16)
        return label
    }()
    

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if items.count < 1 {
            footer.text = "No results found"
            return footer
        }
        return UIView(frame: .zero)
    }
}

class FavouriteCell: BaseTableViewCell<String> {
    
    let coinName = UILabel(withTextColor: .black, alignment: .left, fontSize: 14)

    
    override var item: String! {
        didSet {
            coinName.text = item
        }
    }
    
    override func setupView() {
        super.setupView()
        stack.addArrangedSubview(coinName)
    }
}


class WithdrawalCell: BaseTableViewCell<Withdrawal> {
    let exchangeLabel = UILabel(withTextColor: .black, alignment: .left, fontSize: 14)
    let amountLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    let dateLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    
    
    override var item: Withdrawal! {
        didSet {
            exchangeLabel.text = item.Currency
            amountLabel.text = item.Amount.string(byDecimalPoints: 8)
            
            let formatter = DateFormatter(withDateStringFormat: BITTREX_TIMESTAMP_FORMAT)
            
            guard let date = item.Opened else {
                return
            }
            
            if let updatedDate = formatter.date(from: date) {
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "dd-MMM-yy"
                dateLabel.text = "\(formatter.string(from: updatedDate))"
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        stack.addArrangedSubview(exchangeLabel)
        stack.addArrangedSubview(amountLabel)
        stack.addArrangedSubview(dateLabel)
    }
}



class DepositWithdrawalCell: BaseTableViewCell<Deposit> {
    let exchangeLabel = UILabel(withTextColor: .black, alignment: .left, fontSize: 14)
    let amountLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    let dateLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)

    
    override var item: Deposit! {
        didSet {
            exchangeLabel.text = item.Currency
            amountLabel.text = item.Amount.string(byDecimalPoints: 8)

            let formatter = DateFormatter(withDateStringFormat: BITTREX_TIMESTAMP_FORMAT)
            
            if let updatedDate = formatter.date(from: item.LastUpdated) {
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "dd-MMM-yy"
                dateLabel.text = "\(formatter.string(from: updatedDate))"
            }
        }
    }

    override func setupView() {
        super.setupView()
        stack.addArrangedSubview(exchangeLabel)
        stack.addArrangedSubview(amountLabel)
        stack.addArrangedSubview(dateLabel)
    }
}


class HistoricOrderCell: BaseTableViewCell<HistoricOrder> {
    let exchangeLabel = UILabel(withTextColor: .black, alignment: .left, fontSize: 14)
    let typeLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    let qtyLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    let priceLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)

    override var item: HistoricOrder! {
        didSet {
            exchangeLabel.text = item.Exchange
            typeLabel.text = item.OrderType.replacingOccurrences(of: "LIMIT_", with: "", options: String.CompareOptions.literal, range: nil)
            qtyLabel.text = "\(item.Quantity)"
            priceLabel.text = "\(item.Price)"
        }
    }
    override func setupView() {
        super.setupView()
        stack.addArrangedSubview(exchangeLabel)
        stack.addArrangedSubview(typeLabel)
        stack.addArrangedSubview(qtyLabel)
        stack.addArrangedSubview(priceLabel)
    }
}


class OpenOrderCell: BaseTableViewCell<OpenOrder> {
    let exchangeLabel = UILabel(withTextColor: .black, alignment: .left, fontSize: 14)
    let typeLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    let qtyLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    let priceLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    
    override var item: OpenOrder! {
        didSet {
            exchangeLabel.text = item.Exchange
            typeLabel.text = item.OrderType.replacingOccurrences(of: "LIMIT_", with: "", options: String.CompareOptions.literal, range: nil)
            qtyLabel.text = item.Quantity.stringWithAutomatedDecimal()
            priceLabel.text = item.Limit.stringWithAutomatedDecimal()
        }
    }
    
    override func setupView() {
        super.setupView()
        stack.addArrangedSubview(exchangeLabel)
        stack.addArrangedSubview(typeLabel)
        stack.addArrangedSubview(qtyLabel)
        stack.addArrangedSubview(priceLabel)
    }
}





class WalletCell: BaseTableViewCell<AccountCoin> {
    let nameLabel = UILabel(withTextColor: .black, alignment: .left, fontSize: 14)
    let balanceLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    let availableLabel = UILabel(withTextColor: .black, alignment: .right, fontSize: 14)
    
    override var item: AccountCoin! {
        didSet {
            nameLabel.text = item.Currency
            balanceLabel.text = item.balanceString
            availableLabel.text = item.availableString
        }
    }
    
    override func setupView() {
        super.setupView()
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(balanceLabel)
        stack.addArrangedSubview(availableLabel)
    }
}






