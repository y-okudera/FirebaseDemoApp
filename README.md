# FirebaseDemoApp
Firebase demo app. (Swift)

## 構成
簡易的にするために、UIとロジックしか分けてないよ。

（ホントはDataレイヤーに置くやつも、Domainの中に置いちゃってるよ。）

```
Domain/
    ├ Model/  structで定義するモデル
    └ Utility/  汎用的なビジネスロジック
    
Presentation/
    ├ Resources/  画像などのリソース
    ├ Screen/  StoryboardやViewController, Cellなど画面実装クラス
    └ Utility/  Extensionや汎用的なViewなどUIまわりの汎用処理
```

## 実装
実装したら、チェックをつけていくよ。

- [x] Firebase Authentication
  - [x] Sign in with Apple
  - [x] Google Sign-In 
- [x] Firebase RemoteConfig
  - [x] Firebase RemoteConfigのセットアップ
  - [ ] Firebase RemoteConfigの呼び出し
