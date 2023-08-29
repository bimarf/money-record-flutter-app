import 'dart:convert';

import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';

import '../../../config/app_format.dart';
import '../../controller/history/c_detail_history.dart';

class DetailHistoryPage extends StatefulWidget {
  const DetailHistoryPage(
      {super.key,
      required this.idUser,
      required this.date,
      required this.type});
  final String idUser;
  final String date;
  final String type;

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final cDetailHistory = Get.put(CDetailHistory());

  @override
  void initState() {
    cDetailHistory.getData(widget.idUser, widget.date, widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(() {
          if (cDetailHistory.data.date == null) return DView.nothing();
          return Row(
            children: [
              Expanded(
                child: Text(
                  AppFormat.date(cDetailHistory.data.date!),
                ),
              ),
              cDetailHistory.data.type == 'Pemasukan'
                  ? const Icon(Icons.arrow_downward, color: Colors.green)
                  : const Icon(Icons.arrow_upward, color: Colors.red),
              DView.spaceWidth(),
            ],
          );
        }),
      ),
      body: GetBuilder<CDetailHistory>(builder: (_) {
        if (_.data.date == null) {
          String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
          if (widget.date == today && widget.type == 'Pengeluaran') {
            return DView.empty('Belum ada pengeluaran hari ini');
          }
          return DView.nothing();
        }
        ;
        List details = jsonDecode(_.data.details!);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Total',
                style: TextStyle(
                    color: AppColor.primary.withOpacity(0.7),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Text(AppFormat.currency(_.data.total!),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColor.primary, fontWeight: FontWeight.bold)),
            ),
            DView.spaceHeight(8),
            Center(
              child: Container(
                height: 5,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColor.chart.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            DView.spaceHeight(20),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                itemCount: details.length,
                itemBuilder: (context, index) {
                  Map item = details[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(fontSize: 20),
                        ),
                        DView.spaceWidth(8),
                        Expanded(
                          child: Text(
                            item['name'],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Text(item['price'],
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
