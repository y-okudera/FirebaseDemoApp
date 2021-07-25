//
//  SignInWithAppleCompatible.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/24.
//

#warning("外部へのアクセスだから、ホントはDomainレイヤーっていうよりDataレイヤーだけど、サンプルだから...")

import AuthenticationServices
import CryptoKit

protocol SignInWithAppleDelegate: AnyObject {
    func signInWithApple(_ signInWithApple: SignInWithApple, didComplete result: SignInResult)
    func signInWithApple(_ signInWithApple: SignInWithApple, errorOccurred error: Error?)
}

final class SignInWithApple: NSObject {

    weak var delegate: SignInWithAppleDelegate?

    /// Unhashed nonce.
    var currentNonce: String?

    var presentationAnchor: ASPresentationAnchor

    override init() {
        guard let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window else {
            fatalError("window is nil.")
        }
        self.presentationAnchor = window
        super.init()
    }

    init(presentationAnchor: ASPresentationAnchor) {
        self.presentationAnchor = presentationAnchor
        super.init()
    }

    func startSignInFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension SignInWithApple {

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData
            .compactMap { String(format: "%02x", $0) }
            .joined()

        return hashString
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension SignInWithApple: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            Logger.error("ASAuthorizationAppleIDCredential is nil.")
            self.delegate?.signInWithApple(self, errorOccurred: nil)
            return
        }
        guard let nonce = currentNonce else {
            Logger.error("Invalid state: A login callback was received, but no login request was sent.")
            self.delegate?.signInWithApple(self, errorOccurred: nil)
            return
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            Logger.error("Unable to fetch identity token")
            self.delegate?.signInWithApple(self, errorOccurred: nil)
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            Logger.error("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            self.delegate?.signInWithApple(self, errorOccurred: nil)
            return
        }

        // Sign in with Firebase.
        FirebaseHelper.shared.signIn(appleIDToken: idTokenString, nonce: nonce) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .failure(let error):
                Logger.debug("error: \(error)")
                self.delegate?.signInWithApple(self, errorOccurred: error)
            case .success(let authResult):
                guard let signInResult = SignInResult(appleIDCredential: appleIDCredential, authResult: authResult) else {
                    Logger.error("signInResult is nil.")
                    self.delegate?.signInWithApple(self, errorOccurred: nil)
                    return
                }
                Logger.debug("Signed in to Firebase with Apple!!")
                self.delegate?.signInWithApple(self, didComplete: signInResult)
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let authorizationError = ASAuthorizationError(_nsError: error as NSError)
        if authorizationError.code == .canceled {
            Logger.info("Sign in with Apple is Canceled.")
            return
        }
        Logger.error("Sign in with Apple errored: \(error)")
        self.delegate?.signInWithApple(self, errorOccurred: error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension SignInWithApple: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationAnchor
    }
}
