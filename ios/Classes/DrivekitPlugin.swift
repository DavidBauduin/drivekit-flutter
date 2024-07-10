import Flutter
import UIKit
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import DriveKitPermissionsUtilsUI

public class DrivekitPlugin: NSObject, FlutterPlugin {
    private let channel: FlutterMethodChannel

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "drivekit", binaryMessenger: registrar.messenger())
        let instance = DrivekitPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
        DriveKit.shared.addDriveKitDelegate(self)
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
            case "isAutoStartEnabled":
                result(DriveKitTripAnalysis.shared.config.autostart && DriveKitTripAnalysis.shared.config.vehicleAutoStart)
            case "enableAutoStart":
                let enableAutoStart = call.arguments as! Bool
                DriveKitTripAnalysis.shared.activateAutoStart(enable: enableAutoStart)
                result(nil)
            case "requestPermissions":
                let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
                if let topController = keyWindow?.rootViewController {
                    DriveKitPermissionsUtilsUI.shared.showPermissionViews([.location, .activity], parentViewController: topController) {
                            //
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}

extension DrivekitPlugin: DriveKitDelegate {
    public func driveKitDidConnect(_ driveKit: DriveKit) {
        DispatchQueue.main.async {
            self.channel.invokeMethod("onConnected", arguments: nil)
        }
    }

    public func driveKitDidDisconnect(_ driveKit: DriveKit) {
        DispatchQueue.main.async {
            self.channel.invokeMethod("onDisconnected", arguments: nil)
        }
    }

    public func userIdUpdateStatusChanged(status: UpdateUserIdStatus, userId: String?) {
        DispatchQueue.main.async {
            self.channel.invokeMethod("userIdUpdateStatus", arguments: ["status": status.stringValue(), "userId": userId])
        }
    }

    public func driveKit(_ driveKit: DriveKit, accountDeletionCompleted status: DeleteAccountStatus) {
        DispatchQueue.main.async {
            self.channel.invokeMethod("onAccountDeleted", arguments: status.stringValue())
        }
    }

    public func driveKit(_ driveKit: DriveKit, didReceiveAuthenticationError error: RequestError) {
        DispatchQueue.main.async {
            self.channel.invokeMethod("onAuthenticationError", arguments: error.stringValue())
        }
    }
}

private extension UpdateUserIdStatus {
    func stringValue() -> String {
        switch self {
            case .updated:
                return "UPDATED"
            case .failedToUpdate:
                return "FAILED_TO_UPDATE"
            case .invalidUserId:
                return "INVALID_USER_ID"
            case .alreadyUsed:
                return "ALREADY_USED"
            case .savedForRepost:
                return "SAVED_FOR_REPOST"
            @unknown default:
                return ""
        }
    }
}

private extension DeleteAccountStatus {
    func stringValue() -> String {
        switch self {
            case .success:
                return "SUCCESS"
            case .failedToDelete:
                return "FAILED_TO_DELETE"
            case .forbidden:
                return "FORBIDDEN"
            @unknown default:
                return ""
        }
    }
}

private extension RequestError {
    func stringValue() -> String {
        switch self {
            case .wrongUrl:
                return "WRONG_URL"
            case .noNetwork:
                return "NO_NETWORK"
            case .unauthenticated:
                return "UNAUTHENTICATED"
            case .forbidden:
                return "FORBIDDEN"
            case .serverError:
                return "SERVER_ERROR"
            case .clientError:
                return "CLIENT_ERROR"
            case .limitReached:
                return "LIMIT_REACHED"
            case .unknownError:
                return "UNKNOWN_ERROR"
            @unknown default:
                return ""
        }
    }
}
