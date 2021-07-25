//
//  UserProfileViewController.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/24.
//

import UIKit

final class UserProfileViewController: UIViewController {

    /// とりあえずの画面ビルダー的なやつ
    ///
    /// dismissCompletionで、ユーザー名更新完了後にdismissが完了した後の処理を遷移元からあらかじめ渡しておく
    class func make(defaultName: String?, defaultMailAddress: String?, dismissCompletion: @escaping () -> Void) -> UserProfileViewController {
        let storyboard = UIStoryboard(name: "UserProfileViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "UserProfileViewController") as! UserProfileViewController
        vc.defaultName = defaultName
        vc.defaultMailAddress = defaultMailAddress
        vc.dismissCompletion = dismissCompletion
        return vc
    }

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var mailAddressTextField: UITextField!

    private var defaultName: String?
    private var defaultMailAddress: String?
    private var dismissCompletion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.userNameTextField.text = self.defaultName
        self.mailAddressTextField.text = self.defaultMailAddress

        // Firebaseのユーザーのメールアドレスを変更する場合は、メールが飛んでリンクタップさせる必要があって
        // SignInWithAppleのメリットが損なわれるので、メールアドレスは編集不可にしておく。
        // 編集不可なら、もはや見せなくても良いかも。。。
        self.mailAddressTextField.isUserInteractionEnabled = false
    }

    @IBAction private func tappedSaveButton(_ sender: UIButton) {
        // userNameがnilか空だったら、return
        guard let userName = self.userNameTextField.text, !userName.isEmpty else {
            return
        }

        // Firebaseのユーザー名を更新する
        FirebaseHelper.shared.updateDisplayName(displayName: userName) { result in
            switch result {
            case .failure(let error):
                Logger.error("ユーザー名更新失敗", error)
            case .success:
                Logger.debug("ユーザー名更新成功")
                self.dismiss(animated: true, completion: self.dismissCompletion)
            }
        }
    }
}
