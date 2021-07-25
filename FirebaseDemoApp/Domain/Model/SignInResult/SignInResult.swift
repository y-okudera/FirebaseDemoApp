//
//  SignInResult.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/24.
//

import AuthenticationServices
import Firebase

struct SignInResult {
    /// SignInWithApple処理の結果
    let signInWithAppleResult: SignInWithAppleResult

    /// SignInWithApple処理後のFirebaseのサインイン処理の結果
    let signInWithFirebaseResult: SignInWithFirebaseResult

    init?(appleIDCredential: ASAuthorizationAppleIDCredential, authResult: AuthDataResult?) {
        guard let authResult = authResult else {
            return nil
        }
        self.signInWithAppleResult = .init(appleIDCredential: appleIDCredential)
        self.signInWithFirebaseResult = .init(authResult: authResult)
    }
}

extension SignInResult {

    struct SignInWithAppleResult {
        let displayName: String?
        let email: String?

        init(appleIDCredential: ASAuthorizationAppleIDCredential) {
            if let fullName = appleIDCredential.fullName {
                let formatter = PersonNameComponentsFormatter()
                self.displayName = formatter.string(from: fullName)
            } else {
                self.displayName = nil
            }
            self.email = appleIDCredential.email
        }
    }

    struct SignInWithFirebaseResult {
        let user: Firebase.User
        let providerID: String?
        let profile: [String: NSObject]?
        let username: String?
        let isNewUser: Bool?

        init(authResult: AuthDataResult) {
            self.user = authResult.user
            self.providerID = authResult.additionalUserInfo?.providerID
            self.profile = authResult.additionalUserInfo?.profile
            self.username = authResult.additionalUserInfo?.username
            self.isNewUser = authResult.additionalUserInfo?.isNewUser
        }
    }
}
