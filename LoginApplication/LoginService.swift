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
    func login(withUsername username: String, password: String, completion:(Result<User>) -> ())
}

protocol LoginActionService {
    
    func loginSuccessfull(withUser user: User)
    
    func handle(error: Error)
}

class LoginServiceDelegate: LoginService {
    func login(withUsername username: String, password: String, completion: (Result<User>) -> ()) {
        // hit login service
        
        let user = User(name: username, userName: username, email: "\(username)@gmail.com", address: "Find me if you can", designation: "Software Developer")
        completion(Result.success(user))
    }
}
