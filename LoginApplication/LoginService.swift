//
//  LoginService.swift
//  LoginApplication
//
//  Created by Pritesh Nandgaonkar on 23/4/17.
//  Copyright © 2017 Pritesh Nandgaonkar. All rights reserved.
//

import Foundation

enum LoginServiceError: LocalizedError {
    case invalidCredentials
    case nilData
    case wrongStatusCode
    case unknown
    
    var errorDescription: String? {
        var errorString:String? = nil
        switch self {
        case .invalidCredentials:
            errorString = "The user credentials are invalid"
        case .nilData:
            errorString = "Failed to fetch your data, please try again later"
        case .wrongStatusCode:
            errorString = "Wrong status code received, please try again later"
        default:
            errorString = "Something went wrong please try again later"
        }
        
        return errorString
    }
}

protocol LoginService {
    var delegate: LoginActionService { get }
    func login(withUsername username: String?, password: String?)
}

protocol LoginActionService {
    
    func loginSuccessfull(withUser user: User)
    
    func handle(error: Error)
}

class LoginServiceDelegate: LoginService {
    let delegate: LoginActionService
    
    init(delegate: LoginActionService) {
        self.delegate = delegate
    }
    
    func login(withUsername username: String?, password: String?) {
        
        // hit login service
        let result = validate(userName: username ?? "", password: password ?? "")
        switch result {
        case .failure(let error):
            //handle error
            delegate.handle(error: error)
            return
        case .success(_):
            // hit login api
            break
        }
        
        guard let username = username else {
            delegate.handle(error: LoginFormValidationError.invalidUsernameLength)
            return
        }
        
        let user = User(name: username, userName: username, email: "\(username)@gmail.com", address: "Find me if you can", designation: "Software Developer")
        delegate.loginSuccessfull(withUser: user)
//        completion(Result.success(user))
        
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
