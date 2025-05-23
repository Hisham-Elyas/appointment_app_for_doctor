import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuer_city/core/functions/ckeck_internet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/enums.dart';
import '../core/constant/string.dart';
import '../data/model/apointment_model.dart';
import '../data/repositories/appointment_repo.dart';
import 'user_controller.dart';

class ApointmentController extends GetxController {
  // final AppointmentRepo appointmentRepo2;

  ApointmentController(
      // {
      // required this.appointmentRepo2,
      // }
      );
  late StatusRequest statusReq = StatusRequest.loading;

  @override
  void onInit() {
    super.onInit();
    getAllAppointment();
  }

  void getAllAppointment() async {
    UserController userController = Get.find();

    if (!await ckeckInternet()) {
      statusReq = StatusRequest.serverFailure;
      update();
      return;
    }

    statusReq = StatusRequest.loading;
    update();

    FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: userController.userInf.userId!)
        .snapshots()
        .listen(
      (snapshot) {
        try {
          final appointments = snapshot.docs.map((doc) {
            final data = doc.data();
            return Appointment.fromMap({...data}, id: doc.id);
          }).toList();

          _appointmentlist
            ..clear()
            ..addAll(appointments);
          _appointmentlist.sort((a, b) => a.bookDate!.compareTo(b.bookDate!));
          print(_appointmentlist.length);
          statusReq = StatusRequest.success;
          update();
        } catch (e) {
          statusReq = StatusRequest.serverFailure;
          update();
        }
      },
      onError: (error) {
        statusReq = StatusRequest.serverFailure;
        update();
      },
    );
  }

  List<String> taps = [
    Upcoming,
    Completed,
    // Canceled,
  ];
  String? _userName;
  int tapLIstNum = 0;

  set setTapLIstNum(val) {
    tapLIstNum = val;
    update();
  }

  late DateTime bookDate;
  final GlobalKey<FormState> bookingformKey = GlobalKey();
  final List<Appointment> _appointmentlist = [];
  List<Appointment> get appointlist {
    _appointmentlist.sort(
      (a, b) => a.bookDate!.compareTo(b.bookDate!),
    );
    return _appointmentlist;
  }

  final AppointmentRepoImpHttp appointmentRepo = Get.find();

  set setuserName(val) => _userName = val;
  get getuserName => _userName;

  List<Appointment> filterAppointmentlist(int index) {
    List<Appointment> newlist = [];
    for (var el in _appointmentlist) {
      if (index == 0) {
        if (!el.isCompleted! &&
            el.bookDate!
                .isAfter(DateTime.now().add(const Duration(days: -1)))) {
          newlist.add(el);
        }
      } else if (index == 1) {
        if (el.isCompleted!) {
          newlist.add(el);
        }
      }
    }
    if (index == 2) {
      // newlist.addAll(getCacheCanceledAppoint());
    }

    return newlist;
  }

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required bool isConfirmed,
    required bool isCompleted,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'isConfirmed': isConfirmed,
        'isCompleted': isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar("✅ Success", "Appointment status updated successfully");
    } catch (e) {
      debugPrint("Error updating appointment: $e");
      Get.snackbar("❌ Error", "Failed to update appointment");
    }
  }

  void showStatusUpdateDialog(BuildContext context, Appointment appointment) {
    bool isConfirmed = appointment.isConfirmed ?? false;
    bool isCompleted = appointment.isCompleted ?? false;

    Get.dialog(
      AlertDialog(
        title: const Text("Update Appointment Status 🛠️",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text("Confirmed",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              value: isConfirmed,
              onChanged: (val) {
                isConfirmed = val ?? false;
                Get.back(); // Close and reopen dialog to update UI
                showStatusUpdateDialog(
                    context,
                    appointment.copyWith(
                      isConfirmed: isConfirmed,
                      isCompleted: isCompleted,
                    ));
              },
            ),
            CheckboxListTile(
              title: const Text("Completed",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              value: isCompleted,
              onChanged: (val) {
                isCompleted = val ?? false;
                Get.back(); // Close and reopen dialog to update UI
                showStatusUpdateDialog(
                    context,
                    appointment.copyWith(
                      isConfirmed: isConfirmed,
                      isCompleted: isCompleted,
                    ));
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel ❌"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: const Text("Update ✅"),
            onPressed: () {
              updateAppointmentStatus(
                appointmentId: appointment.id!,
                isConfirmed: isConfirmed,
                isCompleted: isCompleted,
              );
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
