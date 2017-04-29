//
//  ViewController.swift
//  LoginApplication
//
//  Created by Pritesh Nandgaonkar on 22/4/17.
//  Copyright © 2017 Pritesh Nandgaonkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var loginService: LoginService!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginService = LoginServiceDelegate(delegate: self)
    }
    
    @IBAction func tappedLogin(_ sender: UIButton) {
        loginService.login(withUsername: username.text, password: password.text)
    }
}

extension ViewController: LoginActionService {
    func loginSuccessfull(withUser user: User) {
        showAlert(withTitle: "Success", message: "Hello \(user.name)")
    }
    
    func handle(error: Error) {
        showAlert(withTitle: "Error", message: error.localizedDescription)
    }
}

