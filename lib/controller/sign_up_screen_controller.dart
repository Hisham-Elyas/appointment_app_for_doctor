import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constant/routes.dart';
import '../core/constant/string.dart';
import '../core/functions/coustom_overlay.dart';
import '../data/model/user_model.dart';
import '../data/repositories/auth_repo.dart';

class SignUpScreenController extends GetxController {
  final GlobalKey<FormState> signUpformKey = GlobalKey();
  late String userName;
  late String email;
  late String password;
  late final AuthRepoImpFirebase authRepo = Get.find();

  Future<void> submit() async {
    Get.focusScope!.unfocus();
    if (!signUpformKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    if (selectedSpecialty == null) {
      Get.snackbar("❗ Error", "Please select a specialty");
      return;
    }
    signUpformKey.currentState!.save();
    UserModel user = UserModel(
      email: email,
      name: userName,
      password: password,
      phone: phoneNumber.toString(),
      address: address,
      specialty: selectedSpecialty,
      phoneNunber: phoneNumber,
      hoursOfOperation: '',
      description: description,
    );
    showOverlay(
      asyncFunction: () async {
        final bool isSuccess = await authRepo.signUp(userModel: user);

        if (isSuccess) {
          Get.offAllNamed(AppRoutes.getHomeScreen());
        }
      },
    );
  }

  bool isShowPass = true;
  showPassword() {
    isShowPass = !isShowPass;
    update();
    Future.delayed(const Duration(seconds: 1), () {
      isShowPass = !isShowPass;
      update();
    });
  }

  set setEmail(val) {
    email = val;
  }

  set setPassword(val) {
    password = val;
  }

  set setuserName(val) {
    userName = val;
  }

  bool isvalidEmail = false;
  bool isvalidUserName = false;
  bool isvalidpassword = false;
  String? userNamevalidator(val) {
    isvalidUserName = false;
    if (val.isEmpty) {
      return Type_your_Name.tr;
    } else if (val.length < 4) {
      return Name_can_not_be_less_than_4_characters.tr;
    } else {
      isvalidUserName = true;
      update();

      return null;
    }
  }

  String? emailvalidator(String? val) {
    isvalidEmail = false;
    if (val!.isEmpty) {
      return Type_your_email_adress.tr;
    } else if (!GetUtils.isEmail(val)) {
      return "Type in a valid email adress";
    } else {
      isvalidEmail = true;
      update();
      return null;
    }
  }

  String? addressvalidator(String? val) {
    isvalidEmail = false;
    if (val!.isEmpty) {
      return Type_your_email_adress.tr;
    } else if (val.length < 4) {
      return "Type in a valid email adress";
    } else {
      isvalidEmail = true;
      update();
      return null;
    }
  }

  String? descriptionvalidator(String? val) {
    isvalidEmail = false;
    if (val!.isEmpty) {
      return Type_your_email_adress.tr;
    } else if (val.length < 15) {
      return "Type in a valid description ";
    } else {
      isvalidEmail = true;
      update();
      return null;
    }
  }

  String? phoneNumbervalidator(String? val) {
    isvalidEmail = false;
    if (val!.isEmpty) {
      return Type_your_email_adress.tr;
    } else if (!GetUtils.isPhoneNumber(val)) {
      return "Type in a valid Phone Number ";
    } else {
      isvalidEmail = true;
      update();
      return null;
    }
  }

  String? passwordvalidator(val) {
    isvalidpassword = false;
    if (val.isEmpty) {
      return Enter_your_password.tr;
    } else if (val.length < 6) {
      return Password_can_not_be_less_than_six_characters.tr;
    } else {
      isvalidpassword = true;
      update();

      return null;
    }
  }

  late String address, description;
  late int phoneNumber;
  set setName(val) => userName = val;

  set setAddress(val) => address = val;
  set setPhoneNumber(val) => phoneNumber = int.tryParse(val) ?? 0;

  set setDescription(val) => description = val;
  String? selectedSpecialty;
  final specialty = [
    General,
    Lungs_Specialist,
    Dentist,
    Psychiatrist,
    Surgeon,
    Cardiologist,
    Covid,
  ];
}
