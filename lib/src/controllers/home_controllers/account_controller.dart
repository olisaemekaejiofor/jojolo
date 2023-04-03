// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/library.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:jojolo_mobile/src/data/models/payment_history.dart';
import 'package:jojolo_mobile/src/ui/screens/auth_screens/add_child/add_child.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/account/consult_history/manage_bookings/book_consultation.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/stepper_widget.dart';
import 'package:jojolo_mobile/src/utils/api_routes.dart';
import '../../data/models/child.dart';
import '../../data/models/plans.dart';
import '../../data/models/user/notification_model.dart';
import '/src/data/api_data/api_data.dart';
import '/src/data/models/user/caregiver.dart';
import '/src/data/models/user/doctor.dart';

import '../../data/storage_data/storage_data.dart';
import '../../di/service_locator.dart';
import '../../ui/widgets/app_widgets/app_flush.dart';
import '../../utils/colors.dart';
import 'booking_controller.dart';

class AccountController extends ChangeNotifier {
  final Storage store = serviceLocator<Storage>();
  final Register _register = serviceLocator<Register>();
  final Accounts accounts = serviceLocator<Accounts>();
  final plugin = PaystackPlugin();
  var publicKey = 'pk_test_4e5671cac9444847e20902c51f4db32092c88169';
  final PageController controller = PageController(initialPage: 0);
  final CustomTabBarController tabBarController = CustomTabBarController();
  final GroupButtonController buttonController = GroupButtonController();

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController dateC = TextEditingController();

  TextEditingController old = TextEditingController();
  TextEditingController newp = TextEditingController();
  TextEditingController confirm = TextEditingController();
  List<String> list = ['Basic Plan', 'Standard Plan', 'Premium Plan'];
  String? userType;
  String? path;
  String? image;
  late String initial;
  bool loading = true;
  bool buttonLoad = false;
  int curStep = 1;
  Notifications notifications = Notifications(
    emailNotification: false,
    smsNotification: false,
    pushNotification: false,
  );

  List<TimeModel> days = [
    TimeModel(day: 'Monday', available: false, weekDay: 1, time: [], indexes: []),
    TimeModel(day: 'Tuesday', available: false, weekDay: 2, time: [], indexes: []),
    TimeModel(day: 'Wednesday', available: false, weekDay: 3, time: [], indexes: []),
    TimeModel(day: 'Thursday', available: false, weekDay: 4, time: [], indexes: []),
    TimeModel(day: 'Friday', available: false, weekDay: 5, time: [], indexes: []),
    TimeModel(day: 'Saturday', available: false, weekDay: 6, time: [], indexes: []),
    TimeModel(day: 'Sunday', available: false, weekDay: 7, time: [], indexes: []),
  ];

  List<int> daysWeek = [];
  List<dynamic> disabled = [
    "09:00 - 09:30",
    '10:00 - 10:30',
    '11:00 - 11:30',
    '12:00 - 12:30',
    '13:00 - 13:30',
    '14:00 - 14:30',
    '15:00 - 15:30',
    '16:00 - 16:30',
    '17:00 - 17:30',
    '18:00 - 18:30'
  ];
  List<int> selected = [];

  List<Child> children = [];
  DateTime selectedDate = DateTime.now();

  Nature state = Nature.zero;

  List<AppSubscription>? plans = [];
  List<PaymentHistory> paymentHistory = [];

  late UserCaregiver userCaregiver;
  late UserDoctor userDoctor;
  int gender = 0;
  double wallet = 0.00;

  void getType() async {
    userType = await store.getUserType();

    notifyListeners();
  }

  void getChildren() async {
    children = await accounts.getChild();
    loading = false;
    notifyListeners();
  }

  void getUser() async {
    userType = await store.getUserType();
    if (userType == 'caregiver') {
      UserCaregiver user = await accounts.getCaregiver();

      userCaregiver = user;
      initial = user.fullName!.split(' ').first.substring(0, 1).toUpperCase() +
          user.fullName!.split(' ').last.substring(0, 1);

      fname.text = user.fullName!.split(' ').first;

      lname.text = user.fullName!.split(' ').last;
      email.text = user.emailAddress!;
      phone.text = user.phoneNumber!;
      image = user.imageUrl;
      loading = false;
      notifyListeners();
    } else {
      UserDoctor user = await accounts.getDoctor(null);

      userDoctor = user;
      initial = user.fullName!.split(' ')[0].substring(0, 1).toUpperCase() +
          user.fullName!.split(' ')[1].substring(0, 1);

      fname.text = user.fullName!.split(' ')[0];

      lname.text = user.fullName!.split(' ')[1];
      email.text = user.emailAddress!;
      phone.text = user.phoneNumber!;
      bio.text = user.bio.toString();
      image = user.doctorImage;
      loading = false;

      for (var i in days) {
        for (var j in user.availabilityId) {
          if (i.day == j.day) {
            i.time = (j.id?.availability.first.time == null)
                ? []
                : j.id!.availability.first.time;
            i.time!.isNotEmpty ? i.id = j.id!.id : null;
            i.time!.isNotEmpty ? i.timeId = j.id!.availability.first.time.first.id : null;
            i.time!.isNotEmpty ? i.available = true : i.available = false;
          }
        }
      }
      notifyListeners();
    }
    notifyListeners();
  }

