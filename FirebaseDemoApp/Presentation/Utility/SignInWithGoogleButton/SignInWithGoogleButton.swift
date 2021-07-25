//
//  SignInWithGoogleButton.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/25.
//

import GoogleSignIn

final class SignInWithGoogleButton: GIDSignInButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        self.style = .wide
        self.colorScheme = UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        super.draw(rect)
    }
}
