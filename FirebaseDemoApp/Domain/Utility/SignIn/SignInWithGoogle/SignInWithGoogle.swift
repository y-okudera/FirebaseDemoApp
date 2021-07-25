//
//  SignInWithGoogle.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/26.
//

#warning("外部へのアクセスだから、ホントはDomainレイヤーっていうよりDataレイヤーだけど、サンプルだから...")

import GoogleSignIn

final class SignInWithGoogle: SignIn {

    weak var delegate: SignInDelegate?

    weak var presentation: GoogleSignInPresentation?

    init(presentation: GoogleSignInPresentation?) {
        self.presentation = presentation
    }

    func startSignInFlow(delegate: SignInDelegate?) {
        self.delegate = delegate

        guard
            let clientID = FirebaseHelper.shared.clientID,
            let presentation = self.presentation else {
            return
        }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentation) { [weak self] user, error in
            guard let self = self else {
                return
            }
            if let error = error {
                let googleSignInError = GIDSignInError(_nsError: error as NSError)
                if googleSignInError.code == .canceled {
                    Logger.info("Sign in with Google is Canceled.")
                    return
                }
                Logger.error("Google signIn error: \(error)")
                self.delegate?.signIn(self, errorOccurred: error)
                return
            }

            guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                Logger.error("user is nil.")
                self.delegate?.signIn(self, errorOccurred: error)
                return
            }

            FirebaseHelper.shared.signIn(googleIDToken: idToken, accessToken: authentication.accessToken) { [weak self] result in
                guard let self = self else {
                    return
                }

                switch result {
                case .failure(let error):
                    Logger.error("error: \(error)")
                    self.delegate?.signIn(self, errorOccurred: error)
                case .success(let authResult):
                    guard let signInResult = SignInResult(signInType: .google, authResult: authResult) else {
                        Logger.error("signInResult is nil.")
                        self.delegate?.signIn(self, errorOccurred: nil)
                        return
                    }
                    Logger.debug("Signed in to Firebase with Google!!")
                    self.delegate?.signIn(self, didComplete: signInResult)
                }
            }
        }
    }
}
