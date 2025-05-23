import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/appointment_controller.dart';
import '../../../core/constant/routes.dart';
import '../../../data/repositories/auth_repo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ApointmentController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // Implement your logout functionality here
              final AuthRepoImpFirebase authRepo = Get.find();
              authRepo.logeOut().then((value) {
                if (value) {
                  Get.offAllNamed(AppRoutes.loginScreen);
                } else {
                  Get.snackbar('Error', 'Logout failed');
                }
              });
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
        title: const Text('Home', style: TextStyle(color: Colors.black)),
      ),
      body: const SafeArea(
        child: Column(children: [
          Text('Home Screen'),
          // Add your widgets here
        ]),
      ),
    );
  }
}
