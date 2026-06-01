import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Reports, blocks, and moderation storage for App Store Guideline 1.2.
class ModerationService {
  static const String reportsCollection = 'content_reports';
  static const String blockedCollection = 'blocked_users';

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _currentUserId => _auth.currentUser?.uid;

  Set<String> _blockedUserIds = {};

  Set<String> get blockedUserIds => Set.unmodifiable(_blockedUserIds);

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
  }

  bool isUserBlocked(String userId) => _blockedUserIds.contains(userId);

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

  Future<String?> submitReport({
    required String contentType,
    required String contentId,
    required String reason,
    String? reportedUserId,
    String? details,
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
        'reason': reason,
        'details': details?.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      debugPrint('submitReport failed: $e');
      return 'Could not submit report. Please try again.';
    }
  }

  Future<String?> blockUser(String blockedUserId) async {
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
      return null;
    } catch (e) {
      debugPrint('blockUser failed: $e');
      return 'Could not block user. Please try again.';
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
}
