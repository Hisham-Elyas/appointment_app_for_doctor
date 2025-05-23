import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/functions/show_coustom_snackbar.dart';
import '../../model/doctor_model.dart';
import '../../model/message_history_model.dart';
import '../../model/message_model.dart';

abstract class ChatsRemotData {
  Future<bool> sendMessage(
      {required String receiverId, required String message});
  Stream<List<MessageModel>> getMessage({required String contactId});
  Stream getMessageHistory();
  Future<void> setSeenMessage(
      {required Doctor doctor, required MessageModel msg});
}

class ChatRemotDataImpFirebase implements ChatsRemotData {
  late final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late final String userId = FirebaseAuth.instance.currentUser!.uid;
  Stream<List<UserModel>> getAllUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromMap(data);
      }).toList();
    });
  }

  @override
  Stream<List<MessageHistoryInUser>> getMessageHistory() {
    return firebaseFirestore
        .collection('users')
        .doc(userId) //  SenderId
        .collection("MessageHistory")
        .snapshots()
        .asyncMap((event) {
      final List<MessageHistoryInUser> msgHistorylist = [];
      msgHistorylist.addAll(event.docs.map((e) {
        // final DoctorController doctorController = Get.find();
        // final List<UserModel> doctors = doctorController.doctorlist;
        // if (doctors.isEmpty) {
        //   return MessageHistoryInUser.fromMap(e.data());
        // }
        // final UserModel receiverdoc =
        //     doctors.firstWhere((element) => e.id == element.userId);

        return MessageHistoryInUser.fromMap(e.data());
      }));

      return msgHistorylist;
    });
  }

  @override
  Stream<List<MessageModel>> getMessage({required String contactId}) {
    List<String> ids = [userId, contactId];

    ids.sort();
    String chatRoomID = ids.join("_");
    return firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .asyncMap((event) {
      final List<MessageModel> msglist = [];
      msglist.addAll(event.docs
          .map((e) => MessageModel.fromMap(e.data()).copyWith(id: e.id)));

      // for (var element in event.docs) {
      //   msglist.add(MessageModel.fromMap(element.data()));
      // }
      return msglist;
    });
  }

  @override
  Future<bool> sendMessage(
      {required String receiverId, required String message}) async {
    try {
      List<String> ids = [userId, receiverId];
      final timestamp = Timestamp.now();
      ids.sort();
      String chatRoomID = ids.join("_");
      final MessageModel msg = MessageModel(
          message: message,
          timestamp: timestamp,
          receiverId: receiverId,
          senderId: userId,
          isSeen: false);

      /// add msg to  messages collection

      ////////////   1
      await firebaseFirestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection("messages")
          .add(msg.toMap());
//// add msg to MessageHistory in  Sender and receiver
      await firebaseFirestore
          .collection('users')
          .doc(msg.senderId) //  SenderId
          .collection("MessageHistory")
          .doc(msg.receiverId) //receiverId
          .set({
        'lastMessage': msg.message,
      }, SetOptions(merge: true));
      await firebaseFirestore
          .collection('users')
          .doc(msg.receiverId) //receiverId
          .collection("MessageHistory")
          .doc(msg.senderId) //  SenderId
          .set({
        'lastMessage': msg.message,
      }, SetOptions(merge: true));

      return true;
    } on FirebaseException catch (e) {
      showCustomSnackBar(
          message: "${e.message}", title: ' Error', isError: true);

      printError(info: "Failed with error '${e.code}' :  ${e.message}");
      return false;
    } catch (e) {
      printError(info: e.toString());

      return false;
    }
  }

  @override
  Future<void> setSeenMessage(
      {required Doctor doctor, required MessageModel msg}) async {
    List<String> ids = [userId, doctor.id!];

    ids.sort();
    String chatRoomID = ids.join("_");
    try {
      await firebaseFirestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection("messages")
          .doc(msg.id)
          .update({
        'isSeen': true,
      });
    } on FirebaseException catch (e) {
      printError(info: "Failed with error '${e.code}' :  ${e.message}");
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future<bool> sendMessage2(
      {required Doctor doctor, required String message}) async {
    try {
      List<String> ids = [userId, doctor.id!];
      final timestamp = Timestamp.now();
      ids.sort();
      String chatRoomID = ids.join("_");
      final MessageModel msg = MessageModel(
          message: message,
          timestamp: timestamp,
          receiverId: doctor.id!,
          senderId: userId,
          isSeen: false);

      //////////////  2
      late final WriteBatch writeBatch = FirebaseFirestore.instance.batch();

      /// add msg to  messages collection
      final messagesdocReference = firebaseFirestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection("messages")
          .doc();
      writeBatch.set(messagesdocReference, msg.toMap());
//// add msg to MessageHistory in  Sender and receiver

      /////   in Sender
      final messageHistoryReferenceSenderId = firebaseFirestore
          .collection('users')
          .doc(msg.senderId) //  SenderId
          .collection("MessageHistory")
          .doc(msg.receiverId); //receiverId

      writeBatch.set(
          messageHistoryReferenceSenderId,
          {
            'lastMessage': msg.message,
            'receiverId': msg.receiverId,
            'receiverName': doctor.name,
            'timestamp': msg.timestamp,
          },
          SetOptions(merge: true));
      /////   in receiver
      final messageHistoryReferenceReceiverId = firebaseFirestore
          .collection('users')
          .doc(msg.receiverId) //receiverId
          .collection("MessageHistory")
          .doc(msg.senderId); //  SenderId

      writeBatch.set(
          messageHistoryReferenceReceiverId,
          {
            'lastMessage': msg.message,
            'receiverId': msg.senderId,
            'receiverName': doctor.name,
            'timestamp': msg.timestamp,
          },
          SetOptions(merge: true));

      ///  commit all data
      await writeBatch.commit();

      return true;
    } on FirebaseException catch (e) {
      showCustomSnackBar(
          message: "${e.message}", title: ' Error', isError: true);

      printError(info: "Failed with error '${e.code}' :  ${e.message}");
      return false;
    } catch (e) {
      printError(info: e.toString());

      return false;
    }
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? userId;
  final String? userName;
  final String? email;
  final String? phone;

  final String? password;

  UserModel({
    this.userId,
    this.userName,
    this.email,
    this.phone,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'email': email,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
    );
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.userName == userName &&
        other.email == email &&
        other.phone == phone &&
        other.password == password;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode;
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, userName: $userName, email: $email, phone: $phone, password: $password)';
  }

  UserModel copyWith({
    String? userId,
    String? userName,
    String? email,
    String? phone,
    String? password,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
