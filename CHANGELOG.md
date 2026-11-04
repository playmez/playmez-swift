# Spinline SDK changelog

All five packages (`playmez-embed`, `playmez-embed-react-native`, `playmez_embed`, `com.playmez:embed`, `PlaymezEmbed`) share one version, kept in `sdk/VERSION`.

## 2.2.0

- Live shows: a partner hosts Playmez's party shows (Housie Party, Quiz, Herd, Hot Seat, Room Verdict, Team Survey, Be the Few, Live Vote) with its brand as the host on the show's card, on every phone and on the TV screen. Open one with `POST /partner/shows`, then launch the presenter with `role: "host"` and players with `POST /partner/shows/:code/launch`. Every package opens the launch URL with no code change.
- Each show is private (only the partner's players) or network (listed in Live now on playmez.com and in other network partners' apps, "Hosted by" the partner's vetted brand). Network shows need the Playmez network and cross-promotion.
- `ready` of a show launch carries `game: "show"`, `show` (the kind), `showCode` and `role`. Android, iOS and Flutter `PlaymezEvent` gain `show`, `showCode` and `role`; JS and React Native add `PlaymezShowKind` and `PlaymezShowRole` (JS also `PlaymezShowAudience`).
- Webhooks: `session.opened` carries `showCode` for a show launch, where `game` is null.
- Server helpers (`launch.mjs`, `launch.php`, `launch.py`) gain `createPlaymezShow`, `launchPlaymezShow` and `closePlaymezShow` (`create_playmez_show`… in Python).

## 2.1.0

- Offline on the device: a launch with `mode: "local"` runs the game on the player's device with no network once loaded. Every table game plays alone against the computer (Ludo, Chess, Carrom, 8-ball, Callbreak, Rummy, Teen Patti, Tambola, Trivia, Roulette, Crash), and Ludo, Chess, Carrom and 8-ball can also be played by people passing the device. Every package runs it with no code change.
- New event `local_finished` (`game`, `draw`, `won`) when a local game ends. `won` is the player's result against the computer, null for people together or a game of chance. No names leave the device. Android, iOS and Flutter `PlaymezEvent` gain `draw` and `wonVsComputer`; the JS and React Native `PlaymezEvent` unions list the event.
- JS types: `PlaymezLaunchMode` (`computer`, `online`, `local`), `PlaymezLocalGameId` and `PlaymezLocalTogetherGameId`; `PlaymezGameId` lists `pool`.
- WordPress plugin 1.1.0: `[playmez game="rummy" mode="local"]`; `mode="online"` joins the older `online="1"`.

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
