import Foundation

/// 1セットの記録
struct WorkoutSet: Codable, Identifiable, Equatable {
    let id: UUID
    var weight: Double      // kg
    var reps: Int           // 回数
    var isCompleted: Bool
    var rpe: Double?        // 自覚的運動強度 (1-10)
    var completedAt: Date?

    init(
        id: UUID = UUID(),
        weight: Double,
        reps: Int,
        isCompleted: Bool = false,
        rpe: Double? = nil,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.rpe = rpe
    }

    /// セット完了をマーク
    mutating func complete(rpe: Double? = nil) {
        isCompleted = true
        completedAt = Date()
        self.rpe = rpe
    }

    /// ボリューム（重量 × 回数）
    var volume: Double {
        weight * Double(reps)
    }
}
