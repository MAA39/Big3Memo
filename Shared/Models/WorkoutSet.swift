import Foundation

/// 1セットの記録
struct WorkoutSet: Codable, Identifiable, Equatable {
    let id: UUID
    var weight: Double      // kg
    var reps: Int           // 回数
    var isCompleted: Bool
    var completedAt: Date?
    
    init(
        id: UUID = UUID(),
        weight: Double,
        reps: Int,
        isCompleted: Bool = false,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
        self.completedAt = completedAt
    }
    
    /// セット完了をマーク
    mutating func complete() {
        isCompleted = true
        completedAt = Date()
    }
    
    /// ボリューム（重量 × 回数）
    var volume: Double {
        weight * Double(reps)
    }
}
