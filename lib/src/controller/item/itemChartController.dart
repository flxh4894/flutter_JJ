
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:get/get.dart';

class ItemChartController extends GetxController {
  RxBool isAscending = true.obs; // 내림차순 오름차순
  RxInt columnIndex = 0.obs; // 정렬 컬럼
  RxList<SalesData> chartData = <SalesData>[].obs; // 차트 데이터시트\

  RxString selectDay = ''.obs;
  RxInt dayDealCount = 0.obs;
  RxList<DayDealData> dayDealData = <DayDealData>[].obs; // 해당 1일 거래 데이터
  RxInt chartMin = 0.obs;

  @override
  void onInit() {
    setChartData();
    setDayDealList(chartData.length-1);
    super.onInit();
  }

  void setChartData() {
    // 1. Http 통신으로 Firebase 에서 가져옴
    var day = 0401;
    List<SalesData> data = List.generate(30, (index) => SalesData('0${(day+index+1).toString()}', Random().nextInt(5000) + 10000));
    chartData(data);
    var tempMin = chartData.reduce((curr, next) => curr.sales < next.sales? curr: next).sales - 2000;
    chartMin(tempMin < 0 ? 0 : (tempMin/100).floor()*100);
  }

  // 하루 거래 내역
  void setDayDealList(int index) {
    // 1. Http 통신으로 가져옴
    List<DayDealData> data = List.generate(20, (index) => DayDealData( id: index+1, price: Random().nextInt(5000) + 10000, date: DateFormat('HH:mm').format(DateTime.now()) ));
    selectDay(chartData[index].day);
    dayDealCount(data.length);
    dayDealData(data);
  }

  // 하루 거래 내역 정렬
  void sortDayDealList(String key) {
      switch (key) {
        case 'id':
          dayDealData.sort((productA, productB) =>
              productB.id.compareTo(productA.id));
          break;
        case 'price':
          dayDealData.sort((productA, productB) =>
              productB.price.compareTo(productA.price));
          break;
      }
  }

}

class SalesData {
  SalesData(this.day, this.sales);
  final String day;
  final int sales;
}

class DayDealData {
  final int id;
  final int price;
  final String date;

  DayDealData({this.id, this.price, this.date});
}