abstract class SyncStatus {
  const SyncStatus();

  double progress();

  String title();
}

class SyncingSyncStatus extends SyncStatus {
  final int height;
  final int blockchainHeight;
  final int refreshHeight;

  SyncingSyncStatus(this.height, this.blockchainHeight, this.refreshHeight);

  double progress() {
    final line = blockchainHeight - refreshHeight;
    final diff = line - (blockchainHeight - height);
    return diff < 0 ? 0.0 : diff / line;
  }

  String title() => 'SYNCRONIZING';

  @override
  String toString() => '${blockchainHeight - height}';
}

class SyncedSyncStatus extends SyncStatus {
  double progress() => 1.0;

  String title() => 'SYNCHRONIZED';
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