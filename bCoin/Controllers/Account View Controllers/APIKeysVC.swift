//
//  APIKeysViewController.swift
//  BombheadCoin
//
//  Created by Craig Cornwell on 6/5/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit
import SafariServices

class APIKeysVC: BHViewController {
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    
    var textView: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: fontNameBold, size: 14)
        text.textColor = UIColor.black.withAlphaComponent(0.7)
        text.isUserInteractionEnabled = false
        text.text =
        """
        To access your BITTREX information, you are required to provide your API keys.
        
        1. Log into BITTREX
        2. Goto Settings
        3. API Keys
        4. Either copy your existing keys, or create new keys to use.
        """
        return text
    }()
    
    let helpURL = "https://medium.com/engineering-empower/bittrex-retrieve-your-api-key-secret-f65bed380827"

    lazy var publicKeyTextField: APIKeyTextField = {
        let text = APIKeyTextField()
        text.delegate = self
        text.placeholder = "Public API key"
        text.returnKeyType = .next
        return text
    }()
    
    lazy var privateKeyTextField: APIKeyTextField = {
        let text = APIKeyTextField()
        text.delegate = self
        text.placeholder = "Private API key"
        text.returnKeyType = .go
        return text
    }()

    var submitButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(handleSubmitButtonTapped), for: .touchUpInside)
        button.backgroundColor = myOrange
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    var layoutStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addBackgroundColor(UIColor.white.withAlphaComponent(0.1))
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "API Keys"
        setupViews()
    }
    
    let rowPadding: CGFloat = 10
    let rowSpacing: CGFloat = 20
    let rowHeight: CGFloat = 50
    
    func setupViews() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Help", style: .done, target: self, action: #selector(handleHelpButtonPressed))
        
        
        textView.backgroundColor = .white
        
        
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
  
        let views = [publicKeyTextField, privateKeyTextField, submitButton]
        let totalHeight = (rowHeight * CGFloat(views.count)) + (rowSpacing * CGFloat(views.count - 1)) + (rowPadding * CGFloat(views.count - 1))

        views.forEach { (v) in
            layoutStackView.addArrangedSubview(v)
        }

        layoutStackView.spacing = rowSpacing
        layoutStackView.layoutMargins = UIEdgeInsets(top: rowPadding, left: rowPadding, bottom: rowPadding, right: rowPadding)


        view.addSubview(layoutStackView)
        layoutStackView.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        layoutStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        layoutStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        layoutStackView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true

        
        notifications.addObserver(self, selector: #selector(textDidChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
        
        
//
//        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    
    let notifications = NotificationCenter.default
    
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        
    }
    

    
    @objc func handleHelpButtonPressed() {
        
        if let helpURL = URL(string: helpURL) {
            let safariCV = SFSafariViewController(url: helpURL)
            present(safariCV, animated: true)
        }
        
    }
    
    deinit {
        notifications.removeObserver(Notification.Name.UITextFieldTextDidChange)
        notifications.removeObserver(Notification.Name.UIKeyboardWillShow)
        notifications.removeObserver(Notification.Name.UIKeyboardWillHide)
    }
    
    
    func inputIsValid() -> Bool {
        if publicKeyTextField.text?.count == API_KEY_LENGTH && privateKeyTextField.text?.count == API_KEY_LENGTH {
            return true
        }
        return false
    }

    
    @objc func textDidChange(_ textfield: UITextField) {
        if inputIsValid() {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    
    
    func checkAPIDetails(withPublicKey pubKey: String, andPrivateKey privKey: String) {
        let apiInfo = APIInfo(publicKey: pubKey, privateKey: privKey)
        
        BCoin.getAccountBalances(withAPIDetails: apiInfo) { (accCoins, message) in
            if accCoins != nil {
                UserDefaults.standard.set(apiInfo.publicKey, forKey: "publicAPIKey")
                UserDefaults.standard.set(apiInfo.privateKey, forKey: "privateAPIKey")
                
                DispatchQueue.main.async {
                    self.headsUpLoadingView.hide()
                    self.navigationController?.popViewController(animated: true)
                }
            } else if let msg = message {
                DispatchQueue.main.async {
                    self.headsUpLoadingView.hide()
                    self.notificationBar.showNotificationWith(text: msg, forDuration: 3, inView: self.view)
                }
            }
        }
    }
    
    
    @objc func handleSubmitButtonTapped() {
        view.endEditing(true)
        
        guard let pubKey = publicKeyTextField.text, let privKey = privateKeyTextField.text else { return }
        
        headsUpLoadingView.showInView(view)

        checkAPIDetails(withPublicKey: pubKey, andPrivateKey: privKey)
    }
    
}

extension APIKeysVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case publicKeyTextField:
            privateKeyTextField.becomeFirstResponder()
        case privateKeyTextField:
            textField.resignFirstResponder()
            if inputIsValid() {
                handleSubmitButtonTapped()
            }
        default:
            return true
        }
        return false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= API_KEY_LENGTH
    }
}
