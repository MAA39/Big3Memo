import Foundation
import WatchConnectivity
import os

@Observable
final class ConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = ConnectivityManager()

    var receivedWorkout: TodayWorkout?
    var isReachable: Bool = false

    // ログ用
    private let logger = Logger(subsystem: "com.maa.Big3Memo", category: "Connectivity")

    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // MARK: - Sending Methods

    /// iPhone -> Watch: 今日のメニューを送信 (ApplicationContext)
    func sendWorkout(_ workout: TodayWorkout) {
        guard WCSession.default.activationState == .activated else { return }

        do {
            let message = try ConnectivityMessage.syncWorkout(workout)
            let dict = try message.toDictionary()

            try WCSession.default.updateApplicationContext(dict)
            logger.info("Sent workout context")
        } catch {
            logger.error("Failed to send workout: \(error)")
        }
    }

    /// Watch -> iPhone: セット完了を送信 (UserInfo - バックグラウンド転送)
    func sendSetUpdate(exerciseIndex: Int, setIndex: Int, set: WorkoutSet) {
        guard WCSession.default.activationState == .activated else { return }

        do {
            let message = try ConnectivityMessage.updateSet(exerciseIndex: exerciseIndex, setIndex: setIndex, set: set)
            let dict = try message.toDictionary()

            WCSession.default.transferUserInfo(dict)
            logger.info("Queued set update")
        } catch {
            logger.error("Failed to send set update: \(error)")
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
        logger.info("Session activation completed: \(activationState.rawValue)")
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }

    // MARK: - Receiving Methods

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        handleIncomingDictionary(applicationContext)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        handleIncomingDictionary(userInfo)
    }

    private func handleIncomingDictionary(_ dict: [String: Any]) {
        do {
            let message = try ConnectivityMessage.fromDictionary(dict)
            DispatchQueue.main.async {
                self.processMessage(message)
            }
        } catch {
            logger.error("Failed to decode incoming message: \(error)")
        }
    }

    private func processMessage(_ message: ConnectivityMessage) {
        switch message.type {
        case .syncWorkout:
            if let workout = try? JSONDecoder().decode(TodayWorkout.self, from: message.payload) {
                self.receivedWorkout = workout
                logger.info("Received workout sync")
            }
        case .updateSet:
            if let update = try? JSONDecoder().decode(SetUpdate.self, from: message.payload) {
                // ここでreceivedWorkoutを更新するロジックが必要だが、
                // 片方向フロー（Watchはコンテキストを受け取る、iPhoneはUserInfoを受け取る）
                // になるため、受信側の処理はアプリの状態管理に委譲するかNotificationを飛ばすのが良い
                NotificationCenter.default.post(name: .connectivityDidReceiveSetUpdate, object: update)
                logger.info("Received set update notification")
            }
        case .requestWorkout, .workoutCompleted:
            break
        }
    }

    // iOS specific stubs
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}

extension Notification.Name {
    static let connectivityDidReceiveSetUpdate = Notification.Name("connectivityDidReceiveSetUpdate")
}
