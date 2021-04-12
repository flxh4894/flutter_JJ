import 'package:intl/intl.dart';

class DataUtils {
  static final convertPrice = new NumberFormat("#,###", 'ko_KR');
  static String calcNumFormat(String price) {
    return "${convertPrice.format(int.parse(price))}원";
  }
}