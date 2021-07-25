//
//  FirebaseHelper.swift
//  FirebaseDemoApp
//
//  Created by Yuki Okudera on 2021/06/28.
//

#warning("外部へのアクセスだから、ホントはDomainレイヤーっていうよりDataレイヤーだけど、サンプルだから...")

import Firebase

final class FirebaseHelper {
    
    static let shared = FirebaseHelper()
    private init() {}

    private(set) var remoteConfig = RemoteConfig.remoteConfig()

    /// didFinishLaunchingWithOptionsで呼び出す初期処理
    func configure() {
        setup()
        setupRemoteConfig()
    }

    /// Google Sign Inで使用するクライアントID
    var clientID: String? {
        FirebaseApp.app()?.options.clientID
    }

    /// インストール認証トークンを取得
    ///
    /// Firebase RemoteConfigのコンソールでテストデバイスとして設定する際に必要なトークン
    func authTokenForcingRefresh() {
        Installations.installations().authTokenForcingRefresh(true) { token, error in
            if let error = error {
                Logger.error("Error fetching token: \(error)")
                return
            }
            guard let token = token else {
                Logger.error("Installation auth token is nil...")
                return
            }
            Logger.info("Installation auth token: \(token.authToken)")
        }
    }

    /// Apple ID authenticationのトークンを使用して、Firebaseにサインインする
    ///
    /// SignInWithApple処理で使用する
    func signIn(appleIDToken: String, nonce: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDToken, rawNonce: nonce)
        self.signIn(credential: credential, completion: completion)
    }

    /// Google authenticationのトークンを使用して、Firebaseにサインインする
    ///
    /// SignInWithGoogle処理で使用する
    func signIn(googleIDToken: String, accessToken: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        // Initialize a Firebase credential.
        let credential = GoogleAuthProvider.credential(withIDToken: googleIDToken, accessToken: accessToken)
        self.signIn(credential: credential, completion: completion)
    }

    /// FirebaseのユーザープロフィールのdisplayNameを更新する
    func updateDisplayName(displayName: String, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let request = currentUser.createProfileChangeRequest()
        request.displayName = displayName
        request.commitChanges() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

extension FirebaseHelper {

    private func setup() {
        FirebaseApp.configure()
    }

    private func setupRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.setDefaults(fromPlist: "RemoteConfig-default")
        remoteConfig.configSettings = RemoteConfigSettings()
    }

    /// Firebaseにサインインする
    private func signIn(credential: AuthCredential, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                Logger.error("signIn Error", error.localizedDescription)
                completion(.failure(error))
                return
            }
            // User is signed in to Firebase with Apple.
            completion(.success(authResult))
        }
    }
}
