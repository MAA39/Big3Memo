import Foundation

/// 今日のトレーニング全体
struct TodayWorkout: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date
    var exercises: [ExercisePlan]
    var startedAt: Date?
    var finishedAt: Date?
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        exercises: [ExercisePlan] = []
    ) {
        self.id = id
        self.date = date
        self.exercises = exercises
    }
    
    /// トレーニング開始
    mutating func start() {
        startedAt = Date()
    }
    
    /// トレーニング終了
    mutating func finish() {
        finishedAt = Date()
    }
    
    /// 現在進行中の種目インデックス
    var currentExerciseIndex: Int? {
        exercises.firstIndex { !$0.isCompleted }
    }
    
    /// 現在進行中の種目
    var currentExercise: ExercisePlan? {
        guard let index = currentExerciseIndex else { return nil }
        return exercises[index]
    }
    
    /// 全種目完了したか
    var isCompleted: Bool {
        exercises.allSatisfy { $0.isCompleted }
    }
    
    /// トレーニング時間（分）
    var durationMinutes: Int? {
        guard let start = startedAt else { return nil }
        let end = finishedAt ?? Date()
        return Int(end.timeIntervalSince(start) / 60)
    }
    
    /// 総ボリューム
    var totalVolume: Double {
        exercises.reduce(0) { $0 + $1.totalVolume }
    }
}

// MARK: - Sample Data for Preview
extension TodayWorkout {
    static var sample: TodayWorkout {
        TodayWorkout(
            exercises: [
                ExercisePlan(exerciseType: .benchPress, targetWeight: 60),
                ExercisePlan(exerciseType: .squat, targetWeight: 80),
                ExercisePlan(exerciseType: .deadlift, targetWeight: 100)
            ]
        )
    }
}
