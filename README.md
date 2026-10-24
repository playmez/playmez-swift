# PlaymezEmbed for iOS

Put a [Playmez](https://playmez.com) game in your iOS app. A `WKWebView`-backed `UIView` plus a SwiftUI wrapper that relay the game's events. iOS 14+. Points are virtual, non-transferable and worth nothing.

## Install (Swift Package Manager)

Xcode: File → Add Package Dependencies → `https://github.com/playmez/playmez-swift`, from `2.0.0`.

```swift
.package(url: "https://github.com/playmez/playmez-swift", from: "2.0.0")
```

## Use

```swift
import PlaymezEmbed

// SwiftUI. launchUrl comes from YOUR backend (POST /partner/launch); never ship the API key.
PlaymezGame(launchUrl: launchUrl, onEvent: { e in if e.type == "result" { print(e.won ? "won" : "lost", e.net) } }, onClose: { dismiss() })

// UIKit
let game = PlaymezGameView()
game.onEvent = { e in print(e.type, e.game ?? "", e.net) }
game.onClose = { [weak self] in self?.dismiss(animated: true) }
view.addSubview(game)
game.open(launchUrl: launchUrl)
```

Events: `ready` (`game`), `result` (`game`, `won`, `net`), `close`, `error` (`code`, `message`), `resize` (`height`).

Voice at shared tables (only when Playmez switched it on for you): the view grants microphone capture to the game origin; add `NSMicrophoneUsageDescription` to Info.plist, or set `allowMicrophone = false`.

Full guide: https://playmez.com/developers

MIT © Playmez
