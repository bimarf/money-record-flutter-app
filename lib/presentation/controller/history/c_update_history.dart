import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/data/model/history.dart';

import '../../../data/source/source_history.dart';

class CUpdateHistory extends GetxController {
  final _date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  String get date => _date.value;
  setDate(newDate) => _date.value = newDate;

  final _type = 'Pemasukan'.obs;
  String get type => _type.value;
  setType(newType) => _type.value = newType;

  final _items = [].obs;
  List get items => _items.value;
  addItem(newItem) {
    _items.value.add(newItem);
    count();
  }

  deleteItem(index) {
    _items.value.removeAt(index);
    count();
  }

  final _total = 0.0.obs;
  double get total => _total.value;

  count() {
    _total.value = items.map((e) => e['price']).toList().fold(0.0,
        (previousValue, element) {
      return double.parse(previousValue.toString()) + double.parse(element);
    });
    update();
  }

  init(idUser, date) async {
    History? history = await SourceHistory.whereDate(idUser, date);
    if (history != null) {
      setDate(history.date);
      setType(history.type);
      _items.value = jsonDecode(history.details!);
      count();
    }
  }
}
