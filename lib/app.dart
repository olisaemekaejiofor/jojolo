import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/chat_controller.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/pay_per_use_screen.dart';
import 'package:provider/provider.dart';

import '/src/ui/screens/auth_screens/add_child/add_child.dart';
import '/src/ui/screens/auth_screens/add_child/child_details.dart';
import '/src/ui/screens/auth_screens/add_doctor_license.dart';
import '/src/ui/screens/auth_screens/add_id.dart';
import '/src/ui/screens/auth_screens/forgot_password/password_update.dart';
import '/src/ui/screens/auth_screens/login_screen.dart';
import '/src/ui/screens/auth_screens/register_screen.dart';
import '/src/ui/screens/home_screens/account/account.dart';
import '/src/ui/screens/home_screens/account/account_settings/account_settings.dart';
import '/src/ui/screens/home_screens/account/account_settings/change_password.dart';
import '/src/ui/screens/home_screens/account/account_settings/identity_verification.dart';
import '/src/ui/screens/home_screens/account/account_settings/profile_settings.dart';
import '/src/ui/screens/home_screens/account/consult_history/consult_history.dart';
import '/src/ui/screens/home_screens/account/consult_history/manage_bookings/book_consultation.dart';
import '/src/ui/screens/home_screens/account/consult_history/manage_bookings/manage_bookings.dart';
import '/src/ui/screens/home_screens/account/donate/donate.dart';
import '/src/ui/screens/home_screens/account/earnings/earnings.dart';
import '/src/ui/screens/home_screens/account/jojolo_points/jojolo_points.dart';
import '/src/ui/screens/home_screens/account/manage_sub/manage_subscription.dart';
import '/src/ui/screens/home_screens/account/notification_settings/notification_settings.dart';
import '/src/ui/screens/home_screens/booking/book_wellness.dart';
import '/src/ui/screens/home_screens/booking/booking.dart';
import '/src/ui/screens/home_screens/booking/booking_request.dart';
import '/src/ui/screens/home_screens/booking/booking_schedule.dart';
import '/src/ui/screens/home_screens/booking/booking_vaccination.dart';
import '/src/ui/screens/home_screens/forum/create_post.dart';
import '/src/ui/screens/home_screens/forum/forum_screen.dart';
import '/src/ui/screens/home_screens/private_chat/private_chat.dart';
import '/src/ui/screens/home_screens/search_screen.dart';
import '/src/utils/page_route.dart';
import 'src/ui/screens/home_screens/account/consult_history/consult_details.dart';
import 'src/ui/screens/home_screens/booking/booking_consultation.dart';

class Jojolo extends StatelessWidget {
  final bool isAuth;
  const Jojolo({Key? key, required this.isAuth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatController>(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => AccountController()),
      ],
      child: MaterialApp(
        title: 'Jojolo',
        debugShowCheckedModeBanner: false,
        home: (isAuth) ? const Forum() : const LoginScreen(),
        onGenerateRoute: (routeSettings) {
          switch (routeSettings.name) {
            //auth screens
            case LoginScreen.routeName:
              final args = routeSettings.arguments as ScreenArguments;
              return CustomPageRoute(child: LoginScreen(text: args.text));
            case RegisterScreen.routeName:
              return CustomPageRoute(child: const RegisterScreen());
            case PasswordUpdate.routeName:
              return CustomPageRoute(child: const PasswordUpdate());

            //upload child details screens
            case AddChild.routeName:
              return CustomPageRoute(child: const AddChild());
            case ChildDetails.routeName:
              return CustomPageRoute(child: const ChildDetails());

            //uplaod health-professional documents screens
            case AddLicense.routeName:
              return CustomPageRoute(child: const AddLicense());
            case AddId.routeName:
              return CustomPageRoute(child: const AddId());

            //forum Screens
            case Forum.routeName:
              return CustomPageRoute(child: const Forum());
            // case ViewPost.routeName:
            //   return MaterialPageRoute(builder: (context) => ViewPost(postId: postId), settings: )
            case CreatePost.routeName:
              return CustomPageRoute(child: const CreatePost());
            case SearchPage.routeName:
              return CustomPageRoute(child: const SearchPage());

            //private-chat screens
            case PrivateChat.routeName:
              return CustomPageRoute(child: const PrivateChat());

            //bookings screens
            case Booking.routeName:
              return CustomPageRoute(child: const Booking());
            case BookingSchedule.routeName:
              return CustomPageRoute(child: const BookingSchedule());
            case BookingConsultation.routeName:
              return CustomPageRoute(child: const BookingConsultation());
            // case BookConsultationCare.routeName:
            //   return CustomPageRoute(child: BookConsultationCare());
            case BookingRequest.routeName:
              return CustomPageRoute(child: const BookingRequest());

            case PayPerUseScreen.routeName:
              return CustomPageRoute(child: const PayPerUseScreen());
            case VaccinationService.routeName:
              return CustomPageRoute(child: const VaccinationService());
            case WellnessCheckup.routeName:
              return CustomPageRoute(child: const WellnessCheckup());

            //account screens
            case Account.routeName:
              return CustomPageRoute(child: const Account());
            //account settings
            case AccountSettings.routeName:
              return CustomPageRoute(child: const AccountSettings());
            case ProfileSettings.routeName:
              return CustomPageRoute(child: const ProfileSettings());
            case ChangePassword.routeName:
              return CustomPageRoute(child: const ChangePassword());
            case IdentityVerification.routeName:
              return CustomPageRoute(child: const IdentityVerification());
            //notification settings
            case NotificationSettings.routeName:
              return CustomPageRoute(child: const NotificationSettings());
            //consult settings
            case ConsultHistory.routeName:
              return CustomPageRoute(child: const ConsultHistory());
            case ConsultDetails.routeName:
              return CustomPageRoute(child: const ConsultDetails());

            //jojolo-points
            case JojoloPoints.routeName:
              return CustomPageRoute(child: const JojoloPoints());
            //donate screens
            case Donate.routeName:
              return CustomPageRoute(child: const Donate());

            //only account doctor screens
            case Earnings.routeName:
              return CustomPageRoute(child: const Earnings());
            case ManageBookings.routeName:
              return CustomPageRoute(child: const ManageBookings());
            case BookConsultation.routeName:
              return CustomPageRoute(child: const BookConsultation());

            //only caregiver screens
            case ManageSubscription.routeName:
              return CustomPageRoute(child: const ManageSubscription());
            default:
              return CustomPageRoute(child: const LoginScreen());
          }
        },
      ),
    );
  }
}

class ScreenArguments {
  final String text;

  ScreenArguments({required this.text});
}
