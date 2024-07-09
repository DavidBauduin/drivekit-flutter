package com.drivequant.drivekit

import com.drivequant.drivekit.core.DriveKit

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DrivekitPlugin */
class DrivekitPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "drivekit")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "getPlatformVersion" -> {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        "isDriveKitConfigured" -> {
            result.success(DriveKit.isConfigured())
        }
        "isUserConnected" -> {
            result.success(DriveKit.isUserConnected())
        }
        "getApiKey" -> {
          result.success(DriveKit.getApiKey())
        }
        "setApiKey" -> {
          val apiKey = call.arguments as String
          DriveKit.setApiKey(apiKey)
          result.success(null)
        }
        "getUserId" -> {
            result.success(DriveKit.config.userId)
        }
        "setUserId" -> {
            val userId = call.arguments as String
            DriveKit.setUserId(userId)
            result.success(null)
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
