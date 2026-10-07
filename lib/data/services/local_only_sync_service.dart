import '../../domain/services/sync_service.dart';

/// 로컬 전용 스텁 — 클라우드 백엔드 연동 전까지 사용.
class LocalOnlySyncService implements SyncService {
  @override
  bool get isAvailable => false;

  @override
  Future<SyncStatus> getStatus() async {
    return const SyncStatus(
      state: SyncState.unavailable,
      message: '클라우드 동기화는 준비 중이에요. JSON 백업을 이용해주세요.',
    );
  }

  @override
  Future<void> sync() async {
    throw UnsupportedError('클라우드 동기화는 아직 지원하지 않아요.');
  }
}
