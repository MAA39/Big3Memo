import SwiftUI

@main
struct Big3MemoAppApp: App {
    // インスタンスを保持して初期化させる
    private let connectivityManager = ConnectivityManager.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
