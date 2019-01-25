
//
//  AccountViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 6/2/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit


class MyAccountVC: BHViewController {
    
    lazy var accountTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.layer.cornerRadius = 10
        table.layer.masksToBounds = true
        table.isScrollEnabled = false
        return table
    }()
    
    var profileImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "profile"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    

    var apiKeys: APIInfo? = nil {
        didSet {
            DispatchQueue.main.async {
                self.accountTableView.reloadData()
                self.resizeAndAnimateTableView()
            }
        }
    }
    
    let cellId = "cellId"
    var tableViewHeightContraint: NSLayoutConstraint?
    
    struct MenuItem {
        let name: String
    }
    
    
    let publicItems = ["Provide API Keys"]

    let accountItems = [MenuItem(name: "Wallet"),
                        MenuItem(name: "Open Orders"),
                        MenuItem(name: "Order History"),
                        MenuItem(name: "Withdrawal History"),
                        MenuItem(name: "Deposit History"),
                        MenuItem(name: "Favourite Coins")]
    
    
    let logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(functionButtonTapped))
        return button
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Account"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(functionButtonTapped))

        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupView()
    }
    
    
    func setupView() {
        view.addSubview(profileImage)
        
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true

        

        
        accountTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(accountTableView)
        
        accountTableView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 40).isActive = true
        accountTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        accountTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        
        tableViewHeightContraint = accountTableView.heightAnchor.constraint(equalToConstant: 44)
        tableViewHeightContraint?.isActive = true
    }
    
    
    
    @objc func functionButtonTapped() {
        
        
        let alert = UIAlertController(title: "bCoin", message: "Loggin out will require you to re-enter your API keys to access your account. Do you want to continue logging out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action) in
            Helper.removeAPIKeysFromUserDefaults()
            self.checkForAPIKeys()
        }))
        
        present(alert, animated: true)
    }
    
    
    func resizeAndAnimateTableView() {
        tableViewHeightContraint?.constant = apiKeys == nil ? 44 : CGFloat(44 * accountItems.count)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        checkForAPIKeys()
    }

    
    func checkForAPIKeys() {
        if let publicKey = UserDefaults.standard.string(forKey: "publicAPIKey"), let privateKey = UserDefaults.standard.string(forKey: "privateAPIKey")  {
            apiKeys = APIInfo(publicKey: publicKey, privateKey: privateKey)
        } else {
            apiKeys = nil
            self.accountTableView.reloadData()
        }
    }
}




extension MyAccountVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //TODO: - This really needs a clean up
        if apiKeys == nil {
            let dest = APIKeysVC()
            navigationController?.pushViewController(dest, animated: true)
        } else {
            if indexPath.row == 0 {
                let dest = WalletViewController()
                dest.apiKeys = apiKeys
                navigationController?.pushViewController(dest, animated: true)
            } else if indexPath.row == 1 {
                let dest = OpenOrdersViewController()
                dest.apiKeys = apiKeys
                navigationController?.pushViewController(dest, animated: true)
            } else if indexPath.row == 2 {
                let dest = OrderHistoryViewController()
                dest.apiKeys = apiKeys
                navigationController?.pushViewController(dest, animated: true)
            } else if indexPath.row == 3 {
                let dest = WithdrawalsViewController()
                dest.apiKeys = apiKeys
                navigationController?.pushViewController(dest, animated: true)
            } else if indexPath.row == 4 {
                let dest = DepositsViewController()
                dest.apiKeys = apiKeys
                navigationController?.pushViewController(dest, animated: true)
            } else if indexPath.row == 5 {
                let dest = FavouritesViewController()
                navigationController?.pushViewController(dest, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiKeys != nil ? accountItems.count : publicItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .orange
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = .white
        if apiKeys == nil {
            cell.textLabel?.text = publicItems[indexPath.row]
        } else {
            let item = accountItems[indexPath.row]
            cell.textLabel?.text = item.name
        }

        cell.selectionStyle = .none
        return cell
    }

}












