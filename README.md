# Knock the Wooden Fish 木鱼

A tiny, meditative macOS app. Tap a wooden fish, hear a hollow *tok*, and watch
your merit (功德) tick upward.

<img width="897" height="448" alt="image" src="https://github.com/user-attachments/assets/136e9bf7-a098-477c-a611-be6d20fa47ad" />

## Features

- 🪵 A hand-drawn wooden fish, rendered entirely with SwiftUI shapes
- 👆 Strike it by **clicking anywhere** or pressing the **spacebar**
- 🔔 A satisfying knock sound on every hit
- ✨ Floating **功德+1** merit particles and a running counter
- 🖥️ Resizable and **full-screen** capable — the fish scales to the window
- 🫥 The cursor **auto-hides** after a couple seconds of stillness
- 🎨 Custom app icon

## Install

Download the latest `WoodenFish.dmg` from the
[**Releases**](https://github.com/yedamao/woodenfish/releases) page.

1. Open the DMG and drag **WoodenFish** into **Applications**.
2. This app is **not notarized** by Apple, so the first launch is blocked.
   Clear the download quarantine flag, then open it:

   ```bash
   xattr -dr com.apple.quarantine /Applications/WoodenFish.app
   open /Applications/WoodenFish.app
   ```

   > Alternatively: right-click the app → **Open** → **Open**.

## Usage

| Action | Result |
|--------|--------|
| Click anywhere / press <kbd>Space</kbd> | Strike the fish |
| Green traffic-light button / **View → Enter Full Screen** | Full screen |
| Stop moving the mouse | Cursor hides after ~2s |

## Build from source

Requires **Xcode 15+** and **macOS 14+**.

```bash
git clone https://github.com/yedamao/woodenfish.git
cd woodenfish
open WoodenFish.xcodeproj   # then ⌘R in Xcode
```

Or from the command line:

```bash
xcodebuild -project WoodenFish.xcodeproj -scheme WoodenFish -configuration Release build
```

## Project structure

```
woodenfish/
├── WoodenFish.xcodeproj/
├── WoodenFish/
│   ├── WoodenFishApp.swift     # App entry point & window config
│   ├── ContentView.swift       # UI, input handling, merit logic
│   ├── WoodenFishShape.swift    # The fish drawn with SwiftUI Path
│   ├── SoundEngine.swift       # Knock sound playback
│   └── Assets.xcassets/        # App icon
└── .github/workflows/release.yml  # CI: build DMG + publish to Releases
```

## Releases & CI

Pushing a version tag (`vX.Y.Z`) triggers
[`.github/workflows/release.yml`](.github/workflows/release.yml), which builds a
Release DMG, ad-hoc signs it, and attaches it to a new GitHub Release.

```bash
git tag v1.0.0
git push origin v1.0.0
```

> The CI build is **ad-hoc signed but not notarized**. Distributing without the
> Gatekeeper prompt requires an Apple Developer ID and a notarization step.

