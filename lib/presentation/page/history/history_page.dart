import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:money_record/presentation/page/history/update_history_page.dart';

import '../../controller/history/c_history.dart';
import '../../controller/history/c_income_outcome.dart';
import 'detail_history_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final cHistory = Get.put(CHistory());
  final cUser = Get.put(CUser());
  final controllerSearch = TextEditingController();

  refresh() {
    cHistory.getList(cUser.data.idUser!);
  }

  delete(String idHistory) async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Hapus', 'Yakin untuk menghapus data ini?',
        textNo: 'Batal', textYes: 'Hapus');

    if (yes == true) {
      bool success = await SourceHistory.delete(idHistory!);
      if (success) {
        refresh();
      }
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const Text('Riwayat'),
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(16),
                child: TextField(
                  controller: controllerSearch,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023, 01, 01),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (date != null) {
                      controllerSearch.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColor.chart.withOpacity(0.5),
                    suffixIcon: IconButton(
                      onPressed: () {
                        cHistory.search(
                            cUser.data.idUser!, controllerSearch.text);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    hintText: '2023-08-09',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<CHistory>(builder: (_) {
        if (_.loading) return DView.loadingCircle();
        if (_.list.isEmpty) return DView.empty('Tidak ada data');
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
            itemCount: _.list.length,
            itemBuilder: (context, index) {
              History history = _.list[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                    index == _.list.length - 1 ? 20 : 16),
                child: InkWell(
                  onTap: () {
                    Get.to(() => DetailHistoryPage(
                          idUser: cUser.data.idUser!,
                          date: history.date!,
                          type: history.type!,
                        ));
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      DView.spaceWidth(),
                      history.type == 'Pemasukan'
                          ? const Icon(
                              Icons.arrow_downward,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.arrow_upward,
                              color: Colors.red,
                            ),
                      DView.spaceWidth(),
                      Text(
                        AppFormat.date(history.date!),
                        style: const TextStyle(
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          AppFormat.currency(history.total!),
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      IconButton(
                          onPressed: () => delete(history.idHistory!),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
