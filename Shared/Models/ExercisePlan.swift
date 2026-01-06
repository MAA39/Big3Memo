import Foundation

/// 種目ごとの計画（セット数、目標重量、休憩時間）
struct ExercisePlan: Codable, Identifiable, Equatable {
    let id: UUID
    let exerciseType: ExerciseType
    var targetWeight: Double        // 目標重量 (kg)
    var targetReps: Int             // 目標レップ数
    var numberOfSets: Int           // セット数
    var restTimeSeconds: Int        // 休憩時間 (秒)
    var sets: [WorkoutSet]          // 実際のセット記録
    
    init(
        id: UUID = UUID(),
        exerciseType: ExerciseType,
        targetWeight: Double,
        targetReps: Int = 5,
        numberOfSets: Int = 5,
        restTimeSeconds: Int = 180
    ) {
        self.id = id
        self.exerciseType = exerciseType
        self.targetWeight = targetWeight
        self.targetReps = targetReps
        self.numberOfSets = numberOfSets
        self.restTimeSeconds = restTimeSeconds
        
        // 初期セットを生成
        self.sets = (0..<numberOfSets).map { _ in
            WorkoutSet(weight: targetWeight, reps: targetReps)
        }
    }
    
    /// 完了したセット数
    var completedSetsCount: Int {
        sets.filter { $0.isCompleted }.count
    }
    
    /// 全セット完了したか
    var isCompleted: Bool {
        completedSetsCount >= numberOfSets
    }
    
    /// 次のセットのインデックス
    var nextSetIndex: Int? {
        sets.firstIndex { !$0.isCompleted }
    }
    
    /// 総ボリューム
    var totalVolume: Double {
        sets.filter { $0.isCompleted }.reduce(0) { $0 + $1.volume }
    }
}
