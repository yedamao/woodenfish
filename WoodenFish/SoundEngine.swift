import AppKit

class SoundEngine {
    private let sound: NSSound? = {
        // "Tock" is a built-in macOS system sound — perfect hollow knock
        if let s = NSSound(named: "Tock") { return s }
        return NSSound(named: "Ping")
    }()

    func playKnock() {
        sound?.stop()
        sound?.play()
    }
}
