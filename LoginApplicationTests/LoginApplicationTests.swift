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
    
    init(error: LoginServiceError) {
        self.error = error;
    }
    func login(withUsername username: String, password: String, completion: (Result<User>) -> ()) {
        completion(Result.failure(error))
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
        vcLogin.loginActionDelegate = actionDelegate
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
        vcLogin.loginActionDelegate = actionDelegate
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
        vcLogin.loginService = FakeFailureLoginService(error: .invalidCredentials)
        vcLogin.loginActionDelegate = actionDelegate
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
        vcLogin.loginActionDelegate = actionDelegate
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
        vcLogin.loginService = FakeFailureLoginService(error: .nilData)
        vcLogin.loginActionDelegate = actionDelegate
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
        vcLogin.loginService = FakeFailureLoginService(error: .wrongStatusCode)
        vcLogin.loginActionDelegate = actionDelegate
        vcLogin.loginButton.sendActions(for: .touchUpInside)
        guard let receivedError = actionDelegate.error as? LoginServiceError else {
            XCTFail("Expected error of type LoginFormValidationError but got \(actionDelegate.error)")
            return
        }
        XCTAssertTrue(actionDelegate.isHandleErrorCalled , "The function handleError is not called.")
        XCTAssert(receivedError == LoginServiceError.wrongStatusCode, "The function handleError is called but the error received as the argument in the function is wrong, Expected the error of type \(LoginServiceError.wrongStatusCode) but got \(receivedError)")
    }
    
    func testSuccessfullValidation() {
        
        let result: Result<Bool> = vcLogin.validate(userName: "pritesh", password: "aK8oio")
        do {
            let isSuccess = try result.resolve()
            XCTAssertTrue(isSuccess, "Validate function restured false in result object whereas it was expected to be true")
        }
        catch (let error) {
            XCTFail("Function validate returned error whereas it was expected to succeed. The error is \(error.localizedDescription)")
        }
    }
    
    func testUsernameLengthValidation() {
        
        let result: Result<Bool> = vcLogin.validate(userName: "p", password: "aK8oio")
        do {
            let _ = try result.resolve()
            XCTFail("Expected error, but didn't get any")
        }
        catch (let error) {
            guard let loginFormError = error as? LoginFormValidationError else {
                XCTFail("Expected error of type LoginFormValidationError but got \(error)")
                return
            }
            XCTAssert(loginFormError == LoginFormValidationError.invalidUsernameLength, "Expected validation error of type invalidUsernameLength but got \(loginFormError)")
        }
    }
    
    func testPasswordLengthValidation() {
        
        let result: Result<Bool> = vcLogin.validate(userName: "pritesh", password: "a")
        do {
            let _ = try result.resolve()
            XCTFail("Expected error, but didn't get any")
        }
        catch (let error) {
            guard let loginFormError = error as? LoginFormValidationError else {
                XCTFail("Expected error of type LoginFormValidationError but got \(error)")
                return
            }
            XCTAssert(loginFormError == LoginFormValidationError.invalidPasswordLength, "Expected validation error of type invalidUsernameLength but got \(loginFormError)")
        }
    }
    
    func testPasswordCharacterValidation() {
        
        let result: Result<Bool> = vcLogin.validate(userName: "pritesh", password: "abjkop")
        do {
            let _ = try result.resolve()
            XCTFail("Expected error, but didn't get any")
        }
        catch (let error) {
            guard let loginFormError = error as? LoginFormValidationError else {
                XCTFail("Expected error of type LoginFormValidationError but got \(error)")
                return
            }
            XCTAssert(loginFormError == LoginFormValidationError.invalidPasswordCharacters, "Expected validation error of type invalidUsernameLength but got \(loginFormError)")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
