package com.drivequant.drivekit

import android.app.Activity
import android.widget.Toast
import androidx.core.app.ActivityCompat.requestPermissions
import com.drivequant.drivekit.core.DriveKit
import com.drivequant.drivekit.core.driver.UpdateUserIdStatus
import com.drivequant.drivekit.core.driver.deletion.DeleteAccountStatus
import com.drivequant.drivekit.core.networking.DriveKitListener
import com.drivequant.drivekit.core.networking.RequestError
import com.drivequant.drivekit.permissionsutils.PermissionsUtilsUI
import com.drivequant.drivekit.permissionsutils.permissions.listener.PermissionViewListener
import com.drivequant.drivekit.tripanalysis.DriveKitTripAnalysis

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DrivekitPlugin */
class DrivekitPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, DriveKitListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "drivekit")
        channel.setMethodCallHandler(this)

        DriveKit.addDriveKitListener(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "isDriveKitConfigured" -> isDriveKitConfigured(result)
            "isUserConnected" -> isUserConnected(result)
            "getApiKey" -> getApiKey(result)
            "setApiKey" -> setApiKey(call, result)
            "getUserId" -> getUserId(result)
            "setUserId" -> setUserId(call, result)
            "isAutoStartEnabled" -> isAutoStartEnabled(result)
            "enableAutoStart" -> enableAutoStart(call, result)
            "requestPermissions" -> requestPermissions(result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun isDriveKitConfigured(result: Result) {
        result.success(DriveKit.isConfigured())
    }

    private fun isUserConnected(result: Result) {
        result.success(DriveKit.isUserConnected())
    }

    private fun getApiKey(result: Result) {
        result.success(DriveKit.getApiKey())
    }

    private fun setApiKey(call: MethodCall, result: Result) {
        val apiKey = call.arguments as String
        DriveKit.setApiKey(apiKey)
        result.success(null)
    }

    private fun getUserId(result: Result) {
        result.success(DriveKit.config.userId)
    }

    private fun setUserId(call: MethodCall, result: Result) {
        val userId = call.arguments as String
        DriveKit.setUserId(userId)
        result.success(null)
    }

    private fun isAutoStartEnabled(result: Result) {
        result.success(DriveKitTripAnalysis.getConfig().autoStartActivate)
    }

    private fun enableAutoStart(call: MethodCall, result: Result) {
        val enable = call.arguments as Boolean
        DriveKitTripAnalysis.activateAutoStart(enable)
        result.success(null)
    }

    private fun requestPermissions(result: Result) {
        activity?.let {
            PermissionsUtilsUI.initialize()
            PermissionsUtilsUI.showPermissionViews(it, object : PermissionViewListener {
                override fun onFinish() {
                    Toast.makeText(it, "👍", Toast.LENGTH_SHORT).show()
                }
            })
        }
        result.success(null)
    }


    override fun onAccountDeleted(status: DeleteAccountStatus) {
        channel.invokeMethod("onAccountDeleted", status.name)
    }

    override fun onAuthenticationError(errorType: RequestError) {
        channel.invokeMethod("onAuthenticationError", errorType.name)
    }

    override fun onConnected() {
        channel.invokeMethod("onConnected", null)
    }

    override fun onDisconnected() {
        channel.invokeMethod("onDisconnected", null)
    }

    override fun userIdUpdateStatus(status: UpdateUserIdStatus, userId: String?) {
        channel.invokeMethod("userIdUpdateStatus", mapOf("status" to status.name, "userId" to userId))
    }


    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        this.activity = null
    }
}
