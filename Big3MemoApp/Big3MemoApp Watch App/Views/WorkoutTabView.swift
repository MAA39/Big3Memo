import SwiftUI

struct WorkoutTabView: View {
    @Environment(ConnectivityManager.self) var connectivity
    @Environment(HealthKitManager.self) var healthKit

    // 現在のメニュー（ConnectivityManagerから取得）
    var workout: TodayWorkout? {
        connectivity.receivedWorkout
    }

    var body: some View {
        NavigationStack {
            if let workout = workout {
                List {
                    Section("Today's Plan") {
                        ForEach(workout.exercises.indices, id: \.self) { index in
                            let exercise = workout.exercises[index]
                            NavigationLink(destination: ActiveWorkoutView(exerciseIndex: index, exercise: exercise)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(exercise.exerciseType.rawValue)
                                            .font(.headline)
                                        Text("\(String(format: "%.1f", exercise.targetWeight))kg")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    if exercise.isCompleted {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                    }
                                }
                            }
                        }
                    }

                    if healthKit.isWorkoutActive {
                        Section("Status") {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                                Text("\(Int(healthKit.heartRate)) bpm")
                            }
                            Button("End Session") {
                                Task {
                                    await healthKit.endWorkout()
                                }
                            }
                            .foregroundStyle(.red)
                        }
                    } else {
                        Button("Start Session") {
                            Task {
                                try? await healthKit.requestAuthorization()
                                try? await healthKit.startWorkout()
                            }
                        }
                        .foregroundStyle(.green)
                    }
                }
                .navigationTitle("Big3 Memo")
            } else {
                VStack {
                    Image(systemName: "iphone.gen3.badge.play")
                        .font(.largeTitle)
                        .padding()
                    Text("Open iPhone app to\nsetup workout")
                        .multilineTextAlignment(.center)

                    Button("Debug: Load Sample") {
                        connectivity.receivedWorkout = .sample
                    }
                    .tint(.blue)
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    WorkoutTabView()
        .environment(ConnectivityManager.shared)
        .environment(HealthKitManager.shared)
}
