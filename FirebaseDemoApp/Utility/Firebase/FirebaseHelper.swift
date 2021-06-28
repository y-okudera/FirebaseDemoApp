//
//  FirebaseHelper.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/06/28.
//

import Foundation
import Firebase

final class FirebaseHelper: NSObject {
    
    static let shared = FirebaseHelper()
    private(set) var remoteConfig = RemoteConfig.remoteConfig()

    private func setUpRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.setDefaults(fromPlist: "RemoteConfig-default")
        remoteConfig.configSettings = RemoteConfigSettings()
    }
}

extension FirebaseHelper {
    
    func configure() {
        FirebaseApp.configure()
        setUpRemoteConfig()
    }
    
    func authTokenForcingRefresh() {
        Installations.installations().authTokenForcingRefresh(true) { token, error in
            if let error = error {
                print("Error fetching token: \(error)")
                return
            }
            guard let token = token else {
                return
            }
            print("Installation auth token: \(token.authToken)")
        }
    }
}
