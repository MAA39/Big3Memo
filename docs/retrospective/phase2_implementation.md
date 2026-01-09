# Phase 2: 実装フェーズ (Implementation)

## ❌ やったこと (What We Did)
**「難易度の高い機能を同時に実装」**
*   `ConnectivityManager`（非同期通信）の実装。
*   `HealthKitManager`（ヘルスケア連携）の実装。
*   これらをほぼ同時に書き進め、一気に結合しようとした。

## 💥 失敗の要因 (Failure Analysis)
**「問題の切り分けが困難になった (Complexity Overload)」**
*   アプリが動かない（データが表示されない）時、原因が複数考えられる状態になってしまった。
    *   通信が遅れているだけ？
    *   通信データ形式が間違っている？
    *   HealthKitの権限がないから止まっている？
    *   UIのBindingがおかしい？
*   特にHealthKitとConnectivityはどちらもシミュレータで特有の挙動（遅延やダミーデータ）をするため、バグの原因特定に時間を浪費した。

## ✨ 理想の進め方 (Success Path)
**「疑似データ（Mock）の活用」**
1.  **Mock First**: `ConnectivityManager` を作る前に、`MockConnectivityManager` を作る。
    *   「Saveボタンを押したら、必ず成功したフリをする」
    *   「Watchアプリが起動したら、即座に固定のメニューデータを『受信したことにして』返す」
2.  **Verified UI**: モックを使って、UI（画面表示）とロジック（計算など）が100%正しいことを先に確定させる。
3.  **Inject Real Logic**: 最後にモックを本物の `ConnectivityManager` に差し替える。

**教訓:**
> 不確実な要素（通信・外部API）は、開発の最後までは「嘘のデータ」で蓋をしておく。
