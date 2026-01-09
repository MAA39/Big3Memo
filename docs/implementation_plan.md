# Big3Memo Implementation Plan

## Goal Description
Create a "Big3" focused training memo app where the user does not need to touch their iPhone during training. The app uses Apple Watch for all in-training interactions (recording sets, rest timers) and iPhone for pre-training setup and post-training review.

## Architecture
- **Shared**: logic and models shared between iOS and watchOS.
- **iOS App**: Setup menus, history viewing.
- **Watch App**: Active training session, Digital Crown input, Haptic feedback, Background timer.
- **Connectivity**: `WatchConnectivity` for syncing data without a backend server.
- **HealthKit**: `HKWorkoutSession` for "traditional strength training" recording, heart rate tracking, and keeping the Watch app alive during sessions.

## Proposed Changes

### Shared Core
- [x] Models (`ExerciseType`, `WorkoutSet`, `ExercisePlan`, `TodayWorkout`)
- [x] `ConnectivityMessage` (Data transfer object)
- [MODIFY] `WorkoutSet.swift`: Add `rpe: Double?`.
- [NEW] `ConnectivityManager.swift`
    - Wrapper around `WCSession`.
    - `updateApplicationContext`: Sync "Today's Menu".
    - `transferUserInfo`: Sync completed results.
- [NEW] `HealthKitManager.swift`
    - Manage `HKWorkoutSession`.
    - Handle Heart Rate queries.
    - Start/Stop `traditionalStrengthTraining`.

### iOS App
- [NEW] `Big3MemoApp.swift` (App entry point)
- [NEW] `HomeView.swift` (Main dashboard)
- [NEW] `PlanSetupView.swift` (Configure today's workout)
- [NEW] `PlateCalculatorView.swift` (Visual plate guide)

### Watch App
- [NEW] `Big3MemoWatchApp.swift` (App entry point)
- [NEW] `WorkoutTabView.swift` (Main view for watch)
- [NEW] `ActiveWorkoutView.swift`
    - Digital Crown with velocity detection (acceleration).
    - Double Tap gesture (watchOS 10+) for "Next Set".
    - RPE selection after set.
- [NEW] `RestTimerView.swift`
    - Haptic notification 10s before end.
    - Live Activity support (if feasible from Watch->iPhone).

## Verification Plan
### Automated Tests
- Unit tests for Model codable compliance.
- Unit tests for `ConnectivityMessage` serialization.

### Manual Verification
- **Simulator**: Run iOS and Watch simulators together.
- Verify `WCSession` activation.
- Verify data sent from iPhone appears on Watch.
- Verify completion on Watch updates iOS.
- **Physical Device** (User): Verify haptics and background timer behavior.
