//
//  ProfileViewController.swift
//  TJournalGifv
//
//  Created by christina on 01.05.2020.
//  Copyright © 2020 zombewnew. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let scannerVC = QrScannerController()
    var dataManager = RequestManager()
    var userData: UserModel? = nil
    var keyExist: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if keyExist {
            checkAuth()
            //хранить токен в обычной переменной нельзя, как я поняла, условно на дальнейший разработку создана загрузка переменной из KeyChain class
        }
        
        dataManager.delegateAuth = self
        addAuthInterface()
    }
    
    
   //MARK: - Creating Interface
    
    private lazy var qrButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "qrcode"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = UIColor(named: "tg-color")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openScanner), for: .touchUpInside)
        return button
    }()
    
    private lazy var authLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Авторизоваться через QR-код:"
        label.textColor = UIColor(named: "tg-color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Неверный QR-код, попробуйте еще раз!"
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var quitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(UIColor(named: "tg-color"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitProfile), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "name"
        label.textColor = UIColor(named: "tg-color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var userAvatar: UIImageView = {
        let image = UIImageView(image: UIImage(named: "profile"))
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var сonstraintsAuthView: [NSLayoutConstraint] = [
        qrButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        qrButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        qrButton.heightAnchor.constraint(equalToConstant: 44),
        qrButton.widthAnchor.constraint(equalTo: qrButton.heightAnchor, multiplier: 1/1),
        
        authLabel.bottomAnchor.constraint(equalTo: qrButton.topAnchor, constant: -16),
        authLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
    ]
    
    lazy var сonstraintsProfileView: [NSLayoutConstraint] = [
        quitButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        quitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        
        userAvatar.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        userAvatar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        userAvatar.heightAnchor.constraint(equalToConstant: 44),
        userAvatar.widthAnchor.constraint(equalTo: userAvatar.heightAnchor, multiplier: 1/1),
        
        nameLabel.bottomAnchor.constraint(equalTo: userAvatar.topAnchor, constant: -16),
        nameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
    ]
    
    lazy var сonstraintsErrorView: [NSLayoutConstraint] = [
        errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        errorLabel.topAnchor.constraint(equalTo:  authLabel.topAnchor, constant: -20)
    ]
    
    func addAuthInterface() {
        view.addSubview(qrButton)
        view.addSubview(authLabel)
        NSLayoutConstraint.activate(сonstraintsAuthView)
    }
    
    func addProfileInterface() {
        view.addSubview(quitButton)
        view.addSubview(nameLabel)
        view.addSubview(userAvatar)
        NSLayoutConstraint.activate(сonstraintsProfileView)
    }
    
    func addErrorLabel() {
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate(сonstraintsErrorView)
    }

    @objc func exitProfile(sender: UIButton!) {
        cleanView()
        addAuthInterface()
    }
    
    // MARK: - Get token from QrScanner
    
    @objc func openScanner(sender: UIButton!) {
        self.performSegue(withIdentifier: "PassToken", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scannerVC = segue.destination as? QrScannerController {
            scannerVC.callback = { message in
                self.dataManager.auth(token: message)
            }
        }
    }
    
    func checkAuth() {
        if let receivedData = KeyChain.load(key: "token") {
            let result = receivedData.to(type: String.self)
            print("result: ", result)
        }
    }
    
    func cleanView() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }

}


// MARK: - Extension for Request Delegate

extension ProfileViewController: RequestAuthManagerDelegate {
    
    func didGetUserData(_: RequestManager, userData: UserModel) {
        DispatchQueue.main.async {
            self.cleanView()
            self.userData = userData
            self.addProfileInterface()
            self.nameLabel.text = userData.name
            self.userAvatar.load(url: (URL(string: userData.avatar_url)!))
        }
    }
    
    func didFailWithError(message: String) {
        DispatchQueue.main.async {
            self.addErrorLabel()
        }
    }
}

// MARK: - Async loading Profile Image

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
