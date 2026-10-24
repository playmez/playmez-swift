# Spinline SDK changelog

All five packages (`playmez-embed`, `playmez-embed-react-native`, `playmez_embed`, `com.playmez:embed`, `PlaymezEmbed`) share one version, kept in `sdk/VERSION`.

## 2.0.0

- Renamed to Playmez. New package names: `playmez-embed` and `playmez-embed-react-native` (npm), `playmez_embed` (pub.dev), `com.github.playmez:playmez-android` (JitPack, package `com.playmez.embed`) and the Swift package `PlaymezEmbed` at `github.com/playmez/playmez-swift`. Classes follow: `PlaymezGame`, `PlaymezGameView`, `PlaymezEvent`, `PlaymezBridge`.
- Web: the script sets `window.Playmez`; `window.Spinline` stays as a deprecated alias and `https://playmez.com/sdk/spinline.js` keeps serving the same bundle until 3.0.
- Webhooks: headers are `Playmez-Event`, `Playmez-Delivery`, `Playmez-Timestamp`, `Playmez-Signature` and `Playmez-Attempt`; the `Spinline-*` names are sent alongside until 3.0. The user agent is `Playmez-Webhooks/2.0`.
- Wire protocol unchanged: embed messages still carry `source: "spinline"`, so 1.x packages keep working against playmez.com.
- The 1.x packages are deprecated and receive no further releases.

## 1.0.2

- Android: the library ships its own Gradle 8.11.1 wrapper and JitPack builds with it, so the `com.github.anoopKumarChaudhary:spinline-android` artifact resolves again (1.0.1 never built there). No code change for any package.

## 1.0.1

- Canonical hosts: documentation, package homepages, the web bundle banner and the drop-in headers now point at `https://playmez.com` and `https://api.playmez.com`. No behaviour change; the launch URL's origin is still read from the launch response.

## 1.0.0

- First published release. Web `mount()`, React `<SpinlineGame>`, React Native `<SpinlineGame>`, Flutter `SpinlineGame`, Android `SpinlineGameView`, iOS `SpinlineGameView` + SwiftUI `SpinlineGame`.
- Every package relays the game's `ready`, `result`, `close`, `error` and `resize` events and keeps the launch URL's origin as the only trusted sender.
- Web and native frames allow the microphone so partners with voice switched on need no extra wiring beyond the OS permission.
