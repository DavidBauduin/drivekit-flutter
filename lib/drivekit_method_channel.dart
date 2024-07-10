import 'package:drivekit/data/drivekit_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'drivekit_platform_interface.dart';

/// An implementation of [DrivekitPlatform] that uses method channels.
class MethodChannelDrivekit extends DrivekitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('drivekit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> setDriveKitListener(DriveKitListener? driveKitListener) async {
    if (driveKitListener == null) {
      methodChannel.setMethodCallHandler(null);
    } else {
      methodChannel.setMethodCallHandler((MethodCall call) async {
        switch (call.method) {
          case 'onConnected': driveKitListener.onConnected();
          case 'onDisconnected': driveKitListener.onDisconnected();
          case 'onAuthenticationError': {
            final error = call.arguments as String;
            driveKitListener.onAuthenticationError(_parseRequestError(error));
          }
          case 'onAccountDeleted': {
            final status = call.arguments as String;
            driveKitListener.onAccountDeleted(_parseDeleteAccountStatus(status));
          }
          case 'userIdUpdateStatus': {
            final status = call.arguments['status'] as String;
            final userId = call.arguments['userId'] as String?;
            driveKitListener.userIdUpdateStatus(_parseUpdateUserIdStatus(status), userId);
          }
          default: throw UnimplementedError('Unknown method: ${call.method}');
        }
      });
    }
  }
  RequestError _parseRequestError(String error) {
    switch (error) {
      case 'NO_NETWORK': return RequestError.noNetwork;
      case 'UNAUTHENTICATED': return RequestError.unauthenticated;
      case 'FORBIDDEN': return RequestError.forbidden;
      case 'SERVER_ERROR': return RequestError.serverError;
      case 'CLIENT_ERROR': return RequestError.clientError;
      case 'UNKNOWN_ERROR': return RequestError.unknownError;
      case 'LIMIT_REACHED': return RequestError.limitReached;
      case 'WRONG_URL': return RequestError.wrongUrl;
      default: throw ArgumentError('Unknown RequestError: $error');
    }
  }

  DeleteAccountStatus _parseDeleteAccountStatus(String status) {
    switch (status) {
      case 'FORBIDDEN': return DeleteAccountStatus.forbidden;
      case 'FAILED_TO_DELETE': return DeleteAccountStatus.failedToDelete;
      case 'SUCCESS': return DeleteAccountStatus.success;
      default: throw ArgumentError('Unknown DeleteAccountStatus: $status');
    }
  }

  UpdateUserIdStatus _parseUpdateUserIdStatus(String status) {
    switch (status) {
      case 'UPDATED': return UpdateUserIdStatus.updated;
      case 'FAILED_TO_UPDATE': return UpdateUserIdStatus.failedToUpdate;
      case 'INVALID_USER_ID': return UpdateUserIdStatus.invalidUserId;
      case 'ALREADY_USED': return UpdateUserIdStatus.alreadyUsed;
      case 'SAVED_FOR_REPOST': return UpdateUserIdStatus.savedForRepost;
      default: throw ArgumentError('Unknown UpdateUserIdStatus: $status');
    }
  }

  @override
  Future<bool> isDriveKitConfigured() async {
    return await methodChannel.invokeMethod<bool>('isDriveKitConfigured') ?? false;
  }
  @override
  Future<bool> isUserConnected() async {
    return await methodChannel.invokeMethod<bool>('isUserConnected') ?? false;
  }

  @override
  Future<String?> getApiKey() async {
    final apiKey = await methodChannel.invokeMethod<String?>('getApiKey');
    return apiKey;
  }

  @override
  Future<void> setApiKey(String apiKey) async {
    await methodChannel.invokeMethod<void>('setApiKey', apiKey);
  }

  @override
  Future<String?> getUserId() async {
    final userId = await methodChannel.invokeMethod<String?>('getUserId');
    return userId;
  }

  @override
  Future<void> setUserId(String userId) async {
    await methodChannel.invokeMethod<void>('setUserId', userId);
  }

  @override
  Future<bool> isAutoStartEnabled() async {
    return await methodChannel.invokeMethod<bool>('isAutoStartEnabled') ?? false;
  }
  @override
  Future<void> enableAutoStart(bool enable) async {
    await methodChannel.invokeMethod<void>('enableAutoStart', enable);
  }
}
