import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_get/src/components/itemDayDeal.dart';
import 'package:flutter_get/src/controller/item/itemChartController.dart';
import 'package:flutter_get/src/controller/itemController.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ItemPriceChart extends StatelessWidget {
  final ItemChartController controller = Get.put(ItemChartController());
  final ItemController itemController = Get.find<ItemController>();

  Widget _body(){
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(itemController.itemNm.value, style: TextStyle(fontSize: 16)),
          chart(),
          Obx(() => Text('2021.${controller.selectDay.value} (${controller.dayDealCount.value} 건)')),
          ItemDayDealTable()
        ],
      ),
    );
  }

  Widget chart() {
    return Container(
        height: 300,
        child:SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '평균가격',
                format: 'point.y 원'
            ),
            trackballBehavior: TrackballBehavior(
                enable: true,
                lineDashArray: <double>[5,5],
                markerSettings: TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible),
                lineType: TrackballLineType.horizontal,
                tooltipSettings: InteractiveTooltip(
                    format: 'point.x : point.y원'
                )
            ),
            enableAxisAnimation: true,
            zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                zoomMode: ZoomMode.x
            ),
            primaryXAxis: CategoryAxis(
                visibleMinimum: controller.chartData.length.toDouble() - 7,
                maximumLabels: controller.chartData.length
            ),
            primaryYAxis: NumericAxis(
              minimum: controller.chartMin.toDouble(),
              numberFormat: NumberFormat.currency(
                decimalDigits: 0,
                symbol: "")
            ),
            onPointTapped: (PointTapArgs args){
              controller.setDayDealList(args.pointIndex);
              print(args.pointIndex);
            },
            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                  dataSource: controller.chartData,
                  xValueMapper: (SalesData sales, _) => sales.day,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  markerSettings: MarkerSettings(isVisible: true),
                  color: Colors.red
              ),

              // LineSeries<SalesData, String>(
              //     dataSource:  <SalesData>[
              //     ],
              //     xValueMapper: (SalesData sales, _) => sales.year,
              //     yValueMapper: (SalesData sales, _) => sales.sales,
              //     emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.average, borderWidth: 2, borderColor: Colors.red),
              //     color: Colors.blue,
              //     dashArray: <double>[10, 5],
              // )

            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('현재 시세'),
      ),
      body: _body()
    );
  }
}