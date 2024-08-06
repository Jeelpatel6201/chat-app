import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChats(String userId) {
    return _fireStore
        .collection('users')
        .where('users', arrayContains: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> searchUser(String query) {
    return _fireStore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isGreaterThanOrEqualTo: query + '\uf8ff')
        .snapshots();
  }

  Future<void> sendMessage(
      String chatId, String message, String receiveId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _fireStore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': currentUser.uid,
        'receiveId': receiveId,
        'messageBody': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await _fireStore.collection('chats').doc(chatId).set({
        'users': [currentUser.uid, receiveId],
        'lastMessage': message,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<String?> getChatRoom(String receiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final chatQuery = await _fireStore
          .collection('chats')
          .where('users', arrayContains: currentUser.uid)
          .get();
      final chats = chatQuery.docs
          .where((chat) => chat['users'].contains(receiverId))
          .toList();
      if(chats.isNotEmpty){
        return chats.first.id;
      }
    }
    return null;
  }

  Future<String?> createChatRoom(String receiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final chatRoom =  await _fireStore.collection('chats').add({
        'users': [currentUser.uid,receiverId],
        'lastMessage':'',
        'timestamp': FieldValue.serverTimestamp(),
      });
      return chatRoom.id;
    }
    throw Exception('Current user is Null');
  }
}
