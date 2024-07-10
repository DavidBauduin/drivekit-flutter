abstract class DriveKitListener {
  void onConnected();
  void onDisconnected();
  void onAuthenticationError(RequestError errorType);
  void onAccountDeleted(DeleteAccountStatus status);
  void userIdUpdateStatus(UpdateUserIdStatus status, String? userId);
}

enum RequestError {
  noNetwork,
  unauthenticated,
  forbidden,
  serverError,
  clientError,
  unknownError,
  limitReached,
  wrongUrl,
}

enum DeleteAccountStatus {
  success,
  failedToDelete,
  forbidden,
}

enum UpdateUserIdStatus {
  updated,
  failedToUpdate,
  invalidUserId,
  alreadyUsed,
  savedForRepost,
}
