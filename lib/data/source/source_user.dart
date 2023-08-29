import 'package:d_info/d_info.dart';
import 'package:money_record/config/api.dart';
import 'package:money_record/config/app_request.dart';

import '../../config/session.dart';
import '../model/user.dart';

class SourceUser {
  static Future<bool> login(String email, String password) async {
    String url = '${Api.user}/login.php';
    Map? responseBody = await AppRequest.post(url, {
      'email': email,
      'password': password,
    });

    if (responseBody == null) {
      return false;
    }

    if (responseBody['status']) {
      var mapUser = responseBody['data'];
      Session.saveUser(User.fromJson(mapUser));
    }

    return responseBody['status'];
  }

  static Future<bool> register(String name, email, String password) async {
    String url = '${Api.user}/register.php';
    Map? responseBody = await AppRequest.post(url, {
      'name': name,
      'email': email,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (responseBody == null) {
      return false;
    }

    if (responseBody['status']) {
      return responseBody['status'];
    } else {
      if(responseBody['message'] == 'Email sudah terdaftar') {
        DInfo.dialogError('${responseBody['message']}');
      } else {
        DInfo.dialogError('${responseBody['message']}');
      }
      DInfo.closeDialog();
    }

    return responseBody['status'];
  }
}
