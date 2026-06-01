import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:girl_clan/core/services/moderation_service.dart';

/// Permanently removes account and associated user data (Guideline 5.1.1(v)).
class AccountDeletionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ModerationService _moderation;

  AccountDeletionService(this._moderation);

  Future<String?> deleteAccount(User user) async {
    final uid = user.uid;

    try {
      await _deleteChatsForUser(uid);
      await _deleteHostedEvents(uid);
      await _deleteHostedGroups(uid);
      await _removeUserFromMembershipLists(uid);
      await _moderation.deleteBlockedEntriesForUser(uid);
      await _moderation.deleteReportsForUser(uid);

      try {
        await FirebaseStorage.instance
            .ref()
            .child('profile_images/$uid.jpg')
            .delete();
      } catch (_) {}

      await _db.collection('app-user').doc(uid).delete();
      await user.delete();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Please log out, log in again, then delete your account.';
      }
      return e.message ?? 'Could not delete account.';
    } catch (e) {
      debugPrint('AccountDeletionService failed: $e');
      return 'Could not delete account. Please try again.';
    }
  }

  Future<void> _deleteChatsForUser(String uid) async {
    final chats =
        await _db
            .collection('chats')
            .where('participants', arrayContains: uid)
            .get();

    for (final chatDoc in chats.docs) {
      await _deleteCollectionInBatches(
        chatDoc.reference.collection('messages'),
      );
      await chatDoc.reference.delete();
    }
  }

  Future<void> _deleteHostedEvents(String uid) async {
    final events =
        await _db.collection('events').where('hostUserId', isEqualTo: uid).get();
    final batch = _db.batch();
    for (final doc in events.docs) {
      batch.delete(doc.reference);
    }
    if (events.docs.isNotEmpty) await batch.commit();
  }

  Future<void> _deleteHostedGroups(String uid) async {
    final groups =
        await _db
            .collection('events_groups')
            .where('hostUserId', isEqualTo: uid)
            .get();
    final batch = _db.batch();
    for (final doc in groups.docs) {
      batch.delete(doc.reference);
    }
    if (groups.docs.isNotEmpty) await batch.commit();
  }

  Future<void> _removeUserFromMembershipLists(String uid) async {
    await _removeUidFromArrayField('events', 'joinedUsers', uid);
    await _removeUidFromArrayField('events_groups', 'joinedUsers', uid);

    final chatGroups =
        await _db.collection('groups').where('members', arrayContains: uid).get();
    for (final doc in chatGroups.docs) {
      await doc.reference.update({
        'members': FieldValue.arrayRemove([uid]),
      });
    }
  }

  Future<void> _removeUidFromArrayField(
    String collection,
    String field,
    String uid,
  ) async {
    try {
      final snapshot =
          await _db
              .collection(collection)
              .where(field, arrayContains: uid)
              .get();
      for (final doc in snapshot.docs) {
        await doc.reference.update({field: FieldValue.arrayRemove([uid])});
      }
    } catch (e) {
      debugPrint('_removeUidFromArrayField $collection failed: $e');
    }
  }

  Future<void> _deleteCollectionInBatches(CollectionReference collection) async {
    while (true) {
      final snapshot = await collection.limit(400).get();
      if (snapshot.docs.isEmpty) break;
      final batch = _db.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }
}
