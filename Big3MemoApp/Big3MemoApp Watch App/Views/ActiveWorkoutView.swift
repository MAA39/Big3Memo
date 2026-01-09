import SwiftUI
import WatchKit

struct ActiveWorkoutView: View {
    let exerciseIndex: Int
    @State var exercise: ExercisePlan

    @SceneStorage("ActiveWorkoutView.isResting") private var isResting = false
    @SceneStorage("ActiveWorkoutView.currentSetIndex") private var currentSetIndex = 0
    @State private var inputWeight: Double = 0
    @State private var inputReps: Int = 0

    // For RPE Selection
    @State private var showRPESelection = false
    @State private var selectedRPE: Double = 8.0

    @Environment(ConnectivityManager.self) var connectivity

    var currentTargetSet: Int {
        if currentSetIndex < exercise.sets.count {
            return currentSetIndex + 1 // 1-based for display
        }
        return exercise.sets.count + 1
    }

    var body: some View {
        TabView(selection: Binding(
            get: { isResting ? 1 : 0 },
            set: { _ in } // Tab changes controlled by logic
        )) {
            // Recording View
            VStack {
                Text("\(exercise.exerciseType.rawValue) - Set \(currentTargetSet)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack {
                    // Weight Input (Digital Crown)
                    VStack {
                        Text("Weight")
                            .font(.system(size: 10))
                        Text("\(inputWeight, specifier: "%.1f")")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.blue)
                            .focusable()
                            .digitalCrownRotation(
                                $inputWeight,
                                from: 0,
                                through: 300,
                                by: 2.5,
                                sensitivity: .medium,
                                isContinuous: false,
                                isHapticFeedbackEnabled: true
                            )
                    }

                    Spacer()

                    // Reps Input (Stepper or Digital Crown - simplified to buttons for space)
                    VStack {
                        Text("Reps")
                            .font(.system(size: 10))
                        HStack {
                            Button("-") { if inputReps > 0 { inputReps -= 1 } }
                                .buttonStyle(.borderless)
                            Text("\(inputReps)")
                                .font(.system(size: 24, weight: .bold))
                            Button("+") { inputReps += 1 }
                                .buttonStyle(.borderless)
                        }
                    }
                }
                .padding()

                Spacer()

                Button(action: {
                    showRPESelection = true
                }) {
                    Text("Complete Set")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
                .background(Color.green)
                .cornerRadius(20)
            }
            .tag(0)
            .sheet(isPresented: $showRPESelection) {
                VStack {
                    Text("RPE (1-10)")
                    Text("\(selectedRPE, specifier: "%.1f")")
                        .font(.title2)
                        .focusable()
                        .digitalCrownRotation(
                            $selectedRPE,
                            from: 1,
                            through: 10,
                            by: 0.5,
                            sensitivity: .high,
                            isContinuous: false,
                            isHapticFeedbackEnabled: true
                        )
                    Button("Save") {
                        completeSet()
                        showRPESelection = false
                    }
                }
            }
            .onAppear {
                // Initialize with target values
                if inputWeight == 0 {
                    inputWeight = exercise.targetWeight
                    inputReps = exercise.targetReps
                }
            }

            // Rest View
            RestTimerView(duration: 180) { // 3 minutes
                isResting = false
                WKInterfaceDevice.current().play(.success)
            }
            .tag(1)
        }
        .navigationBarBackButtonHidden(isResting)
    }

    private func completeSet() {
        // Create new set result
        let newSet = WorkoutSet(
            weight: inputWeight,
            reps: inputReps,
            isCompleted: true,
            completedAt: Date()
        )
        // Set RPE
        var completedSet = newSet
        completedSet.complete(rpe: selectedRPE)

        // Update local state temporarily (sync handling is in HomeView mainly)
        if currentSetIndex < exercise.sets.count {
            exercise.sets[currentSetIndex] = completedSet
        } else {
            exercise.sets.append(completedSet)
        }

        // Send to Phone
        connectivity.sendSetUpdate(exerciseIndex: exerciseIndex, setIndex: currentSetIndex, set: completedSet)

        // Advance
        currentSetIndex += 1
        isResting = true
    }
}
