import Foundation

/// Big3の種目
enum ExerciseType: String, Codable, CaseIterable, Identifiable {
    case benchPress = "bench_press"
    case squat = "squat"
    case deadlift = "deadlift"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .benchPress: return "ベンチプレス"
        case .squat: return "スクワット"
        case .deadlift: return "デッドリフト"
        }
    }
    
    var shortName: String {
        switch self {
        case .benchPress: return "BP"
        case .squat: return "SQ"
        case .deadlift: return "DL"
        }
    }
    
    var emoji: String {
        switch self {
        case .benchPress: return "🏋️"
        case .squat: return "🦵"
        case .deadlift: return "💪"
        }
    }
}
