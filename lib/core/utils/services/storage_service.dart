import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxController {
  final _box = GetStorage();
  bool? _isLoggedIn = false;
  bool? _hasSeenOnboarding = false;
  String? _currentUserString;
  String? _token = "";
  bool? _hasCompletedRegistration = false;

   String? _startupName;
  String? _startupShortStory;
  String? _description;
  String? _startupEmail;
  String? _nin;
  String? _tinNumber;
  String? _sectorId;

  StorageService() {
    // Initialize values from storage or default values
    token = _box.read('token') ?? "";
    currentUserString = _box.read('user') ?? "";
    isLoggedIn = _box.read('isLoggedIn') ?? false;
    _hasSeenOnboarding = _box.read('hasSeenOnboarding') ?? false;
    _hasCompletedRegistration = _box.read('hasCompletedRegistration')??false;


    _startupName = _box.read('startupName');
    _startupShortStory = _box.read('startupShortStory');
    _description = _box.read('description');
    _startupEmail = _box.read('startupEmail');
    _nin = _box.read('nin');
    _tinNumber = _box.read('tinNumber');
    _sectorId = _box.read('sectorId');
  }

  String? get token => _token;
  set token(String? value) {
    _token = value;
    _box.write('token', value);
    update();
  }

  String? get currentUserString => _currentUserString;
  set currentUserString(String? value) {
    _currentUserString = value;
    _box.write('user', value);
    if (value != null) {
      // currentUser = userFromJson(value);
    }
    update();
  }

 

  bool? get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool? value) {
    _isLoggedIn = value;
    _box.write('isLoggedIn', value);
    update();
  }

  bool? get hasSeenOnboarding => _hasSeenOnboarding;
  set hasSeenOnboarding(bool? value) {
    _hasSeenOnboarding = value;
    _box.write('hasSeenOnboarding', value);
    update();
  }
bool? get hasCompletedRegistration => _hasCompletedRegistration;
  set hasCompletedRegistration(bool? value) {
    _hasCompletedRegistration = value;
    _box.write('hasCompletedRegistration', value);
    update();
  }

  String? get startupName => _startupName;
  set startupName(String? value) {
    _startupName = value;
    _box.write('startupName', value);
    update();
  }

  String? get startupShortStory => _startupShortStory;
  set startupShortStory(String? value) {
    _startupShortStory = value;
    _box.write('startupShortStory', value);
    update();
  }

  String? get description => _description;
  set description(String? value) {
    _description = value;
    _box.write('description', value);
    update();
  }

  String? get startupEmail => _startupEmail;
  set startupEmail(String? value) {
    _startupEmail = value;
    _box.write('startupEmail', value);
    update();
  }

  String? get nin => _nin;
  set nin(String? value) {
    _nin = value;
    _box.write('nin', value);
    update();
  }

  String? get tinNumber => _tinNumber;
  set tinNumber(String? value) {
    _tinNumber = value;
    _box.write('tinNumber', value);
    update();
  }

  String? get sectorId => _sectorId;
  set sectorId(String? value) {
    _sectorId = value;
    _box.write('sectorId', value);
    update();
  }






  // Save data to storage
  Future<void> saveData({required String key, required dynamic value}) async {
    await _box.write(key, value);
  }


 Future<void> saveStartupData(Map<String, dynamic> data) async {
    startupName = data['startup_name'];
    startupShortStory = data['startup_short_story'];
    description = data['description'];
    startupEmail = data['startup_email'];
    nin = data['nin'];
    tinNumber = data['individual_tin_no'];
    sectorId = data['sector_id'];
  }



  // Read data from storage
  dynamic readData({required String key}) {
    return _box.read(key);
  }

  // Remove data from storage
  Future<void> removeData({required String key}) async {
    await _box.remove(key);
  }

  // Clear all data from storage
  Future<void> clearStorage() async {
    await _box.erase();
  }

  // Safari Hunt Logout
  Future<void> logout() async {
    await removeData(key: "isLoggedIn");
    await removeData(key: "user");
    await removeData(key: "token");
  }
}