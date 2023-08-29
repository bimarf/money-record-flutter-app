import 'package:get/get.dart';
import 'package:money_record/data/model/user.dart';

class CUser extends GetxController {
  final _data = User().obs;

  get data => _data.value;
  setData(newData) => _data.value = newData;
}