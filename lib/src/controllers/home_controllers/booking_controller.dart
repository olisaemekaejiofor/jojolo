// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/private_chat/check_for_sub.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';

import '/src/data/models/booking_models/list_doctor.dart';
import '/src/data/models/child.dart';
import '/src/data/models/user/doctor.dart';
import '/src/data/storage_data/storage_data.dart';
import '/src/di/service_locator.dart';
import '/src/ui/screens/home_screens/booking/booking.dart';
import '../../data/api_data/api_data.dart';
import '../../data/models/booking_models/doctor_request.dart';
import '../../data/models/user/caregiver.dart';
import '../../ui/widgets/app_widgets/app_flush.dart';
import '../../ui/widgets/app_widgets/stepper_widget.dart';
import '../../utils/colors.dart';

class BookingController extends ChangeNotifier {
  final Storage store = serviceLocator<Storage>();
  final Accounts accounts = serviceLocator<Accounts>();
  final Book booking = serviceLocator<Book>();
  final PageController controller = PageController(initialPage: 0);
  final TextEditingController text = TextEditingController();

  final TextEditingController nameofChild = TextEditingController();
  final TextEditingController where = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController allergies = TextEditingController();
  final TextEditingController specialneeds = TextEditingController();
  final TextEditingController vaccination = TextEditingController();

  final TextEditingController presentingComplaint = TextEditingController();
  final TextEditingController observations = TextEditingController();
  final TextEditingController workingDiagnosis = TextEditingController();
  final TextEditingController investigations = TextEditingController();
  final TextEditingController prescription = TextEditingController();
  final GroupButtonController buttonController = GroupButtonController();

  List<DateTime> day = [];
  List<TimeModel> days = [
    TimeModel(
      day: 'Monday',
      available: false,
      weekDay: 1,
      time: [],
    ),
    TimeModel(day: 'Tuesday', available: false, weekDay: 2, time: []),
    TimeModel(day: 'Wednesday', available: false, weekDay: 3, time: []),
    TimeModel(day: 'Thursday', available: false, weekDay: 4, time: []),
    TimeModel(day: 'Friday', available: false, weekDay: 5, time: []),
    TimeModel(day: 'Saturday', available: false, weekDay: 6, time: []),
    TimeModel(day: 'Sunday', available: false, weekDay: 7, time: [])
  ];
  List<int> weekday = [];
  List<int> daysWeek = [];
  List<String> disabled = [
    "9:00 AM - 9:30 AM",
    '10:00 AM - 10:30 AM',
    '11:00 AM - 11:30 AM',
    '12:00 PM - 12:30 PM',
    '1:00 PM - 1:30 PM',
    '2:00 PM - 2:30 PM',
    '3:00 PM - 3:30 PM',
    '4:00 PM - 4:30 PM',
    '5:00 PM - 5:30 PM',
    "6:00 PM - 6:30 PM",
  ];

