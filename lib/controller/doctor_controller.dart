import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../core/class/enums.dart';
import '../data/dataSoureces/remoteDataSource/chats_remotdata.dart';

class DoctorController extends GetxController {
  late StatusRequest statusReq;
  // final DoctorsRepoImpHttp drugsRepo = Get.find();
  @override
  void onInit() {
    super.onInit();
    // getAllDoctors();
    getAllDoctors();
  }

  final List<UserModel> doctorlist = [];

  Future<void> getAllDoctors() async {
    try {
      statusReq = StatusRequest.loading;
      update();

      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      doctorlist.clear();
      doctorlist.addAll(snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }));

      statusReq = StatusRequest.success;
      update();
    } catch (e) {
      statusReq = StatusRequest.serverFailure;
      update();
      printError(info: "getAllDoctors error: ${e.toString()}");
      Get.snackbar("⚠️ Error", e.toString());
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }).toList();
    } catch (e) {
      printError(info: "getAllUsers error: ${e.toString()}");
      return [];
    }
  }
}
