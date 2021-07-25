//
//  SignInResult.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/24.
//

import AuthenticationServices
import Firebase

struct SignInResult {
    /// サインインの種類
    let signInType: SignInType

    /// SignInWithApple処理後のFirebaseのサインイン処理の結果
    let signInWithFirebaseResult: SignInWithFirebaseResult

    init?(signInType: SignInType, authResult: AuthDataResult?) {
        guard let authResult = authResult else {
            return nil
        }
        self.signInType = signInType
        self.signInWithFirebaseResult = .init(authResult: authResult)
    }
}

extension SignInResult {

    enum SignInType {
        case apple(SignInWithAppleResult)
        case google
    }

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
