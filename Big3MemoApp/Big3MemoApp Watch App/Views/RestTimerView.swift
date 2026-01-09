import SwiftUI
import WatchKit
import Combine

struct RestTimerView: View {
    let duration: TimeInterval
    let onFinish: () -> Void

    @State private var timeRemaining: TimeInterval
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(duration: TimeInterval, onFinish: @escaping () -> Void) {
        self.duration = duration
        self.onFinish = onFinish
        _timeRemaining = State(initialValue: duration)
    }

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.blue)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(timeRemaining / duration, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear(duration: 1), value: timeRemaining)

                Text("\(Int(timeRemaining))")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
            }
            .padding()

            Button("Skip") {
                onFinish()
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1

                // Pre-notification at 10 seconds
                if timeRemaining == 10 {
                    WKInterfaceDevice.current().play(.directionUp)
                }
            } else {
                timer.upstream.connect().cancel()
                WKInterfaceDevice.current().play(.notification)
                onFinish()
            }
        }
        .onAppear {
            // Enable background run for timer
            // Note: In a real app, we rely on WKExtendedRuntimeSession handled by HealthKit or separate session
        }
    }
}

#Preview {
    RestTimerView(duration: 10) {}
}
