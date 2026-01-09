import SwiftUI

struct PlateCalculatorView: View {
    let targetWeight: Double
    let barWeight: Double = 20.0

    // カラーコード: 競技用プレート基準
    // 25kg: Red, 20kg: Blue, 15kg: Yellow, 10kg: Green, 5kg: White, 2.5kg: Black/Red, 1.25kg: Silver
    let plates: [(weight: Double, color: Color, size: CGFloat)] = [
        (25.0, .red, 100),
        (20.0, .blue, 95),
        (15.0, .yellow, 90),
        (10.0, .green, 85),
        (5.0, .white, 70),
        (2.5, .black, 60),
        (1.25, .gray, 50)
    ]

    var neededPlates: [Double] {
        var remaining = (targetWeight - barWeight) / 2
        var result: [Double] = []

        if remaining <= 0 { return [] }

        for plate in plates {
            while remaining >= plate.weight {
                result.append(plate.weight)
                remaining -= plate.weight
            }
        }
        return result
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("片側: \(String(format: "%.2f", (targetWeight - barWeight) / 2)) kg")
                .font(.headline)
                .foregroundStyle(.secondary)

            HStack(spacing: 2) {
                // Barbell Sleeve (Inner)
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 20, height: 30)

                ForEach(neededPlates.indices, id: \.self) { index in
                    let weight = neededPlates[index]
                    let plateInfo = plates.first(where: { $0.weight == weight })!

                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(plateInfo.color)
                            .frame(width: 15, height: plateInfo.size)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                            )

                        // Small weight text for thicker plates
                        if plateInfo.size > 60 {
                            Text(String(format: "%.0f", weight))
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(weight == 5.0 ? .black : .white)
                                .rotationEffect(.degrees(-90))
                        }
                    }
                }

                // Barbell Sleeve (Outer)
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 40, height: 20)

                Spacer()
            }
            .frame(height: 120)
            .padding(.horizontal)
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(12)
        }
    }
}

#Preview {
    VStack {
        PlateCalculatorView(targetWeight: 100)
        PlateCalculatorView(targetWeight: 142.5)
        PlateCalculatorView(targetWeight: 60)
    }
}
