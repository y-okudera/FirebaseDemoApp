//
//  SignIn.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/26.
//

import Foundation

protocol SignIn: AnyObject {
    var delegate: SignInDelegate? { get set }
    func startSignInFlow(delegate: SignInDelegate?)
}

protocol SignInDelegate: AnyObject {
    func signIn(_ signIn: SignIn, didComplete result: SignInResult)
    func signIn(_ signIn: SignIn, errorOccurred error: Error?)
}
