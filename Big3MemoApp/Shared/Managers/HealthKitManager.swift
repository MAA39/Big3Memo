import Foundation
import HealthKit
import os

@Observable
class HealthKitManager: NSObject {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    private let logger = Logger(subsystem: "com.maa.Big3Memo", category: "HealthKit")

    var isWorkoutActive = false
    var heartRate: Double = 0

    #if os(watchOS)
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    #endif

    override init() {
        super.init()
    }

    /// HealthKitの権限リクエスト
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
    }

    // MARK: - WatchOS Specific
    #if os(watchOS)

    /// ワークアウト開始 (Traditional Strength Training)
    func startWorkout() async throws {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .traditionalStrengthTraining
        configuration.locationType = .indoor

        session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        builder = session?.associatedWorkoutBuilder()

        session?.delegate = self
        builder?.delegate = self

        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

        session?.startActivity(with: Date())

        if let builder = builder {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                builder.beginCollection(withStart: Date()) { success, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            }
        }

        isWorkoutActive = true
        logger.info("Workout session started")
    }

    /// ワークアウト終了
    func endWorkout() async {
        guard let session = session, let builder = builder else { return }

        session.end()
        do {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                builder.endCollection(withEnd: Date()) { success, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            }

            try await builder.finishWorkout()
            isWorkoutActive = false
            logger.info("Workout session ended")
        } catch {
            logger.error("Failed to end workout: \(error)")
        }
    }



    private func updateMetrics(statistics: HKStatistics) {
        if statistics.quantityType == HKQuantityType.quantityType(forIdentifier: .heartRate) {
            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
        }
    }

    #endif
}

#if os(watchOS)
extension HealthKitManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    // MARK: - HKWorkoutSessionDelegate

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        logger.info("Session state changed: \(toState.rawValue)")
        if toState == .ended {
            self.isWorkoutActive = false
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        logger.error("Workout session failed: \(error)")
    }

    // MARK: - HKLiveWorkoutBuilderDelegate

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            guard let statistics = workoutBuilder.statistics(for: quantityType) else { continue }

            DispatchQueue.main.async {
                self.updateMetrics(statistics: statistics)
            }
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
}
#endif
