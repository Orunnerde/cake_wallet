abstract class SyncStatus { const SyncStatus(); }

class SyncingSyncStatus extends SyncStatus {
  final int height;
  final int blockchainHeight;

  SyncingSyncStatus(this.height, this.blockchainHeight);

  @override
  String toString() => '${blockchainHeight - height}';
}

class SyncedSyncStatus extends SyncStatus {}

class NotConnectedSyncStatus extends SyncStatus { const NotConnectedSyncStatus(); }

class StartingSyncStatus extends SyncStatus {}

class FailedSyncStatus extends SyncStatus {}

class ConnectingSyncStatus extends SyncStatus {}