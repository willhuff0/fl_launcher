import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

String? homePath;

Future initPreferences() async {
  prefs = await SharedPreferences.getInstance();
  prefs.clear();
  //homePath = prefs.getString('home_path');
}