  void chooseDay(int weekDay) {
    selected = [];
    buttonController.unselectAll();
    notifyListeners();
    var l = days.firstWhere((e) => e.weekDay == weekDay);

    for (var j in l.time!) {
      var d = DateFormat.Hm().format(j.startTime!.add(const Duration(hours: 1))) +
          ' - ' +
          DateFormat.Hm().format(j.endTime!.add(const Duration(hours: 1)));

      disabled.asMap().forEach((key, value) {
        if (value == d) {
          selected.add(key);
        }
      });
    }

    buttonController.selectIndexes(selected);
    notifyListeners();
  }

  void changePassword(BuildContext ctx) async {
    buttonLoad = true;
    notifyListeners();
    bool result = await accounts.changePassword(old.text, newp.text, confirm.text);
    if (result == true) {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Password Changed Sucessfully',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(ctx);
      });
      notifyListeners();
    } else {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Unable to change password',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
  }

  void update(BuildContext ctx) async {
    buttonLoad = true;
    notifyListeners();

    var check = await accounts.updateInfo(
        fname.text + ' ' + lname.text, email.text, phone.text, bio.text, path);
    if (check == true) {
      buttonLoad = false;

      showFlush(
        ctx,
        message: 'Profile Updated Sucessfully',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(ctx);
      });
      // Navigator.pushNamed(ctx, AccountSettings.routeName);
      getUser();
      notifyListeners();
    } else {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Unable to update profile',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
  }

  void subscribe(BuildContext ctx, int amount) async {
    buttonLoad = true;
    notifyListeners();
    if (controller.page != 0) {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'This Plan is not available',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    } else {
      UserCaregiver user = await accounts.getCaregiver();
      Plans plans = await accounts.getSubPlans();
      var basic = plans.appSubscription.firstWhere((e) => e.subscriptionName == 'Basic');
      var standard =
          plans.appSubscription.firstWhere((e) => e.subscriptionName == 'Standard');
      var premium =
          plans.appSubscription.firstWhere((e) => e.subscriptionName == 'Premium');

      var ref = await accounts.sub();
      Charge charge = Charge()
        ..accessCode = ref.accessCode
        ..email = user.emailAddress
        ..amount = (amount == 2)
            ? (premium.monthlyPlan[0].planAmount! * 100)
            : (amount == 1)
                ? (standard.monthlyPlan[0].planAmount! * 100)
                : (basic.monthlyPlan[0].planAmount! * 100) // In base currency
        ..reference = ref.reference
        ..putCustomField('Charged From', 'Jojolo');
      // Navigator.pop(ctx);
      await plugin.checkout(
        ctx,
        charge: charge,
        fullscreen: false,
        logo: const MyLogo(),
      );

      var check = await accounts.verifyPayment(ref.reference);
      if (check == true) {
        buttonLoad = false;
        showFlush(
          ctx,
          message: 'Subscribed Sucessfully',
          image: 'assets/Active2.svg',
          color: greenColor,
        );
        notifyListeners();
      } else {
        buttonLoad = false;
        showFlush(
          ctx,
          message: 'Subscription Failed',
          image: 'assets/Active.svg',
          color: errorColor,
        );
        notifyListeners();
      }
    }
  }

  void addImage() async {
    var doc = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["png", "jpg", "jpeg"],
        allowCompression: false);

    path = doc!.paths.first;
    notifyListeners();
  }

  void selectDate(BuildContext ctx) async {
    final DateTime? picked = await showDatePicker(
        context: ctx,
        initialDate: selectedDate,
        firstDate: DateTime(2018, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) selectedDate = picked;
    var date =
        "${picked!.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
    dateC.text = date;
    notifyListeners();
  }

  void logout() {
    store.deleteToken();
    notifyListeners();
  }

  void addChild(BuildContext ctx) async {
    buttonLoad = true;
    notifyListeners();
    var check = await _register.addChild(
      fname.text,
      selectedDate,
      (gender == 0) ? 'male' : 'female',
      bio.text,
      lname.text,
      'None',
    );
    if (check == true) {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Child Added Successfully',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      Navigator.pushReplacementNamed(ctx, AddChild.routeName);
      notifyListeners();
    } else {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Could not add child',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
    notifyListeners();
  }

  void createAvailability(
      BuildContext ctx, String day, GroupButtonController controller) async {
    buttonLoad = true;
    notifyListeners();
    List<Map<String, String>> times = [];

    for (var i = 0; i < controller.selectedIndexes.length; i++) {
      var startDate = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(
            (disabled[i].split('')[1] == ':')
                ? disabled[i].split('')[0]
                : disabled[i].split('')[0] + disabled[i].split('')[1],
          )).toUtc().toIso8601String();
      var endDate = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              int.parse(
                (disabled[i].split('')[1] == ':')
                    ? disabled[i].split('')[0]
                    : disabled[i].split('')[0] + disabled[i].split('')[1],
              ),
              30)
          .toUtc()
          .toIso8601String();
      times.add({
        'startTime': startDate,
        'endTime': endDate,
      });
    }
    var check = await accounts.createAvailability(
      day,
      times,
    );

    if (check == true) {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Availability Created Successfully',
        image: 'assets/Active2.svg',
        color: greenColor,
      );

      notifyListeners();
    } else {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Could not Create availability',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
  }

  void updateAvailability(
    BuildContext ctx,
    String day,
    GroupButtonController controller,
    String availability,
    String timeId,
  ) async {
    buttonLoad = true;
    notifyListeners();

    List<Map<String, String>> times = [];
    List<int> indexes = controller.selectedIndexes.toList();

    for (var i in indexes) {
      var startDate = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(
            (disabled[i].split('')[1] == ':')
                ? disabled[i].split('')[0]
                : disabled[i].split('')[0] + disabled[i].split('')[1],
          )).toUtc().toIso8601String();
      var endDate = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              int.parse((disabled[i].split('')[1] == ':')
                  ? disabled[i].split('')[0]
                  : disabled[i].split('')[0] + disabled[i].split('')[1]),
              30)
          .toUtc()
          .toIso8601String();
      times.add({
        'startTime': startDate,
        'endTime': endDate,
      });
    }

    var check = await accounts.setAvailability(
      availability,
      day,
      times,
      timeId,
    );

    if (check == true) {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Availability Updated Successfully',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      notifyListeners();
    } else {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Could not Update availability',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
  }

  void deleteAvailability(BuildContext ctx) async {
    buttonLoad = true;
    notifyListeners();
    var u = days.where((e) => e.id != null && e.available == false).toList();

    for (var i in u) {
      await accounts.deleteAvailability(i.id!);
      notifyListeners();
    }

    buttonLoad = false;
    Navigator.pushReplacementNamed(ctx, BookConsultation.routeName);
    notifyListeners();
  }

  void toggleBookings(bool val) {
    print(val);
  }

  void getNotifications() async {
    notifications = await accounts.getNotifications();
    notifyListeners();
  }

  void setNotifications(BuildContext ctx) async {
    String? id = await store.getId();
    String? token = await store.getToken();
    String? type = await store.getUserType();

    var body = (type == 'caregiver')
        ? {
            "caregiverId": "$id",
            "pushNotification": notifications.pushNotification,
            "emailNotification": notifications.emailNotification,
            "smsNotification": notifications.smsNotification
          }
        : {
            "doctorId": "$id",
            "pushNotification": notifications.pushNotification,
            "emailNotification": notifications.emailNotification,
            "smsNotification": notifications.smsNotification
          };
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = (type == 'caregiver')
        ? Uri.parse(AppUrl.caregiver + '/create-notification-setting')
        : Uri.parse(AppUrl.doctor + '/create-notification-setting');

    var res = await http.post(url, headers: headers, body: jsonEncode(body));

    if (res.statusCode == 200) {
      showFlush(
        ctx,
        message: 'Notification settings updated successfully',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
    } else {
      showFlush(
        ctx,
        message: 'Unable update notification settings',
        image: 'assets/Active.svg',
        color: errorColor,
      );
    }
  }

  void getWalletBalance() async {
    String? id = await store.getId();
    var a = await accounts.getDoctor(id);

    wallet = a.wallet.toDouble();
    paymentHistory = await accounts.getPaymentHistory();
    notifyListeners();
  }

  void getSubPlans() async {
    var i = await accounts.getSubPlans();
    plans = i.appSubscription;
    notifyListeners();
  }
}

class MyLogo extends StatelessWidget {
  const MyLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: const Text(
        "JLO",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
