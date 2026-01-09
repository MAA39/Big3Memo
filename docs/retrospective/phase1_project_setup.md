# Phase 1: プロジェクトの立ち上げ (Project Setup)

## ❌ やったこと (What We Did)
**「iPhoneアプリ（司令塔）とWatchアプリ（実行部隊）の同時開発」**
*   プロジェクト作成時に `iOS App with Watch App` テンプレートを選択。
*   最初から「iPhoneで入力」→「Watchで受信」→「結果をiPhoneで確認」という完全なサイクルを目指した。

## 💥 失敗の要因 (Failure Analysis)
**「最初からハードルが高すぎた (The "Big Bang" Approach)」**
*   **通信の呪縛**: Apple Watch開発において「iPhoneとの通信 (WatchConnectivity)」は最も不安定でデバッグが難しい要素の一つ。これを初期要件に入れたことで、開発難易度が跳ね上がった。
*   **依存関係の複雑化**: Watch側のUIを確認したいだけなのに、iPhone側からデータを送らないと画面が表示されない（または空の画面しか出ない）状態になり、テストの手数が倍増した。

## ✨ 理想の進め方 (Success Path)
**「Watch単体アプリ（Independent App）から始める」**
1.  **Watch Only**: Xcodeプロジェクト作成時、まずはWatch単体で動くテンプレートを選ぶ（あるいはiOS側は無視する）。
2.  **Hardcoded Data**: メニュー（Bench Press 60kgなど）は、通信で受け取るのではなく、最初はコード内で固定値（ハードコード）として持たせる。
3.  **Local MVP**: Watchだけで「メニュー選択」→「ワークアウト実行」→「ログ保存」が動く状態を作る。
4.  **Add Connectivity Later**: Watch単体で完璧に動いてから、初めて「メニューをiPhoneから受け取る機能」を追加する。

**教訓:**
> 「通信」は機能のスパイスであり、土台にしてはいけない。
