import SwiftUI

struct HomeView: View {
    // 将来的にSwiftData等から読み込むが、一旦Stateで保持
    @State private var todayWorkout: TodayWorkout = .sample
    @State private var showPlanSetup = false

    // Connectivityからの更新を受け取る
    @State private var receivedUpdates: [SetUpdate] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Today's Plan Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Today's Workout")
                                .font(.title2.bold())
                            Spacer()
                            Button("Edit") {
                                showPlanSetup = true
                            }
                        }

                        ForEach(todayWorkout.exercises, id: \ExercisePlan.id) { (exercise: ExercisePlan) in
                            HStack {
                                Image(systemName: exerciseIcon(for: exercise.exerciseType))
                                    .font(.title3)
                                    .frame(width: 30)

                                VStack(alignment: .leading) {
                                    Text(exercise.exerciseType.rawValue)
                                        .font(.headline)
                                    Text("\(String(format: "%.1f", exercise.targetWeight))kg × \(exercise.targetSets) sets")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                // Simple progress ring or status
                                if exercise.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else {
                                    Text("\(completedSets(for: exercise))/\(exercise.targetSets)")
                                        .font(.body.monospacedDigit())
                                }
                            }
                            .padding(.vertical, 4)
                            Divider()
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)

                    // Recent History (Stub)
                    VStack(alignment: .leading) {
                        Text("Recent History")
                            .font(.title2.bold())

                        Text("No history yet.")
                            .foregroundStyle(.secondary)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .navigationTitle("Big3 Memo")
            .sheet(isPresented: $showPlanSetup) {
                PlanSetupView(plan: todayWorkout, isPresented: $showPlanSetup)
            }
            .onAppear {
                // Sync initial state to watch (in case it wasn't sent)
                ConnectivityManager.shared.sendWorkout(todayWorkout)

                // Listen for updates
                NotificationCenter.default.addObserver(forName: .connectivityDidReceiveSetUpdate, object: nil, queue: .main) { notification in
                    if let update = notification.object as? SetUpdate {
                        handleSetUpdate(update)
                    }
                }
            }
        }
    }

    private func exerciseIcon(for type: ExerciseType) -> String {
        switch type {
        case .benchPress: return "scalemass"
        case .squat: return "figure.strengthtraining.traditional"
        case .deadlift: return "dumbbell"
        }
    }

    private func completedSets(for exercise: ExercisePlan) -> Int {
        exercise.sets.filter { $0.isCompleted }.count
    }

    private func handleSetUpdate(_ update: SetUpdate) {
        guard update.exerciseIndex < todayWorkout.exercises.count else { return }
        var exercise = todayWorkout.exercises[update.exerciseIndex]

        // 配列が足りない場合は埋める (簡易実装)
        while exercise.sets.count <= update.setIndex {
            exercise.sets.append(WorkoutSet(weight: exercise.targetWeight, reps: exercise.targetReps))
        }

        exercise.sets[update.setIndex] = update.set
        todayWorkout.exercises[update.exerciseIndex] = exercise
    }
}

#Preview {
    HomeView()
}
