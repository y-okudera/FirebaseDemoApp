//
//  LoginViewController.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/24.
//

import UIKit

final class LoginViewController: UIViewController {

    private lazy var signInWithApple = SignInWithApple()

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.debug()
    }

    @IBAction private func tappedSignInWithApple(_ sender: SignInWithAppleButton) {
        signInWithApple.delegate = self
        signInWithApple.startSignInFlow()
    }
}

extension LoginViewController {

    /// ユーザープロフィール画面に遷移する
    private func transitToUserProfile(name: String?, email: String?) {
        let userProfileVC = UserProfileViewController.make(defaultName: name, defaultMailAddress: email) { [weak self] in
            Logger.debug("ユーザー情報の更新完了!")
            self?.transitToHome()
        }
        self.present(userProfileVC, animated: true)
    }

    /// ホーム画面に遷移する
    private func transitToHome() {
        let nc = UINavigationController(rootViewController: HomeViewController.make())
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true)
    }
}

extension LoginViewController: SignInWithAppleDelegate {

    func signInWithApple(_ signInWithApple: SignInWithApple, didComplete result: SignInResult) {
        Logger.debug("Apple", result.signInWithAppleResult)
        Logger.debug("Firebase", result.signInWithFirebaseResult)

        guard let isNewUser = result.signInWithFirebaseResult.isNewUser else {
            return
        }
        if isNewUser {
            // 新規ユーザーの場合は、SignInWithAppleの名前とメールアドレスを使用する
            // nilの場合は、一応Firebaseの名前とメールアドレスを使用する（Firebaseの名前とメールアドレスもnilの場合もあり得るけど。）
            let name = result.signInWithAppleResult.displayName ?? result.signInWithFirebaseResult.user.displayName
            let email = result.signInWithAppleResult.email ?? result.signInWithFirebaseResult.user.email
            Logger.debug("新規ユーザー name: \(name ?? "nil") email: \(email ?? "nil")")

            // ユーザープロフィール画面に遷移する
            self.transitToUserProfile(name: name, email: email)
        } else {
            // 既存ユーザーの場合は、Firebaseの名前とメールアドレスを使用する
            let name = result.signInWithFirebaseResult.user.displayName
            let email = result.signInWithFirebaseResult.user.email
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

    func signInWithApple(_ signInWithApple: SignInWithApple, errorOccurred error: Error?) {
        Logger.error(error?.localizedDescription ?? "")
        let alert = UIAlertController(title: "エラー", message: "サインインに失敗しました。", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
