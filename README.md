# Big3Memo 🏋️

Big3（ベンチプレス・スクワット・デッドリフト）に特化したトレーニングメモアプリ

## コンセプト

**「トレーニング中はiPhoneを絶対触らない」**

Apple Watchだけで記録を完結させ、iPhoneは事前設定と振り返りのみに使用。

## 対応プラットフォーム

- iOS 17.0+
- watchOS 10.0+

## 機能

### 📱 iPhone App

- 種目ごとの目標重量・セット数・レップ数の事前設定
- 休憩時間の設定（種目別）
- 履歴確認・グラフ表示
- 分析 → 次回の計画提案（将来）

### ⌚ Watch App

- 今日のメニュー表示
- セット完了 → 重量・レップ入力（Digital Crown）
- 休憩タイマー自動開始
- 休憩終了時のHaptic通知
- 前回の記録確認

## 基本フロー

```
【事前】iPhone で今日のメニュー設定
    ↓
【ジム】Watch でメニュー確認
    ↓
🏋️ トレーニング実施
    ↓
⌚ セット完了タップ
    ↓
⌚ 重量・レップ確認/修正（Digital Crown）
    ↓
⏱️ 休憩タイマー自動スタート
    ↓
📳 Hapticで通知
    ↓
🔁 繰り返し
    ↓
【帰宅後】iPhone で振り返り
```

## 技術スタック

- **UI**: SwiftUI
- **iPhone ↔ Watch連携**: WatchConnectivity
- **データ永続化**: UserDefaults（設定）/ SwiftData（履歴・将来）
- **Haptic**: WKInterfaceDevice
- **バックグラウンド**: WKExtendedRuntimeSession

## プロジェクト構成

```
Big3Memo/
├── Big3Memo/                    # iOS App
│   ├── App/
│   ├── Views/
│   ├── Models/
│   ├── Managers/
│   └── Resources/
├── Big3MemoWatch/               # watchOS App
│   ├── App/
│   ├── Views/
│   ├── Managers/
│   └── Resources/
└── Shared/                      # 共有コード
    ├── Models/
    └── Connectivity/
```

## セットアップ

1. Xcodeで `File → New → Project → iOS App with Watch App` を選択
2. Product Name: `Big3Memo`
3. Interface: SwiftUI
4. Watch App: Include Watch App にチェック

## ライセンス

MIT License
