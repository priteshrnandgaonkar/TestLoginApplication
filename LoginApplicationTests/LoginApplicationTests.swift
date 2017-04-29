//
//  LoginApplicationTests.swift
//  LoginApplicationTests
//
//  Created by Pritesh Nandgaonkar on 22/4/17.
//  Copyright © 2017 Pritesh Nandgaonkar. All rights reserved.
//

import XCTest
@testable import LoginApplication


class FakeLoginActionService: LoginActionService {
    
    var isLoginSuccessFullCalled = false
    var isHandleErrorCalled = false
    var error: Error? = nil
    
    func loginSuccessfull(withUser user: User) {
        isLoginSuccessFullCalled = true
    }
    
    func handle(error: Error) {
        isHandleErrorCalled = true
        self.error = error
    }
}

class FakeFailureLoginService: LoginService {
    let error: LoginServiceError
    var delegate: LoginActionService
    
    init(error: LoginServiceError, delegate: LoginActionService) {
        self.error = error;
        self.delegate = delegate
    }
    func login(withUsername username: String?, password: String?) {
        delegate.handle(error: error)
    }
}

class LoginApplicationTests: XCTestCase {
    var vcLogin: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vcLogin = vc      
        _ = vcLogin.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInvalidUsernameLengthEndToEnd() {
        
        let actionDelegate = FakeLoginActionService()

        vcLogin.username.text = "p"
        vcLogin.loginService = LoginServiceDelegate(delegate: actionDelegate)
        vcLogin.loginButton.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginFormValidationError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginFormValidationError.invalidUsernameLength, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginFormValidationError.invalidUsernameLength) but got \(receivedError)")
    }
    
    func testInvalidPasswordLengthEndToEnd() {
        
        let actionDelegate = FakeLoginActionService()
        
        vcLogin.username.text = "pritesh"
        vcLogin.password.text = "po"
        vcLogin.loginService = LoginServiceDelegate(delegate: actionDelegate)
        vcLogin.loginButton.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginFormValidationError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginFormValidationError.invalidPasswordLength, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginFormValidationError.invalidPasswordLength) but got \(receivedError)")
    }
    
    func testInvalidCredentialsInLoginServiceEndToEnd() {
        
        let actionDelegate = FakeLoginActionService()
        
        vcLogin.username.text = "pritesh"
        vcLogin.password.text = "poY7trl"
        vcLogin.loginService = FakeFailureLoginService(error: .invalidCredentials, delegate: actionDelegate)
        vcLogin.loginButton.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginServiceError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginServiceError.invalidCredentials, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginServiceError.invalidCredentials) but got \(receivedError)")
    }
    
    func testInvalidPasswordCharactersEndToEnd() {
        
        let actionDelegate = FakeLoginActionService()
        
        vcLogin.username.text = "pritesh"
        vcLogin.password.text = "poytrl"
        vcLogin.loginService = LoginServiceDelegate(delegate: actionDelegate)
        vcLogin.loginButton.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginFormValidationError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginFormValidationError.invalidPasswordCharacters, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginFormValidationError.invalidPasswordCharacters) but got \(receivedError)")
    }
    
    func testDataNilInLoginServiceEndToEnd() {
        
        let actionDelegate = FakeLoginActionService()
        
        vcLogin.username.text = "pritesh"
        vcLogin.password.text = "poY7trl"
        vcLogin.loginService = FakeFailureLoginService(error: .nilData, delegate: actionDelegate)
        vcLogin.loginButton.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginServiceError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginServiceError.nilData, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginServiceError.nilData) but got \(receivedError)")
    }
    
    func testWrongStatusCodeInLoginServiceEndToEnd() {
        
        let actionDelegate = FakeLoginActionService()
        
        vcLogin.username.text = "pritesh"
        vcLogin.password.text = "poY7trl"
        vcLogin.loginService = FakeFailureLoginService(error: .wrongStatusCode, delegate: actionDelegate)
        vcLogin.loginButton.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginServiceError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginServiceError.wrongStatusCode, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginServiceError.wrongStatusCode) but got \(receivedError)")
    }
    
// Test LoginService - Validation Function
    
    func testSuccessfullValidation() {
        let actionDelegate = FakeLoginActionService()

        let loginService = LoginServiceDelegate(delegate: actionDelegate)
        loginService.login(withUsername: "pritesh", password: "aK8oio")
        
        if !actionDelegate.isLoginSuccessFullCalled {
            XCTFail("Function validate returned error whereas it was expected to succeed. The error is \(actionDelegate.error?.localizedDescription)")
        }
        
        XCTAssertTrue(actionDelegate.isLoginSuccessFullCalled , "The function loginsuccessfull is not called.")
        
    }

    func testUsernameLengthValidation() {
        
        let actionDelegate = FakeLoginActionService()
        
        let loginService = LoginServiceDelegate(delegate: actionDelegate)
        loginService.login(withUsername: "p", password: "aK8oio")
        
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handle error is not called.")
        
        guard let loginFormError = actionDelegate.error as? LoginFormValidationError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }

        XCTAssert(loginFormError == LoginFormValidationError.invalidUsernameLength, "Expected validation error of type invalidUsernameLength but got \(loginFormError)")

    }

    func testPasswordLengthValidation() {
        
        let actionDelegate = FakeLoginActionService()
        
        let loginService = LoginServiceDelegate(delegate: actionDelegate)
        loginService.login(withUsername: "pritesh", password: "a")
        
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handle error is not called.")
        
        guard let loginFormError = actionDelegate.error as? LoginFormValidationError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }
        
        XCTAssert(loginFormError == LoginFormValidationError.invalidPasswordLength, "Expected validation error of type invalidUsernameLength but got \(loginFormError)")

    }

    func testPasswordCharacterValidation() {
        
        let actionDelegate = FakeLoginActionService()
        
        let loginService = LoginServiceDelegate(delegate: actionDelegate)
        loginService.login(withUsername: "pritesh", password: "abjkop")
        
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handle error is not called.")
        
        guard let loginFormError = actionDelegate.error as? LoginFormValidationError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }
        
        XCTAssert(loginFormError == LoginFormValidationError.invalidPasswordCharacters, "Expected validation error of type invalidUsernameLength but got \(loginFormError)")

    }
    
}
