import SwiftUI

@main
struct Big3MemoApp_Watch_AppApp: App {
    private let connectivityManager = ConnectivityManager.shared
    private let healthKitManager = HealthKitManager.shared

    var body: some Scene {
        WindowGroup {
            WorkoutTabView()
                .environment(connectivityManager)
                .environment(healthKitManager)
        }
    }
}
