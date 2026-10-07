/// 클라우드 동기화 서비스 인터페이스 (v1.0 스캐폴드).
abstract class SyncService {
  bool get isAvailable;

  Future<SyncStatus> getStatus();

  Future<void> sync();
}

class SyncStatus {
  const SyncStatus({required this.state, this.message, this.lastSyncedAt});

  final SyncState state;
  final String? message;
  final DateTime? lastSyncedAt;
}

enum SyncState { unavailable, idle, syncing, error }
