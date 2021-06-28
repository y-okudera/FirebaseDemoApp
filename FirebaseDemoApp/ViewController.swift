//
//  ViewController.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/06/28.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    private func setUp() {
        // Firebase RemoteConfigから情報を取得する
        FirebaseHelper.shared.remoteConfig.fetch(withExpirationDuration: TimeInterval(0), completionHandler: { status, error -> Void in
            if status == .success {
                print("fetch success")
            } else {
                print("fetch failed")
            }

            if let value = FirebaseHelper.shared.remoteConfig.configValue(forKey: RemoteConfigKey.StringType.homeBackgroundColor.rawValue).stringValue {
                print("value", value)
                self.view.backgroundColor = UIColor(hex: value) ?? .white
            }

            if let err = error {
                print("ERROR", err)
            }
        })
    }

}

