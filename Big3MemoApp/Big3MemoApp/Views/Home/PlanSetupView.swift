import SwiftUI

struct PlanSetupView: View {
    @State private var plan: TodayWorkout
    @Binding var isPresented: Bool

    init(plan: TodayWorkout, isPresented: Binding<Bool>) {
        _plan = State(initialValue: plan)
        _isPresented = isPresented
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Settings") {
                    DatePicker("Date", selection: $plan.date, displayedComponents: .date)
                }

                ForEach($plan.exercises, id: \.id) { exerciseBinding in
                    Section(header: Text(exerciseBinding.wrappedValue.exerciseType.rawValue)) {
                        HStack {
                            Text("Target Weight")
                            Spacer()
                            TextField("kg", value: exerciseBinding.targetWeight, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text("kg")
                        }

                        // Plate Calculator
                        PlateCalculatorView(targetWeight: exerciseBinding.wrappedValue.targetWeight)
                            .padding(.vertical, 8)

                        Stepper("Sets: \(exerciseBinding.wrappedValue.targetSets)", value: exerciseBinding.targetSets, in: 1...10)
                        Stepper("Reps: \(exerciseBinding.wrappedValue.targetReps)", value: exerciseBinding.targetReps, in: 1...20)
                    }
                }

                Section {
                    Button("Add Exercise") {
                        // Logic to add exercise (simple append for now)
                        plan.exercises.append(ExercisePlan(exerciseType: .benchPress, targetWeight: 60))
                    }
                }
            }
            .navigationTitle("Workout Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Save logic (e.g., sync to Watch)
                        ConnectivityManager.shared.sendWorkout(plan)
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    PlanSetupView(plan: TodayWorkout.sample, isPresented: .constant(true))
}
