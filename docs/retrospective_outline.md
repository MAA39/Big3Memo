# Big3MemoApp 振り返り（Retrospective）アウトライン案

「なぜうまくいかなかったのか（Failure）」と「どうすればうまくいったのか（Success Path）」を時系列で分析する構成案です。

## 1. 序章：プロジェクトの立ち上げ (Phase 1)
詳説: [Phase 1: Project Setup](retrospective/phase1_project_setup.md)
*   **やったこと**: iOSアプリ（母艦）とWatchアプリ（端末）の同時開発スタート。
*   **失敗の要因 (Failure)**: 最初から「通信」ありきで設計してしまった。
    *   最初からハードルが高すぎた（"Big Bang" approach）。
*   **理想の進め方 (Success Path)**: **「Watch単体アプリ」から始める（MVP戦略）**
    *   まずはWatchだけで完結するアプリを作る。
    *   iPhone側は作らない。通信考慮もしない。
    *   これにより「動くもの」を最短で手にしてモチベーションを維持する。

## 2. 実装フェーズ：複雑さの罠 (Phase 2)
詳説: [Phase 2: Implementation](retrospective/phase2_implementation.md)
*   **やったこと**: `ConnectivityManager`（通信）と `HealthKitManager`（ヘルスケア）の同時実装。
*   **失敗の要因 (Failure)**: バグが出た時、原因が「コード」なのか「シミュレータ環境」なのか切り分けられなくなった。
*   **理想の進め方 (Success Path)**: **「疑似データ（Mock）」の活用**
    *   HealthKitもConnectivityも、まずは「ダミーデータを返すクラス」で作る。
    *   UIとロジックの動作を確定させてから、最後に本物のAPIを繋ぎこむ。

## 3. 環境設定の壁：Info.plistとシミュレータ (Phase 3)
詳説: [Phase 3: Environment Setup](retrospective/phase3_environment.md)
*   **やったこと**: 後から権限設定を追加しようとして、Xcodeの複雑なUI（Infoタブ）で迷子になった。
*   **失敗の要因 (Failure)**: 最新Xcodeの「Info.plistをファイルとして持たない」仕様による混乱。
*   **理想の進め方 (Success Path)**: **プロジェクト作成時の設定**
    *   プロジェクト作成直後に `Info.plist` を物理ファイルとして生成する設定を行う。
    *   あるいは、開発初期に権限周りの設定を全て済ませておく（実装中に設定画面を行き来しない）。

## 4. 検証フェーズ：ドロ沼化 (Phase 4)
詳説: [Phase 4: Verification](retrospective/phase4_verification.md)
*   **やったこと**: 不安定なシミュレータ間通信を一生懸命デバッグした。
*   **失敗の要因 (Failure)**: 「シミュレータの通信は不安定」という前提を忘れ、コードを疑い続けて疲弊した。
*   **理想の進め方 (Success Path)**: **デバッグ機能の早期実装**
    *   今回最後に作った「Debug: Load Sample」ボタンを、**一番最初**に作るべきだった。
    *   「通信できなくても開発・テストが進められる抜け道」を確保しておく。

## 5. 結論：次回の「勝ち筋」
詳説: [Phase 5: Conclusion](retrospective/phase5_conclusion.md)
*   **スモールスタート**: 「全部入り」ではなく「機能の足し算」で進める。
*   **環境への対抗策**: 開発ツール（Xcode/Simulator）の不安定さを前提にした設計にする。
*   **メンタル維持**: 「動く画面」を常に手元に置いておくことの重要性。

## 6. 番外編：AIとの協働プロセス振り返り (Collaboration)
詳説: [Collaboration Retrospective](retrospective/collaboration_retrospective.md)
*   技術的な問題だけでなく、「AIと人間のコミュニケーション」において何がボトルネックだったかを分析。
*   「認識のズレ」や「指示出しのコツ」についてまとめています。

## 7. 技術補足：Xcode設定管理の手法 (Technical Note)
詳説: [Xcode Configuration Practices](retrospective/xcode_configuration_practices.md)
*   今回問題となった `project.pbxproj` の扱いや `Info.plist` の管理について。
*   手動管理、xcconfig、XcodeGenなどのモダンな手法の比較調査まとめ。
