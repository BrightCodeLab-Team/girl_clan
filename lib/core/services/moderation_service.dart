import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Reports, blocks, hidden content, and real-time sync (App Store Guideline 1.2).
class ModerationService extends ChangeNotifier {
  static const String reportsCollection = 'content_reports';
  static const String blockedCollection = 'blocked_users';
  static const String hiddenSubcollection = 'hidden_content';

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Set<String> _blockedUserIds = {};
  Set<String> _hiddenContentKeys = {};
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _blocksSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _hiddenSubscription;

  Set<String> get blockedUserIds => Set.unmodifiable(_blockedUserIds);

  String? get _currentUserId => _auth.currentUser?.uid;

  /// Starts Firestore listeners for real-time block/hide updates.
  Future<void> startRealtimeSync() async {
    await refreshBlockedUsers();
    await refreshHiddenContent();
    _listenBlockedUsers();
    _listenHiddenContent();
  }

  void stopRealtimeSync() {
    _blocksSubscription?.cancel();
    _hiddenSubscription?.cancel();
    _blocksSubscription = null;
    _hiddenSubscription = null;
  }

  void _listenBlockedUsers() {
    final uid = _currentUserId;
    if (uid == null) return;

    _blocksSubscription?.cancel();
    _blocksSubscription =
        _db
            .collection(blockedCollection)
            .where('blockerId', isEqualTo: uid)
            .snapshots()
            .listen((snapshot) {
              _blockedUserIds =
                  snapshot.docs
                      .map((d) => d.data()['blockedUserId'] as String?)
                      .whereType<String>()
                      .toSet();
              notifyListeners();
            });
  }

  void _listenHiddenContent() {
    final uid = _currentUserId;
    if (uid == null) return;

    _hiddenSubscription?.cancel();
    _hiddenSubscription =
        _db
            .collection('app-user')
            .doc(uid)
            .collection(hiddenSubcollection)
            .snapshots()
            .listen((snapshot) {
              _hiddenContentKeys = snapshot.docs.map((d) => d.id).toSet();
              notifyListeners();
            });
  }

  Future<void> refreshBlockedUsers() async {
    final uid = _currentUserId;
    if (uid == null) {
      _blockedUserIds = {};
      return;
    }

    final snapshot =
        await _db
            .collection(blockedCollection)
            .where('blockerId', isEqualTo: uid)
            .get();

    _blockedUserIds =
        snapshot.docs
            .map((d) => d.data()['blockedUserId'] as String?)
            .whereType<String>()
            .toSet();
    notifyListeners();
  }

  Future<void> refreshHiddenContent() async {
    final uid = _currentUserId;
    if (uid == null) {
      _hiddenContentKeys = {};
      return;
    }

    final snapshot =
        await _db
            .collection('app-user')
            .doc(uid)
            .collection(hiddenSubcollection)
            .get();

    _hiddenContentKeys = snapshot.docs.map((d) => d.id).toSet();
    notifyListeners();
  }

  bool isUserBlocked(String userId) => _blockedUserIds.contains(userId);

  bool isMessageHidden(String messageId) =>
      messageId.isNotEmpty && _hiddenContentKeys.contains('message_$messageId');

  bool isUserContentHidden(String userId) =>
      userId.isNotEmpty && _hiddenContentKeys.contains('user_$userId');

  bool isEventHidden(String eventId) {
    if (eventId.isEmpty) return false;
    if (_hiddenContentKeys.contains('event_$eventId')) return true;
    final underscore = eventId.lastIndexOf('_');
    if (underscore > 0) {
      return _hiddenContentKeys.contains(
        'event_${eventId.substring(0, underscore)}',
      );
    }
    return false;
  }

  bool isGroupHidden(String groupId) =>
      groupId.isNotEmpty && _hiddenContentKeys.contains('group_$groupId');

  bool shouldHideUserContent(String? userId) {
    if (userId == null || userId.isEmpty) return false;
    return isUserBlocked(userId) || isUserContentHidden(userId);
  }

