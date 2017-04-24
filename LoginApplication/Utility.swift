//
//  Utility.swift
//  LoginApplication
//
//  Created by Pritesh Nandgaonkar on 23/4/17.
//  Copyright © 2017 Pritesh Nandgaonkar. All rights reserved.
//

import Foundation
import UIKit

public enum Result<T> {
    case success(T)
    case failure(Error)
    
    func resolve() throws -> T {
        switch self {
        case .success(let T):
            return T
        case .failure(let error):
            throw error
        }
    }
}

enum LoginFormValidationError: LocalizedError {
    case invalidUsernameLength
    case invalidPasswordLength
    case invalidPasswordCharacters
    
    var errorDescription: String? {
        var errorString:String? = nil
        switch self {
        case .invalidUsernameLength:
            errorString = "Your username should have atleast 2 and atmost 10 characters"
        case .invalidPasswordLength:
            errorString = "Your password should be of atleast 3 characters with atleast one upercase letter and one decimal digit"
        case .invalidPasswordCharacters:
            errorString = "Your password should have atleast one upercase letter and one decimal digit"
        }
        
        return errorString
    }
}

extension LoginFormValidationError: Equatable {}

func ==(lhs: LoginFormValidationError, rhs: LoginFormValidationError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidUsernameLength, .invalidUsernameLength): fallthrough
    case (.invalidPasswordLength, .invalidPasswordLength): fallthrough
    case (.invalidPasswordCharacters, .invalidPasswordCharacters):
        return true
    default:
        return false
    }
}

func ==(lhs: LocalizedError, rhs: LocalizedError)  ->  Bool{
    return lhs.errorDescription == rhs.errorDescription && lhs.failureReason == rhs.failureReason && lhs.helpAnchor == rhs.helpAnchor && lhs.recoverySuggestion == rhs.recoverySuggestion && lhs.localizedDescription == rhs.localizedDescription
}

extension UIViewController {
    func showAlert(withTitle title: String, message: String, completion: (()->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (alert) in
            guard let completion = completion else {
                return
            }
            completion()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
