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
    var loginActionDelegate: LoginActionService!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginService = LoginServiceDelegate()
        loginActionDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func tappedLogin(_ sender: UIButton) {
        
        let result = validate(userName: username.text ?? "", password: password.text ?? "")
        switch result {
        case .failure(let error):
            //handle error
            loginActionDelegate.handle(error: error)
            return
        case .success(_):
            // hit login api
            break
        }
        
        loginService.login(withUsername: username.text!, password: password.text!) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.loginActionDelegate.handle(error: error)
            case .success(let user):
                //success
                self?.loginActionDelegate.loginSuccessfull(withUser: user)
                break
            }
        }
    }
    
    func validate(userName username: String, password: String) -> Result<Bool> {
        guard username.characters.count >= 2 && username.characters.count <= 10 else {
            return Result.failure(LoginFormValidationError.invalidUsernameLength)
        }
        
        guard password.characters.count > 2 else {
            return Result.failure(LoginFormValidationError.invalidPasswordLength)
        }
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: password)
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: password)
        
        guard capitalresult && numberresult else {
            return Result.failure(LoginFormValidationError.invalidPasswordCharacters)
        }
        
        return .success(true)
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