  Future<bool> isEitherUserBlocked(String otherUserId) async {
    final uid = _currentUserId;
    if (uid == null) return false;
    if (_blockedUserIds.contains(otherUserId)) return true;

    final reverse =
        await _db
            .collection(blockedCollection)
            .where('blockerId', isEqualTo: otherUserId)
            .where('blockedUserId', isEqualTo: uid)
            .limit(1)
            .get();
    return reverse.docs.isNotEmpty;
  }

  Future<String?> reportUser({
    required String reportedUserId,
    required String reason,
    String? details,
  }) {
    return submitReport(
      contentType: 'user',
      contentId: reportedUserId,
      reportedUserId: reportedUserId,
      reason: reason,
      details: details,
      hideKeys: ['user_$reportedUserId'],
    );
  }

  Future<String?> reportMessage({
    required String messageId,
    required String reportedUserId,
    required String reason,
    String? details,
    String? chatId,
  }) {
    return submitReport(
      contentType: 'message',
      contentId: messageId,
      reportedUserId: reportedUserId,
      reason: reason,
      details: details,
      messageId: messageId,
      chatId: chatId,
      hideKeys: ['message_$messageId'],
    );
  }

  Future<String?> submitReport({
    required String contentType,
    required String contentId,
    required String reason,
    String? reportedUserId,
    String? details,
    String? messageId,
    String? chatId,
    List<String>? hideKeys,
  }) async {
    final uid = _currentUserId;
    if (uid == null) return 'You must be signed in to report content.';

    try {
      await _db.collection(reportsCollection).add({
        'reporterId': uid,
        'reporterEmail': _auth.currentUser?.email ?? '',
        'contentType': contentType,
        'contentId': contentId,
        'reportedUserId': reportedUserId,
        'messageId': messageId,
        'chatId': chatId,
        'reason': reason,
        'details': details?.trim(),
        'status': 'pending',
        'adminAction': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _recordModerationAlert(
        action: 'content_report',
        reportedUserId: reportedUserId ?? contentId,
        reason: reason,
        details: details,
        contentType: contentType,
        contentId: contentId,
      );

      if (hideKeys != null) {
        for (final key in hideKeys) {
          await hideContentLocally(key);
        }
      }

      return null;
    } catch (e) {
      debugPrint('submitReport failed: $e');
      return 'Could not submit report. Please try again.';
    }
  }

  Future<void> hideContentLocally(String contentKey) async {
    final uid = _currentUserId;
    if (uid == null || contentKey.isEmpty) return;

    await _db
        .collection('app-user')
        .doc(uid)
        .collection(hiddenSubcollection)
        .doc(contentKey)
        .set({'hiddenAt': FieldValue.serverTimestamp()});

    _hiddenContentKeys.add(contentKey);
    notifyListeners();
  }

  Future<String?> blockUser(
    String blockedUserId, {
    String? reason,
    String? details,
  }) async {
    final uid = _currentUserId;
    if (uid == null) return 'You must be signed in.';
    if (uid == blockedUserId) return 'You cannot block yourself.';

    try {
      final docId = '${uid}_$blockedUserId';
      await _db.collection(blockedCollection).doc(docId).set({
        'blockerId': uid,
        'blockedUserId': blockedUserId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _blockedUserIds.add(blockedUserId);
      await hideContentLocally('user_$blockedUserId');
      await _notifyDeveloper(
        action: 'user_block',
        reportedUserId: blockedUserId,
        reason: reason ?? 'User blocked',
        details: details,
      );
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('blockUser failed: $e');
      return 'Could not block user. Please try again.';
    }
  }

  /// Notifies the developer when a user is blocked (App Store Guideline 1.2).
  Future<void> _notifyDeveloper({
    required String action,
    required String reportedUserId,
    required String reason,
    String? details,
    String? contentType,
    String? contentId,
  }) async {
    final uid = _currentUserId;
    if (uid == null) return;

    try {
      await _db.collection(reportsCollection).add({
        'reporterId': uid,
        'reporterEmail': _auth.currentUser?.email ?? '',
        'reportedUserId': reportedUserId,
        'contentType': contentType ?? action,
        'contentId': contentId ?? reportedUserId,
        'reason': reason,
        'details': details?.trim(),
        'status': 'pending',
        'adminAction': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _recordModerationAlert(
        action: action,
        reportedUserId: reportedUserId,
        reason: reason,
        details: details,
        contentType: contentType,
        contentId: contentId,
      );
    } catch (e) {
      debugPrint('_notifyDeveloper failed: $e');
    }
  }

  Future<void> _recordModerationAlert({
    required String action,
    required String reportedUserId,
    required String reason,
    String? details,
    String? contentType,
    String? contentId,
  }) async {
    final uid = _currentUserId;
    if (uid == null) return;

    try {
      await _db.collection('moderation_alerts').add({
        'action': action,
        'reporterId': uid,
        'reporterEmail': _auth.currentUser?.email ?? '',
        'reportedUserId': reportedUserId,
        'contentType': contentType ?? action,
        'contentId': contentId ?? reportedUserId,
        'reason': reason,
        'details': details?.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('_recordModerationAlert failed: $e');
    }
  }

  Future<List<Map<String, String>>> fetchBlockedUsers() async {
    final uid = _currentUserId;
    if (uid == null) return [];

    final snapshot =
        await _db
            .collection(blockedCollection)
            .where('blockerId', isEqualTo: uid)
            .get();

    final results = <Map<String, String>>[];
    for (final doc in snapshot.docs) {
      final blockedId = doc.data()['blockedUserId'] as String?;
      if (blockedId == null) continue;

      String name = 'User';
      try {
        final userDoc =
            await _db.collection('app-user').doc(blockedId).get();
        if (userDoc.exists) {
          final data = userDoc.data()!;
          final first = data['firstName']?.toString() ?? '';
          final last = data['surName']?.toString() ?? '';
          name = '$first $last'.trim();
          if (name.isEmpty) name = data['email']?.toString() ?? 'User';
        }
      } catch (_) {}

      results.add({'id': blockedId, 'name': name});
    }
    return results;
  }

  Future<String?> unblockUser(String blockedUserId) async {
    final uid = _currentUserId;
    if (uid == null) return 'You must be signed in.';

    try {
      await _db
          .collection(blockedCollection)
          .doc('${uid}_$blockedUserId')
          .delete();
      _blockedUserIds.remove(blockedUserId);
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('unblockUser failed: $e');
      return 'Could not unblock user.';
    }
  }

  Future<void> deleteBlockedEntriesForUser(String uid) async {
    final asBlocker =
        await _db
            .collection(blockedCollection)
            .where('blockerId', isEqualTo: uid)
            .get();
    final asBlocked =
        await _db
            .collection(blockedCollection)
            .where('blockedUserId', isEqualTo: uid)
            .get();

    final batch = _db.batch();
    for (final doc in [...asBlocker.docs, ...asBlocked.docs]) {
      batch.delete(doc.reference);
    }
    if (asBlocker.docs.isNotEmpty || asBlocked.docs.isNotEmpty) {
      await batch.commit();
    }
  }

  Future<void> deleteReportsForUser(String uid) async {
    final reporter =
        await _db
            .collection(reportsCollection)
            .where('reporterId', isEqualTo: uid)
            .get();
    final reported =
        await _db
            .collection(reportsCollection)
            .where('reportedUserId', isEqualTo: uid)
            .get();

    final batch = _db.batch();
    for (final doc in [...reporter.docs, ...reported.docs]) {
      batch.delete(doc.reference);
    }
    if (reporter.docs.isNotEmpty || reported.docs.isNotEmpty) {
      await batch.commit();
    }
  }

  @override
  void dispose() {
    stopRealtimeSync();
    super.dispose();
  }
}
