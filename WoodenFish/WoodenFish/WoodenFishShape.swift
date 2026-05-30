import SwiftUI

struct WoodenFishShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = rect.midX
        let cy = rect.midY

        // Main body - wide oval fish shape
        path.addEllipse(in: CGRect(x: cx - w * 0.42, y: cy - h * 0.30, width: w * 0.84, height: h * 0.58))

        // Tail fin (right side)
        path.move(to: CGPoint(x: cx + w * 0.38, y: cy))
        path.addCurve(
            to: CGPoint(x: cx + w * 0.50, y: cy - h * 0.22),
            control1: CGPoint(x: cx + w * 0.44, y: cy - h * 0.06),
            control2: CGPoint(x: cx + w * 0.50, y: cy - h * 0.14)
        )
        path.addCurve(
            to: CGPoint(x: cx + w * 0.38, y: cy),
            control1: CGPoint(x: cx + w * 0.44, y: cy - h * 0.06),
            control2: CGPoint(x: cx + w * 0.40, y: cy - h * 0.02)
        )
        path.move(to: CGPoint(x: cx + w * 0.38, y: cy))
        path.addCurve(
            to: CGPoint(x: cx + w * 0.50, y: cy + h * 0.22),
            control1: CGPoint(x: cx + w * 0.44, y: cy + h * 0.06),
            control2: CGPoint(x: cx + w * 0.50, y: cy + h * 0.14)
        )
        path.addCurve(
            to: CGPoint(x: cx + w * 0.38, y: cy),
            control1: CGPoint(x: cx + w * 0.44, y: cy + h * 0.06),
            control2: CGPoint(x: cx + w * 0.40, y: cy + h * 0.02)
        )

        return path
    }
}

struct WoodenFishView: View {
    var isStruck: Bool

    private let bodyColor   = Color(red: 0.65, green: 0.32, blue: 0.10)
    private let shadowColor = Color(red: 0.45, green: 0.20, blue: 0.05)
    private let highlightColor = Color(red: 0.85, green: 0.55, blue: 0.28)

    var body: some View {
        ZStack {
            // Shadow layer
            WoodenFishShape()
                .fill(shadowColor)
                .offset(x: 4, y: 6)
                .blur(radius: 8)

            // Main body
            WoodenFishShape()
                .fill(
                    RadialGradient(
                        colors: [highlightColor, bodyColor, shadowColor],
                        center: UnitPoint(x: 0.35, y: 0.30),
                        startRadius: 0,
                        endRadius: 130
                    )
                )

            // Wood grain lines
            WoodenFishShape()
                .stroke(shadowColor.opacity(0.35), lineWidth: 1)

            // Hollow mouth slit
            Capsule()
                .fill(Color.black.opacity(0.75))
                .frame(width: 28, height: 8)
                .offset(x: -52, y: 4)

            // Eye
            Circle()
                .fill(Color.black)
                .frame(width: 10, height: 10)
                .offset(x: -48, y: -10)

            Circle()
                .fill(Color.white.opacity(0.7))
                .frame(width: 4, height: 4)
                .offset(x: -46, y: -12)
        }
        .frame(width: 260, height: 160)
        .scaleEffect(isStruck ? 0.93 : 1.0)
        .rotationEffect(isStruck ? .degrees(-3) : .degrees(0))
        .animation(.spring(response: 0.12, dampingFraction: 0.4), value: isStruck)
    }
}
