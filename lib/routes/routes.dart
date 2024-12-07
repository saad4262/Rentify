// import 'package:collaboration/modules/on_boarding_screen/dashboard_screen/view/dashboard_screen.dart';
// import 'package:collaboration/modules/on_boarding_screen/signup_basic_info/view/signup_basic_Info.dart';
// import 'package:collaboration/modules/on_boarding_screen/signup_gps_approval/view/signup_gps_approval.dart';
// import 'package:collaboration/modules/on_boarding_screen/signup_success/view/signup_success.dart';
// import 'package:collaboration/modules/on_boarding_screen/signup_upload_image/view/signup_uploadImage.dart';
// import 'package:collaboration/modules/on_boarding_screen/tipee_signup_success/view/tipee_signup_success.dart';
// import 'package:collaboration/modules/welcome_screen/views/welcom_screen.dart';
// import 'package:collaboration/routes/routes_name.dart';
// import 'package:collaboration/modules/login_screen/view/login_screen.dart';
// import 'package:collaboration/modules/reset_password_screen/view/reset_password_screen.dart';
import 'package:flutter/material.dart';
// import 'package:collaboration/modules/on_boarding_screen/signup_phone_verification/view/signup_verificaiton.dart';
// import 'package:collaboration/modules/profile_screen/view/profile_screen.dart';
//
import 'package:realestate/modules/welcome_screen/view/welcome_screen.dart';
import 'package:realestate/routes/routes_name.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen2.dart';




import 'package:realestate/modules/welcome_screen/view/welcome_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RoutesName.welcome:
        return MaterialPageRoute(builder: (BuildContext context) =>  WelcomeScreen());
      case RoutesName.welcome22:
        return MaterialPageRoute(builder: (BuildContext context) =>  const WelcomeScreen2());
     //  case RoutesName.login:
     //    return MaterialPageRoute(builder: (BuildContext context) => const LoginPage());
     // case RoutesName.resetScreen:
     //    return MaterialPageRoute(builder: (BuildContext context) => const ResetPasswordPage());
     //  case RoutesName.gpsApproval:
     //    return MaterialPageRoute(builder: (BuildContext context) => const SignupGpsApprovalScreen());
     //  case RoutesName.basicInfo:
     //    return MaterialPageRoute(builder: (BuildContext context) => const SignupBasicInfoScreen());
     //  case RoutesName.success:
     //    return MaterialPageRoute(builder: (BuildContext context) => const SignupSuccessScreen());
     //  case RoutesName.verification:
     //    return MaterialPageRoute(builder: (BuildContext context) =>  OtpScreen());
     //  case RoutesName.uploadImage:
     //    return MaterialPageRoute(builder: (BuildContext context) =>  const SignupUploadImage());
     //  case RoutesName.signupSuccess:
     //    return MaterialPageRoute(builder: (BuildContext context) =>  const TipeeSignupSuccess());
     //  case RoutesName.dashboard:
     //    return MaterialPageRoute(builder: (BuildContext context) =>  const DashboardScreen());
     //  case RoutesName.profile:
     //    return MaterialPageRoute(builder: (BuildContext context) =>  const ProfileScreen());



      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}