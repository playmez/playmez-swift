// Playmez game for iOS (UIKit view + SwiftUI wrapper).
//
//   UIKit:
//     let game = SpinlineGameView()
//     game.onEvent = { e in print(e.type, e.game ?? "", e.net) }
//     game.onClose = { [weak self] in self?.dismiss(animated: true) }
//     view.addSubview(game)            // pin to the safe area
//     game.open(launchUrl: url)        // from YOUR backend (POST /partner/launch); never ship the API key
//
//   SwiftUI:
//     SpinlineGame(launchUrl: url, onEvent: { e in ... }, onClose: { dismiss() })
//
// Voice at shared tables: the view grants microphone capture to the game origin and nothing else;
// add NSMicrophoneUsageDescription to Info.plist. Only needed when Playmez has switched voice on
// for you; set allowMicrophone = false to refuse it.
#if canImport(UIKit)
import SwiftUI
import UIKit
import WebKit

public final class SpinlineGameView: UIView {
    public var onEvent: ((SpinlineEvent) -> Void)?
    /// The player tapped Leave or Close: dismiss the screen or hide the view.
    public var onClose: (() -> Void)?
    /// Let the game use the microphone for voice at shared tables.
    public var allowMicrophone = true

    private let webView: WKWebView
    private let handler = MessageHandler()
    private var allowedHost: String?

    public override init(frame: CGRect) {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        webView = WKWebView(frame: .zero, configuration: config)
        super.init(frame: frame)
        handler.owner = self
        config.userContentController.add(handler, name: "spinline")
        webView.uiDelegate = handler
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.043, green: 0.059, blue: 0.102, alpha: 1)
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame = bounds
        addSubview(webView)
    }

    public required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "spinline")
    }

    /// Loads a launch URL. Fetch a fresh one every time: it works once, within five minutes.
    public func open(launchUrl: URL) {
        allowedHost = launchUrl.host
        webView.load(URLRequest(url: launchUrl))
    }

    fileprivate func receive(_ body: Any) {
        guard let event = SpinlineEvent(body: body) else { return }
        onEvent?(event)
        if event.type == "close" { onClose?() }
    }

    @available(iOS 15.0, *)
    fileprivate func mayCapture(origin: WKSecurityOrigin, type: WKMediaCaptureType) -> Bool {
        guard allowMicrophone, type == .microphone else { return false }
        return origin.host == allowedHost
    }

    /// WKUserContentController retains its handlers; this proxy keeps the view free of a retain cycle.
    private final class MessageHandler: NSObject, WKScriptMessageHandler, WKUIDelegate {
        weak var owner: SpinlineGameView?

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            owner?.receive(message.body)
        }

        @available(iOS 15.0, *)
        func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            decisionHandler(owner?.mayCapture(origin: origin, type: type) == true ? .grant : .deny)
        }
    }
}

public struct SpinlineGame: UIViewRepresentable {
    public let launchUrl: URL
    public var onEvent: ((SpinlineEvent) -> Void)? = nil
    public var onClose: (() -> Void)? = nil
    public var allowMicrophone = true

    public init(launchUrl: URL, onEvent: ((SpinlineEvent) -> Void)? = nil, onClose: (() -> Void)? = nil, allowMicrophone: Bool = true) {
        self.launchUrl = launchUrl
        self.onEvent = onEvent
        self.onClose = onClose
        self.allowMicrophone = allowMicrophone
    }

    public func makeUIView(context: Context) -> SpinlineGameView {
        let view = SpinlineGameView()
        view.onEvent = onEvent
        view.onClose = onClose
        view.allowMicrophone = allowMicrophone
        view.open(launchUrl: launchUrl)
        return view
    }

    public func updateUIView(_ uiView: SpinlineGameView, context: Context) {
        uiView.onEvent = onEvent
        uiView.onClose = onClose
        uiView.allowMicrophone = allowMicrophone
    }
}
#endif
