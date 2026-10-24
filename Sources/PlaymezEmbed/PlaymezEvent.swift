import Foundation

/// The package version, for your logs.
public let playmezSdkVersion = "2.0.0"

/// One message from the game: `ready`, `result`, `close`, `error` or `resize`.
public struct PlaymezEvent {
    public let type: String
    public let data: [String: Any]

    public init(type: String, data: [String: Any]) {
        self.type = type
        self.data = data
    }

    /// Builds an event from a bridge message body; nil for anything that is not a Playmez event.
    public init?(body: Any) {
        guard let dict = body as? [String: Any], dict["source"] as? String == "spinline", let type = dict["type"] as? String else { return nil }
        self.init(type: type, data: dict)
    }

    /// Parses a JSON string the way the bridge receives it.
    public init?(json: String) {
        guard let raw = json.data(using: .utf8), let parsed = try? JSONSerialization.jsonObject(with: raw) else { return nil }
        self.init(body: parsed)
    }

    public var game: String? { data["game"] as? String }
    public var won: Bool { data["won"] as? Bool ?? false }
    public var net: Int { (data["net"] as? NSNumber)?.intValue ?? 0 }
    public var code: String? { data["code"] as? String }
    public var message: String? { data["message"] as? String }
    public var height: Int? { (data["height"] as? NSNumber)?.intValue }
}
