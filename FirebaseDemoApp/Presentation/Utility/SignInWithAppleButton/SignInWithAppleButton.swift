//
//  SignInWithAppleButton.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/24.
//

import UIKit
import AuthenticationServices

/// Sign in with AppleボタンをStoryboardから設定できるようにしたカスタムボタン
final class SignInWithAppleButton: UIButton {

    private var appleIDButton: ASAuthorizationAppleIDButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let type = ASAuthorizationAppleIDButton.ButtonType.default
        let style: ASAuthorizationAppleIDButton.Style = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        self.appleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
        self.appleIDButton.cornerRadius = 6.0

        addSubview(self.appleIDButton)

        self.appleIDButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.appleIDButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.appleIDButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.appleIDButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.appleIDButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])

        self.appleIDButton.addTarget(self, action: #selector(appleIDButtonTapped(_:)), for: .touchUpInside)
    }

    @objc
    func appleIDButtonTapped(_ sender: Any) {
        self.sendActions(for: .touchUpInside)
    }
}
