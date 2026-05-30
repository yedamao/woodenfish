import SwiftUI
import AppKit

@MainActor
final class FishViewModel: ObservableObject {
    @Published var isStruck = false
    @Published var strikeCount = 0
    @Published var particles: [Particle] = []

    private let sound = SoundEngine()
    private var monitor: Any?
    private var mouseMonitor: Any?
    private var cursorHideTimer: Timer?
    private var cursorHidden = false

    func startMonitoring() {
        guard monitor == nil else { return }
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 49 {
                Task { @MainActor [weak self] in self?.strike() }
                return nil
            }
            return event
        }
        mouseMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved, .leftMouseDragged]) { [weak self] event in
            Task { @MainActor [weak self] in self?.resetCursorTimer() }
            return event
        }
        resetCursorTimer()
    }

    func stopMonitoring() {
        if let m = monitor { NSEvent.removeMonitor(m) }
        if let m = mouseMonitor { NSEvent.removeMonitor(m) }
        monitor = nil
        mouseMonitor = nil
        cursorHideTimer?.invalidate()
        if cursorHidden { NSCursor.unhide(); cursorHidden = false }
    }

    private func resetCursorTimer() {
        if cursorHidden { NSCursor.unhide(); cursorHidden = false }
        cursorHideTimer?.invalidate()
        cursorHideTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                NSCursor.hide()
                self.cursorHidden = true
            }
        }
    }

    func strike() {
        sound.playKnock()
        strikeCount += 1
        isStruck = true
        Task {
            try? await Task.sleep(nanoseconds: 150_000_000)
            isStruck = false
        }
        spawnParticle()
    }

    private func spawnParticle() {
        let id = UUID()
        particles.append(Particle(id: id, x: CGFloat.random(in: -40...40), y: 0, opacity: 1.0))
        withAnimation(.easeOut(duration: 1.2)) {
            if let idx = particles.firstIndex(where: { $0.id == id }) {
                particles[idx].y = -80
                particles[idx].opacity = 0
            }
        }
        Task {
            try? await Task.sleep(nanoseconds: 1_300_000_000)
            particles.removeAll { $0.id == id }
        }
    }
}

struct ContentView: View {
    @StateObject private var vm = FishViewModel()

    var body: some View {
        GeometryReader { geo in
            let scale = min(geo.size.width / 360, geo.size.height / 420)
            let fishScale = max(scale, 0.6)

            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.97, green: 0.93, blue: 0.85), Color(red: 0.90, green: 0.84, blue: 0.74)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 32 * fishScale) {
                    Text("木鱼")
                        .font(.system(size: 28 * fishScale, weight: .medium, design: .serif))
                        .foregroundColor(Color(red: 0.45, green: 0.22, blue: 0.08))

                    Button(action: { vm.strike() }) {
                        ZStack {
                            WoodenFishView(isStruck: vm.isStruck)
                                .scaleEffect(fishScale)
                                .frame(width: 260 * fishScale, height: 160 * fishScale)

                            ForEach(vm.particles) { p in
                                Text("功德+1")
                                    .font(.system(size: 13 * fishScale, weight: .medium))
                                    .foregroundColor(Color(red: 0.75, green: 0.45, blue: 0.10))
                                    .opacity(p.opacity)
                                    .offset(x: p.x * fishScale, y: p.y * fishScale)
                            }
                        }
                        .frame(width: 300 * fishScale, height: 200 * fishScale)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    Text("功德 \(vm.strikeCount)")
                        .font(.system(size: 16 * fishScale, weight: .regular, design: .serif))
                        .foregroundColor(Color(red: 0.55, green: 0.30, blue: 0.10).opacity(0.8))

                    Text("点击木鱼或按空格键")
                        .font(.system(size: 12 * fishScale))
                        .foregroundColor(Color(red: 0.55, green: 0.40, blue: 0.25).opacity(0.6))
                }
            }
        }
        .frame(minWidth: 360, minHeight: 420)
        .onAppear {
            vm.startMonitoring()
            NSApp.windows.first?.acceptsMouseMovedEvents = true
        }
        .onDisappear { vm.stopMonitoring() }
    }
}

struct Particle: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
}
