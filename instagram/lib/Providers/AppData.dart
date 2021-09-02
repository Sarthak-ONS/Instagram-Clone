import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

class AppData extends ChangeNotifier {
  bool? isDark;
  String? lang;

  String? deviceModel;

  String? currentLocation;
  late String? userSelectedCurrentLocation = "";

  static final _deviceInfoPlugin = DeviceInfoPlugin();

  Future<String?> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;
      deviceModel = '${info.product}';
      notifyListeners();
    } else {
      throw UnimplementedError();
    }
  }

  Future getCurrentLocation() async {
    try {
      Position positon = await Geolocator.getCurrentPosition();
      print(positon.latitude);
      print(positon.longitude);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(positon.latitude, positon.longitude);
      placemarks.forEach(
        (element) {
          print(element.name);
        },
      );
      notifyListeners();
    } on PlatformException catch (e) {
      print(e.code);
    }
  }

  void changeUserSelectedCurrentLocation(
      String mainText, String secondary) async {
    userSelectedCurrentLocation = "$mainText, $secondary";
    notifyListeners();
  }

  String getCurrentTime =
      "${DateFormat.yMMMMEEEEd().format(DateTime.now())}, ${DateFormat("H:m").format(DateTime.now())} ";
}
