import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/item/itemChartController.dart';
import 'package:flutter_get/src/utils/dataUtils.dart';
import 'package:get/get.dart';

class ItemDayDealTable extends StatefulWidget {
  @override
  _ItemDayDealTableState createState() => _ItemDayDealTableState();
}

class _ItemDayDealTableState extends State<ItemDayDealTable> {

  final ItemChartController controller = Get.find<ItemChartController>();

  final List<Map> _products = List.generate(30, (i) {
    return {"id": i, "name": "Product $i", "price": Random().nextInt(200) + 1};
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          width: size.width * 0.9,
          child: Obx(
            () => DataTable(
              sortAscending: controller.isAscending.value,
              sortColumnIndex: controller.columnIndex.value,
              columns: [
                DataColumn(label: Text('순번'),
                  onSort: (columnIndex, _) {
                    controller.columnIndex(columnIndex);
                    if(controller.isAscending.value == true) {
                      controller.isAscending(false);
                      // 소트
                    } else {
                      controller.isAscending(true);
                      // 소트
                    }

                    // setState(() {
                    //   _columnIndex = columnIndex;
                    //   if (_isAscending == true) {
                    //     _isAscending = false;
                    //     _products.sort((productA, productB) =>
                    //         productB['id'].compareTo(productA['id']));
                    //   } else {
                    //     _isAscending = true;
                    //     _products.sort((productA, productB) =>
                    //         productA['id'].compareTo(productB['id']));
                    //   }
                    // });
                  }
                ),
                DataColumn(label: Text('판매가격'),
                  onSort: (columnIndex, _) {
                  }
                ),
                DataColumn(label: Text('거래시간')),
              ],
              rows: controller.dayDealData.map((DayDealData item) =>
                  DataRow(
                    cells: [
                      DataCell(Text(item.id.toString())),
                      DataCell(Text(DataUtils.calcNumFormat(item.price.toString()))),
                      DataCell(Text(item.date)),
                    ]
                  )
              ).toList()

            ),
          ),
        ),
      ),
    );
  }
}
