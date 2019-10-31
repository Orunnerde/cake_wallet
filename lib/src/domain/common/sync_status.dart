abstract class SyncStatus {
  const SyncStatus();

  double progress();

  String title();
}

class SyncingSyncStatus extends SyncStatus {
  final int height;
  final int blockchainHeight;

  SyncingSyncStatus(this.height, this.blockchainHeight);

  double progress() => height / blockchainHeight;

  String title() => 'SYNCRONIZING';

  @override
  String toString() => '${blockchainHeight - height}';
}

class SyncedSyncStatus extends SyncStatus {
  double progress() => 1.0;

  String title() => 'SYNCRONIZED';
}

class NotConnectedSyncStatus extends SyncStatus {
  const NotConnectedSyncStatus();

  double progress() => 0.0;

  String title() => 'NOT CONNECTED';
}

class StartingSyncStatus extends SyncStatus {
  double progress() => 0.0;

  String title() => 'STARTING SYNC';
}

class FailedSyncStatus extends SyncStatus {
  double progress() => 1.0;

  String title() => 'FAILED CONNECT TO THE NODE';
}

class ConnectingSyncStatus extends SyncStatus {
  double progress() => 0.0;

  String title() => 'CONNECTING';
}

class ConnectedSyncStatus extends SyncStatus {
  double progress() => 0.0;

  String title() => 'CONNECTED';
}

class RestoringSyncStatus extends SyncStatus {
  final int height;
  final int startRestoreFromHeight;
  final int blockchainHeight;

  RestoringSyncStatus(
      this.height, this.startRestoreFromHeight, this.blockchainHeight);

  double progress() => startRestoreFromHeight / height;

  String title() => 'SYNCRONIZING';

  @override
  String toString() {
    if (startRestoreFromHeight > height) {
      return '${blockchainHeight - startRestoreFromHeight}';
    }

    return '${blockchainHeight - height}';
  }
}
