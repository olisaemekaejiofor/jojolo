import 'package:get_it/get_it.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/notification_controller.dart';
import 'package:jojolo_mobile/src/data/api_data/api_implementation.dart/chat_implementation/chat_implementation.dart';

import '/src/controllers/home_controllers/booking_controller.dart';
import '/src/controllers/home_controllers/chat_controller.dart';
import '/src/data/api_data/api_implementation.dart/auth_implementation/forgot_implementaion.dart';
import '../data/api_data/api_implementation.dart/booking_implementation/booking_implementation.dart';
import '../data/api_data/api_implementation.dart/account_implementation/account_impl.dart';
import '/src/controllers/auth_controllers/forgot_password_controller.dart';
import '../controllers/home_controllers/account_controller.dart';
import '/src/data/api_data/api_data.dart';
import '/src/controllers/home_controllers/forum_controller.dart';
import '/src/controllers/auth_controllers/login_controller.dart';
import '/src/controllers/auth_controllers/register_controller.dart';
import '/src/controllers/home_controllers/search_controller.dart';
import '/src/data/storage_data/storage_data.dart';
import '/src/data/storage_data/storage_implentation.dart';
import '/src/data/api_data/api_implementation.dart/forum_implementation/post_implementation.dart';
import '../data/api_data/api_implementation.dart/search_implementation/search_implementation.dart';
import '../controllers/bottom_navigation_controller.dart';
import '../data/api_data/api_implementation.dart/auth_implementation/login_implementation.dart';
import '../data/api_data/api_implementation.dart/auth_implementation/register_implementation.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<Register>(() => RegisterImpl());
  serviceLocator.registerLazySingleton<Login>(() => LoginImpl());
  serviceLocator.registerLazySingleton<PostFeed>(() => PostImpl());
  serviceLocator.registerLazySingleton<Storage>(() => Store());
  serviceLocator.registerLazySingleton<Search>(() => SearchImpl());
  serviceLocator.registerLazySingleton<ForgotPass>(() => ForgotImpl());
  serviceLocator.registerLazySingleton<Accounts>(() => AccountImpl());
  serviceLocator.registerLazySingleton<Book>(() => BookingImpl());
  serviceLocator.registerLazySingleton<Chat>(() => ChatImpl());
  serviceLocator.registerFactory<RegisterViewController>(() => RegisterViewController());
  serviceLocator.registerFactory<LoginViewController>(() => LoginViewController());
  serviceLocator
      .registerFactory<ForgotPasswordController>(() => ForgotPasswordController());
  serviceLocator.registerFactory<BottomNavController>(() => BottomNavController());
  serviceLocator.registerFactory<ForumController>(() => ForumController());
  serviceLocator.registerFactory<SearchController>(() => SearchController());
  serviceLocator.registerFactory<AccountController>(() => AccountController());
  serviceLocator.registerFactory<BookingController>(() => BookingController());
  serviceLocator.registerFactory<ChatController>(() => ChatController());
  serviceLocator.registerFactory<NotificationController>(() => NotificationController());
}
