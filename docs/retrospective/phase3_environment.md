# Phase 3: 環境設定の壁 (Environment Setup)

## ❌ やったこと (What We Did)
**「Xcode UIからの設定変更に固執」**
*   HealthKitの利用に必要な `Info.plist` の権限追加を、XcodeのGUI（Target > Info）から行おうとした。
*   ユーザー側で正しいターゲット（Watch App）が見つけられず、設定漏れが発生した。
*   結果、アプリが起動直後にクラッシュ（Crash on Launch）する状態が続いた。

## 💥 失敗の要因 (Failure Analysis)
**「モダンXcodeの罠 (Invisible Info.plist)」**
*   最近のXcodeは `Info.plist` ファイルをプロジェクト内に作らず、ビルド設定（Build Settings）の中に埋め込む仕様がデフォルトになっている。
*   このため、「ファイルをテキストエディタで開いてコピペする」という確実な手が使えず、複雑なXcodeのUI操作を強いることになった。
*   テキストチャット越しにGUIの場所を指示するのは限界があった（"上から4番目のアイコン"などの曖昧な指示）。

## ✨ 理想の進め方 (Success Path)
**「設定ファイルの明示的な作成」**
1.  **Create Info.plist**: プロジェクト開始直後、設定で「GENERATE_INFOPLIST_FILE = NO」にし、物理的な `Info.plist` ファイルを作成する。
2.  **Code as Config**: 設定をすべてファイル（XML）として管理する。
    *   これにより、今回のようにチャットで「このコードを `Info.plist` に貼り付けてください」と指示するだけで解決できたはず。
3.  **Early Permission Check**: 実装コードを書く前に、空のアプリで「権限ポップアップが出るか」だけを最初に確認する。

**教訓:**
> UIでの設定操作はミスの温床。可能な限り「ファイル編集」で完結する方法を選ぶ。
