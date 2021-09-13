import 'package:shared_preferences/shared_preferences.dart';

class SharedModel {
  Future<List<String?>> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String?> data = prefs.getStringList('myData') ?? [];
    return data;
  }

  Future<void> saveData(List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('myData', value);
  }

  Future<int> getUniqueId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uniqueNum;
    uniqueNum = (prefs.getInt('uniqueNum') ?? 0) + 1;
    prefs.setInt('uniqueNum', uniqueNum);
    return uniqueNum;
  }
}
