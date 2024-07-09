import Flutter
import UIKit
import DriveKitCoreModule

public class DrivekitPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "drivekit", binaryMessenger: registrar.messenger())
        let instance = DrivekitPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getPlatformVersion":
                result("iOS " + UIDevice.current.systemVersion)
            case "isDriveKitConfigured":
                result(DriveKit.shared.isConfigured())
            case "isUserConnected":
                result(DriveKit.shared.isUserConnected())
            case "getApiKey":
                result(DriveKit.shared.config.getApiKey())
            case "setApiKey":
                let apiKey = call.arguments as! String
                DriveKit.shared.setApiKey(key: apiKey)
                result(nil)
            case "getUserId":
                result(DriveKit.shared.config.getUserId())
            case "setUserId":
                let userId = call.arguments as! String
                DriveKit.shared.setUserId(userId: userId)
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}
