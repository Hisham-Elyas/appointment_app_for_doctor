import 'package:get/get.dart';

import '../../data/dataSoureces/remoteDataSource/chats_remotdata.dart';
import '../../data/model/doctor_model.dart';
import '../../middleware/middleware.dart';
import '../../view/screen/auth/create_new_password_screen.dart';
import '../../view/screen/auth/login_screen.dart';
import '../../view/screen/auth/reset_password_screen.dart';
import '../../view/screen/auth/sign_up_screen.dart';
import '../../view/screen/auth/verify_code_screen.dart';
import '../../view/screen/home/main_screen.dart';
import '../../view/screen/onBording/on_boarding_screen.dart';
import '../../view/screen/onBording/start_screen.dart';

class AppRoutes {
  static const String onBoarding = '/';
  static const String startScreen = '/Start-Screen';
  static const String loginScreen = '/Login-Screen';
  static const String signUpScreen = '/SignUp-Screen';
  static const String resetPasswordScreen = '/Reset-Password';
  static const String verifyCodeScreen = '/Verify-Code';
  static const String createNewPasswordScreen = '/Create-New-Password';
  static const String homeScreen = '/Home-Screen';

  /// Drugs-Screen
  static const String drugsScrren = '/Drugs-Screen';
  static const String drugsDetailScrren = '/Drugs-Detail-Screen';
  static const String drugsCartScreen = '/Drugs-Cart-Screen';
  static const String drugsSearchScreen =
      '/Drugs-Search-Screen'; //SearchDrugsScreen
  /////  DoctorsScrren
  static const String doctorsScrren = '/Doctors-Screen';
  static const String doctorDetailScrren = '/Doctor-Detail-Screen';
  static const String doctorListScreen = '/Doctor-List-Screen';

  static const String favoriteScreen = '/Favorite-Screen';
  static const String scheduleScreen = '/Schedule-Screen';
  static const String chatsScreen = '/Chats-Screen';
  static const String locationScreen = '/Location-Screen';
  static const String feedbackScreen = '/Feedback-Screen';
  static const String addressListScreen = '/Address_List-Screen';
  static const String notificationsScreen = '/Notifications-Screen';
  static const String orderScreen = '/Order-Screen';
  static const String settingsScreen = '/Settings-Screen';
  static const String hospitalScreen = '/Hospital-Screen';
  static const String ambulancScreen = '/Ambulanc-Screen';
  static String getOnBoardingn() => onBoarding;
  static String getStartScreen() => startScreen;
  static String getLoginScreen() => loginScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getResetPasswordScreen() => resetPasswordScreen;
  static String getVerifyCodeScreen() => verifyCodeScreen;
  static String getCreateNewPasswordScreen() => createNewPasswordScreen;
  static String getHomeScreen() => homeScreen;
  static String getLocationScreen() => locationScreen;
  static String getAddressListScreen() => addressListScreen;
  static String getFeedbackScreen() => feedbackScreen;
  static String getNotificationsScreen() => notificationsScreen;
  static String getOrderScreen() => orderScreen;
  static String getHospitalScreen() => hospitalScreen;
  static String getAmbulancScreen() => ambulancScreen;
  static String getSettingsScreen() => settingsScreen;

  /// profile screen

  static String getFavoriteScreen() => favoriteScreen;
  static String getScheduleScreen() => scheduleScreen;
  static String getChatsScreenScreen(UserModel doctorinfo) =>
      "$chatsScreen?Doctorinfo=${doctorinfo.toMap()}";

  /// Drugs-Screen
  static String getDrugsScrren() => drugsScrren;
  static String getDrugsDetailScrren() => drugsDetailScrren;
  static String getDrugsCartScreen() => drugsCartScreen;
  static String getDrugsSearchScreen() => drugsSearchScreen;
  /////  DoctorsScrren
  static String getDoctorsScreen() => doctorsScrren;
  static String getDoctorDetailScrren(Doctor doctorinfo) =>
      '$doctorDetailScrren?Doctorinfo=${doctorinfo.toJson()}';
  static String getDoctorListScreen(String category) =>
      '$doctorListScreen?Category=$category';
  static List<GetPage<dynamic>>? myPages = [
    GetPage(
        name: onBoarding,
        page: () => const OnBoarding(),
        middlewares: [MyMiddleware()],
        transition: Transition.circularReveal),
    GetPage(
        name: startScreen,
        page: () => const StartScreen(),
        transition: Transition.circularReveal),
    GetPage(
        name: loginScreen,
        page: () => const LoginScreen(),
        transition: Transition.circularReveal),
    GetPage(
        name: signUpScreen,
        page: () => const SignUpScreen(),
        transition: Transition.circularReveal),
    GetPage(
        name: resetPasswordScreen,
        page: () => const ResetPasswordScreen(),
        transition: Transition.circularReveal),
    GetPage(
        name: verifyCodeScreen,
        page: () => const VerifyCodeScreen(),
        transition: Transition.circularReveal),
    GetPage(
        name: createNewPasswordScreen,
        page: () => const CreateNewPasswordScreen(),
        transition: Transition.circularReveal),
    GetPage(
        name: homeScreen,
        // page: () => const HomeScreen(),
        // bindings: const [
        //   // BindingsBuilder.put(() => DrugsController()),
        //   // BindingsBuilder.put(() => DoctorController()),
        //   // BindingsBuilder.put(() => ApointmentController()),
        //   // BindingsBuilder.put(() => ChatsController()),
        // ],
        page: () => const MainScreen(),
        transition: Transition.circularReveal),

    /// Drugs-Screen
  ];
}