  List<dynamic> disabled1 = [
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
  Map<String, List<ListDoctor>> map = {};

  List<ListDoctor> allDoctors = [];
  DateTime embeddedCalendar = DateTime.now();
  DateTime selectedDate = DateTime.now();
  late UserCaregiver userCaregiver;
  int curStep = 1;
  Nature state = Nature.zero;
  List<Bookings> rideRequest = [];
  List<Bookings> ride = [];
  List<Child> child = [];
  List<ListDoctor> doctors = [];
  List<UserDoctor> ds = [];
  bool loading = true;
  bool buttonLoad = false;
  List<String> roles = ['All'];
  DateTime? selectedDay;

  String month() {
    String month = DateFormat.MMMM().format(embeddedCalendar);
    return month;
  }

  String type = '';

  void getChild() async {
    child = await accounts.getChild();
    loading = false;
    notifyListeners();
  }

  void getDate() {
    embeddedCalendar = DateTime.now();
    notifyListeners();
  }

  void onDateChanged(DateTime day) {
    selected = [];
    daysWeek = List.generate(10, (index) => 0 + index);
    buttonController.enableIndexes(daysWeek);
    notifyListeners();

    var week = DateFormat('EEEE').format(day);
    for (var i in days) {
      if (i.day == week) {
        for (var j in i.time!) {
          var d = DateFormat.jm().format(j.startTime!.add(const Duration(hours: 1))) +
              ' - ' +
              DateFormat.jm().format(j.endTime!.add(const Duration(hours: 1)));
          disabled.asMap().forEach((key, value) {
            if (value == d) {
              selected.add(key);
            }
          });
        }
      }
    }
    List<int> l = [];
    for (var element in daysWeek) {
      if (!selected.contains(element)) {
        l.add(element);
      }
    }
    buttonController.disableIndexes(l);
    selectedDay = day;
    notifyListeners();
  }

  void postConsultation(
      BuildContext ctx, String caregiver, String aid, String bid) async {
    buttonLoad = true;
    notifyListeners();
    var d = await booking.postConsultationForm(
      caregiver,
      presentingComplaint.text,
      observations.text,
      workingDiagnosis.text,
      investigations.text,
      prescription.text,
      prescription.text,
    );

    if (d == true) {
      buttonLoad = false;
      booking.completeRequest(aid, bid);
      showFlush(
        ctx,
        message: 'Consultation Complete',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      Navigator.pushReplacementNamed(ctx, Booking.routeName);

      notifyListeners();
    } else {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Cannot Send Form',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
    notifyListeners();
  }

  void getDetails(String id) async {
    var bookDoctor = await accounts.getDoctor(id);
    for (var i in days) {
      for (var j in bookDoctor.availabilityId) {
        if (i.day == j.day) {
          i.id = j.id?.id;
          i.time = (j.id?.availability.first.time == null)
              ? []
              : j.id!.availability.first.time;
          i.time!.isNotEmpty ? i.available = true : i.available = false;
        }
      }
      notifyListeners();

      onDateChanged(embeddedCalendar);
      selectedDay = embeddedCalendar;
      notifyListeners();
    }
    List<TimeModel> newList = days.where((e) => e.available == true).toList();
    for (var i in newList) {
      weekday.add(i.weekDay);
    }
    var l = List<DateTime>.generate(7, (i) {
      return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + i);
    });

    for (var i in l) {
      for (var j in newList) {
        var u = newList.where((e) => e.weekDay == embeddedCalendar.weekday).toList();
        if (u.isEmpty) {
          if (i.weekday == j.weekDay) {
            embeddedCalendar = i;
            notifyListeners();
          }
        }
      }
    }

    loading = false;
    notifyListeners();
  }

  void getUser() async {
    var type = await store.getUserType();
    if (type == 'caregiver') {
      UserCaregiver user = await accounts.getCaregiver();
      userCaregiver = user;
      loading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  void getDoctors() async {
    var d = await booking.getDoctorList();
    doctors = d.where((e) => e.isAvailable == true).toList();
    allDoctors = d.where((e) => e.isAvailable == true).toList();
    for (var i in doctors) {
      var l = doctors.where((e) => e.role == i.role).toList();
      map.addAll({"${i.role}": l});
    }
    seperateList(doctors);
    loading = false;
    notifyListeners();
  }

  void update() async {
    Timer.periodic(const Duration(minutes: 2), (timer) async {
      doctors = await booking.getDoctorList();

      notifyListeners();
    });
  }

  void getType() async {
    String? data = await store.getUserType();

    type = data.toString();
    notifyListeners();
  }

  void seperateList(List<ListDoctor> d) {
    for (var i in d) {
      roles.add(i.role.toString());
    }
  }

  void getBookingRequest() async {
    rideRequest = await booking.getDoctorRequest();

    loading = false;
    notifyListeners();
  }

  void getBookingSchedule() async {
    getUser();
    String? data = await store.getUserType();

    type = data.toString();
    notifyListeners();
    rideRequest = await booking.getUpcomingEvents();

    // ignore: avoid_function_literals_in_foreach_calls
    rideRequest.forEach((i) async {
      if (i.doctorId == null) {
      } else {
        await accounts.getDoctor(i.doctorId!.id).then((value) => ds.add(value));
      }
    });

    ride = (rideRequest.length > 1) ? rideRequest.sublist(1) : [];

    Future.delayed(const Duration(seconds: 4), () {
      loading = false;
      notifyListeners();
    });
    notifyListeners();
  }

  void acceptRequest(
      String aid, String bid, String cid, BuildContext ctx, int index) async {
    String? uid = await store.getId();
    String? name = await store.getName();
    var check = await booking.acceptRequest(aid, bid);
    if (check == true) {
      rideRequest.removeAt(index);
      showFlush(
        ctx,
        message: 'Booking request accepted',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      SocketService().socket.emit('notification-message', {
        "message": "Dr $name has ACCEPTED your booking request",
        "name": "$uid",
        "recipient": cid,
        "externalModelType": "Doctor",
        "title": "Booking Activity"
      });
      notifyListeners();
    } else {
      showFlush(
        ctx,
        message: 'Unable to accept request',
        image: 'assets/Active.svg',
        color: errorColor,
      );
    }
  }

  void declineRequest(
      String aid, String bid, String cid, BuildContext ctx, int index) async {
    var check = await booking.rejectRequest(aid, bid);
    String? uid = await store.getId();
    String? name = await store.getName();
    if (check == true) {
      SocketService().socket.emit('notification-message', {
        "message": "Dr $name has DECLINED your booking request",
        "name": "$uid",
        "recipient": cid,
        "externalModelType": "Doctor",
        "title": "Booking Activity"
      });
      if (index == 22234) {
        rideRequest.removeAt(0);
        notifyListeners();
      } else {
        // rideRequest.removeAt(index + 1);
        ride.removeAt(index);
        notifyListeners();
      }
      notifyListeners();
      showFlush(
        ctx,
        message: 'Booking request declined',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      notifyListeners();
    } else {
      showFlush(
        ctx,
        message: 'Unable to decline request',
        image: 'assets/Active.svg',
        color: errorColor,
      );
    }
  }

  void decline(String aid, String bid, BuildContext ctx, int index) async {
    var check = await booking.rejectRequest(aid, bid);
    if (check == true) {
      rideRequest.removeAt(index);
      notifyListeners();
      showFlush(
        ctx,
        message: 'Booking request declined',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      notifyListeners();
    } else {
      showFlush(
        ctx,
        message: 'Unable to decline request',
        image: 'assets/Active.svg',
        color: errorColor,
      );
    }
  }

  void createBooking(BuildContext ctx, String doctorId, String typeofService) async {
    buttonLoad = true;
    notifyListeners();
    var day = DateFormat('EEEE').format(embeddedCalendar);
    var id = '';

    for (var i in days) {
      if (i.day == day) {
        id = i.id!;
      }
    }
    if (buttonController.selectedIndexes.isEmpty) {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'You need to select a Time',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    } else {
      var startDate = DateTime(
          selectedDay!.year,
          selectedDay!.month,
          selectedDay!.day,
          int.parse(
            (disabled1[buttonController.selectedIndex!].split('')[1] == ':')
                ? disabled1[buttonController.selectedIndex!].split('')[0]
                : disabled1[buttonController.selectedIndex!].split('')[0] +
                    disabled1[buttonController.selectedIndex!].split('')[1],
          )).toUtc().toIso8601String();
      var endDate = DateTime(
              selectedDay!.year,
              selectedDay!.month,
              selectedDay!.day,
              int.parse(
                (disabled1[buttonController.selectedIndex!].split('')[1] == ':')
                    ? disabled1[buttonController.selectedIndex!].split('')[0]
                    : disabled1[buttonController.selectedIndex!].split('')[0] +
                        disabled1[buttonController.selectedIndex!].split('')[1],
              ),
              30)
          .toUtc()
          .toIso8601String();

      var check = await booking.createBooking(
        day,
        [
          {
            "startTime": startDate,
            "endTime": endDate,
          }
        ],
        doctorId,
        id,
        typeofService,
        'Meeting with a Patient',
        'Body Aanatomy',
      );
      if (check == true) {
        buttonLoad = false;
        showFlush(
          ctx,
          message: 'Booking created Successfully',
          image: 'assets/Active2.svg',
          color: greenColor,
        );
        String? uid = await store.getId();
        SocketService().socket.emit('notification-message', {
          "message": "You have a new booking request",
          "name": "$uid",
          "recipient": doctorId,
          "externalModelType": "Caregiver",
          "title": "Booking Activity"
        });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(ctx, Booking.routeName);
        });
        notifyListeners();
      } else {
        buttonLoad = false;
        showFlush(
          ctx,
          message: 'Subscription services has been exhausted',
          image: 'assets/Active.svg',
          color: errorColor,
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.push(ctx, CustomPageRoute(child: const CheckSubscription()));
        });
        notifyListeners();
      }
    }
    notifyListeners();
  }

  void rescheduleBooking(
      BuildContext ctx, String doctorId, String? caregiver, String bookingsId) async {
    buttonLoad = true;
    notifyListeners();
    var day = DateFormat('EEEE').format(embeddedCalendar);
    var id = '';

    for (var i in days) {
      if (i.day == day) {
        id = i.id!;
      }
    }
    if (buttonController.selectedIndexes.isEmpty) {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'You need to select a Time',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    } else {
      var startDate = DateTime(
          selectedDay!.year,
          selectedDay!.month,
          selectedDay!.day,
          int.parse(
            (disabled1[buttonController.selectedIndex!].split('')[1] == ':')
                ? disabled1[buttonController.selectedIndex!].split('')[0]
                : disabled1[buttonController.selectedIndex!].split('')[0] +
                    disabled1[buttonController.selectedIndex!].split('')[1],
          )).toUtc().toIso8601String();
      var endDate = DateTime(
              selectedDay!.year,
              selectedDay!.month,
              selectedDay!.day,
              int.parse(
                (disabled1[buttonController.selectedIndex!].split('')[1] == ':')
                    ? disabled1[buttonController.selectedIndex!].split('')[0]
                    : disabled1[buttonController.selectedIndex!].split('')[0] +
                        disabled1[buttonController.selectedIndex!].split('')[1],
              ),
              30)
          .toUtc()
          .toIso8601String();

      var check = await booking.rescheduleBooking(
          day,
          [
            {
              "startTime": startDate,
              "endTime": endDate,
            }
          ],
          doctorId,
          id,
          caregiver,
          bookingsId);
      if (check == true) {
        buttonLoad = false;
        showFlush(
          ctx,
          message: 'Booking reschedule completed',
          image: 'assets/Active2.svg',
          color: greenColor,
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(ctx, Booking.routeName);
        });
        notifyListeners();
      } else {
        buttonLoad = false;
        showFlush(
          ctx,
          message: 'Unable to reschedule booking',
          image: 'assets/Active.svg',
          color: errorColor,
        );
        notifyListeners();
      }
    }
    notifyListeners();
  }

  void cancelRequest(
    String id,
    BuildContext ctx,
    int index,
  ) async {
    var c = await booking.cancelBooking(id);
    if (index == 22234) {
      rideRequest.removeAt(0);
      notifyListeners();
    } else {
      // rideRequest.removeAt(index + 1);
      ride.removeAt(index);
      notifyListeners();
    }

    if (c == true) {
      Navigator.pop(ctx);
      notifyListeners();
    } else {
      showFlush(
        ctx,
        message: 'Unable to cancel booking',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      notifyListeners();
    }
  }

  void bookVaccine(BuildContext ctx) async {
    buttonLoad = true;
    notifyListeners();
    var check = await booking.vaccinationBooking(
        "623c4db3195c3dade8b1671d", address.text, city.text);
    if (check == true) {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Booking created Successfully',
        image: 'assets/Active2.svg',
        color: greenColor,
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(ctx, Booking.routeName);
      });
      notifyListeners();
    } else {
      buttonLoad = false;
      showFlush(
        ctx,
        message: 'Subscription services has been exhausted',
        image: 'assets/Active.svg',
        color: errorColor,
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(ctx, CustomPageRoute(child: const CheckSubscription()));
      });
      notifyListeners();
    }
    notifyListeners();
  }
}

class TimeModel {
  String day;
  bool available;
  int weekDay;
  List<Time>? time;
  List<int>? indexes;
  String? id;
  String? timeId;

  TimeModel({
    required this.day,
    required this.available,
    required this.weekDay,
    required this.time,
    this.indexes,
    this.id,
    this.timeId,
  });
}
