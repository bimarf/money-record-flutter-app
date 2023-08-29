import 'package:get/get.dart';
import 'package:money_record/data/model/history.dart';

import '../../../data/source/source_history.dart';

class CIncomeOutcome extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _list = <History>[].obs;
  List<History> get list => _list.value;

  getList(idUser, type) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.incomeOutcome(idUser, type);
    update();

    Future.delayed(const Duration(milliseconds: 900), () {
      _loading.value = false;
      update();
    });
  }

  search(idUser, type, date) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.searchIncomeOutcome(idUser, type, date);
    update();

    Future.delayed(const Duration(milliseconds: 900), () {
      _loading.value = false;
      update();
    });
  }
}
