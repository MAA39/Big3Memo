import Foundation

/// WatchConnectivity で送受信するメッセージの種類
enum ConnectivityMessageType: String, Codable {
    case syncWorkout        // iPhoneからWatchへトレーニング同期
    case updateSet          // WatchからiPhoneへセット完了通知
    case requestWorkout     // WatchからiPhoneへトレーニング要求
    case workoutCompleted   // トレーニング完了通知
}

/// WatchConnectivity メッセージ
struct ConnectivityMessage: Codable {
    let type: ConnectivityMessageType
    let payload: Data
    let timestamp: Date
    
    init(type: ConnectivityMessageType, payload: Data) {
        self.type = type
        self.payload = payload
        self.timestamp = Date()
    }
    
    /// TodayWorkoutをメッセージに変換
    static func syncWorkout(_ workout: TodayWorkout) throws -> ConnectivityMessage {
        let data = try JSONEncoder().encode(workout)
        return ConnectivityMessage(type: .syncWorkout, payload: data)
    }
    
    /// セット更新をメッセージに変換
    static func updateSet(exerciseIndex: Int, setIndex: Int, set: WorkoutSet) throws -> ConnectivityMessage {
        let update = SetUpdate(exerciseIndex: exerciseIndex, setIndex: setIndex, set: set)
        let data = try JSONEncoder().encode(update)
        return ConnectivityMessage(type: .updateSet, payload: data)
    }
    
    /// Dictionary変換（WatchConnectivityで送信用）
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw ConnectivityError.encodingFailed
        }
        return dict
    }
    
    /// Dictionaryから復元
    static func fromDictionary(_ dict: [String: Any]) throws -> ConnectivityMessage {
        let data = try JSONSerialization.data(withJSONObject: dict)
        return try JSONDecoder().decode(ConnectivityMessage.self, from: data)
    }
}

/// セット更新情報
struct SetUpdate: Codable {
    let exerciseIndex: Int
    let setIndex: Int
    let set: WorkoutSet
}

/// 通信エラー
enum ConnectivityError: Error {
    case encodingFailed
    case decodingFailed
    case sessionNotAvailable
    case watchNotReachable
}
