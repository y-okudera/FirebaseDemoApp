//
//  HomeViewController.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/07/25.
//

import UIKit

final class HomeViewController: UIViewController {

    /// とりあえずの画面ビルダー的なやつ
    class func make() -> HomeViewController {
        let storyboard = UIStoryboard(name: "HomeViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.debug()
        self.navigationItem.title = "ホーム"
    }
}
