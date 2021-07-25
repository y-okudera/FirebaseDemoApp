//
//  LoginViewController.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/24.
//

import UIKit

final class LoginViewController: UIViewController {

    private lazy var signInWithApple = SignInWithApple()
    private lazy var signInWithGoogle = SignInWithGoogle(presentation: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.debug()
    }

    @IBAction private func tappedSignInWithApple(_ sender: SignInWithAppleButton) {
        self.signInWithApple.startSignInFlow(delegate: self)
    }

    @IBAction private func tappedSignInWithGoogle(_ sender: SignInWithGoogleButton) {
        self.signInWithGoogle.startSignInFlow(delegate: self)
    }
}

extension LoginViewController {

    /// ユーザープロフィール画面に遷移する
    private func transitToUserProfile(name: String?, email: String?) {
        let userProfileVC = UserProfileViewController.make(defaultName: name, defaultMailAddress: email) { [weak self] in
            Logger.debug("ユーザー情報の更新完了!")
            self?.transitToHome()
        }
        userProfileVC.isModalInPresentation = true
        self.present(userProfileVC, animated: true)
    }

    /// ホーム画面に遷移する
    private func transitToHome() {
        let nc = UINavigationController(rootViewController: HomeViewController.make())
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true)
    }
}

// MARK: - SignInDelegate
extension LoginViewController: SignInDelegate {

    func signIn(_ signIn: SignIn, didComplete result: SignInResult) {
        Logger.debug("Firebase", result.signInWithFirebaseResult)
        switch result.signInType {
        case .apple(let signInWithAppleResult):
            Logger.debug("Apple", signInWithAppleResult)
            self.handleAppleSignInResult(appleResult: signInWithAppleResult, firebaseResult: result.signInWithFirebaseResult)
        case .google:
            Logger.debug("Google")
            self.handleGoogleSignInResult(firebaseResult: result.signInWithFirebaseResult)
        }
    }

    func signIn(_ signIn: SignIn, errorOccurred error: Error?) {
        Logger.error(error?.localizedDescription ?? "")
        let alert = UIAlertController(title: "エラー", message: "サインインに失敗しました。", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    private func handleAppleSignInResult(appleResult: SignInResult.SignInWithAppleResult,
                                         firebaseResult: SignInResult.SignInWithFirebaseResult) {
        guard let isNewUser = firebaseResult.isNewUser else {
            return
        }
        if isNewUser {
            // 新規ユーザーの場合は、SignInWithAppleの名前とメールアドレスを使用する
            // nilの場合は、一応Firebaseの名前とメールアドレスを使用する（Firebaseの名前とメールアドレスもnilの場合もあり得るけど。）
            let name = appleResult.displayName ?? firebaseResult.user.displayName
            let email = appleResult.email ?? firebaseResult.user.email
            Logger.debug("新規ユーザー name: \(name ?? "nil") email: \(email ?? "nil")")

            // ユーザープロフィール画面に遷移する
            self.transitToUserProfile(name: name, email: email)
        } else {
            // 既存ユーザーの場合は、Firebaseの名前とメールアドレスを使用する
            let name = firebaseResult.user.displayName
            let email = firebaseResult.user.email
            Logger.debug("既存ユーザー name: \(name ?? "nil") email: \(email ?? "nil")")

            // 名前が既に登録済みの場合は、ホーム画面に遷移する
            if name?.isEmpty == false {
                self.transitToHome()
            } else {
                // 名前が未登録の場合は、ユーザープロフィール画面に遷移する
                self.transitToUserProfile(name: name, email: email)
            }
        }
    }

    private func handleGoogleSignInResult(firebaseResult: SignInResult.SignInWithFirebaseResult) {
        let name = firebaseResult.user.displayName
        let email = firebaseResult.user.email
        Logger.debug("ユーザー name: \(name ?? "nil") email: \(email ?? "nil")")

        // 名前が既に登録済みの場合は、ホーム画面に遷移する
        if name?.isEmpty == false {
            self.transitToHome()
        } else {
            // 名前が未登録の場合は、ユーザープロフィール画面に遷移する
            self.transitToUserProfile(name: name, email: email)
        }
    }
}
