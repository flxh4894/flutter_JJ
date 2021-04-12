import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/homeController.dart';
import 'package:flutter_get/src/utils/dataUtils.dart';
import 'package:get/get.dart';
class PropensityLevel extends StatefulWidget {

  final double height;
  final double width;
  PropensityLevel({Key key, this.height, this.width}) : super(key: key);

  @override
  _PropensityLevelState createState() => _PropensityLevelState();
}

class _PropensityLevelState extends State<PropensityLevel> {
  final HomeController controller = Get.put(HomeController());

  final List<Color> lawfulColor = [
    Colors.red.withOpacity(1), // 1
    Colors.red.withOpacity(0.8), // 2
    Colors.red.withOpacity(0.6), // 3
    Colors.red.withOpacity(0.3), // 4
    Colors.black.withOpacity(0.5), // 5
    Colors.blue.withOpacity(0.4), // 6
    Colors.blue.withOpacity(0.6), // 7
    Colors.blue.withOpacity(0.8), // 8
    Colors.blue.withOpacity(1), // 9
  ];

  int level = 5;
  String lawfulText = '중립적인';

  String _calcPropensityLevel(int propensity) {

    if (propensity >= 0 && propensity < 500) {
      setState(() {
        level = 5;
      });
    } else if (propensity >= 500 && propensity < 7000) {
      setState(() {
        level = 6;
        lawfulText = '준법적인 1단계';
      });
    } else if (propensity >= 7000 && propensity < 15000) {
      setState(() {
        level = 7;
        lawfulText = '준법적인 2단계';
      });
    } else if (propensity >= 15000 && propensity < 25000) {
      setState(() {
        level = 8;
        lawfulText = '준법적인 3단계';
      });
    } else if (propensity >= 25000) {
      setState(() {
        level = 9;
        lawfulText = '준법적인 4단계';
      });
    } else if (propensity > -500 && propensity <= 0) {
      setState(() {
        level = 4;
        lawfulText = '무법적인 1단계';
      });
    } else if (propensity < -7000 && propensity >= -15000) {
      setState(() {
        level = 3;
        lawfulText = '무법적인 2단계';
      });
    } else if (propensity < -15000 && propensity >= -25000) {
      setState(() {
        level = 2;
        lawfulText = '무법적인 3단계';
      });
    } else if (propensity < -25000) {
      setState(() {
        level = 1;
        lawfulText = '무법적인 4단계';
      });
    }

    return propensity.toString();
  }

  @override
  Widget build(BuildContext context) {
    int propensity = controller.propensity.value;
    return Container(
      alignment: Alignment.centerRight,
      child: Column(children: <Widget>[
        Text(
          "${DataUtils.calcNumFormat(_calcPropensityLevel(propensity))}"
          ,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: lawfulColor[level - 1]),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: widget.height,
            width: widget.width,
            color: Colors.grey.withOpacity(0.5),
            child: Row(
              children: <Widget>[Container(
                height: widget.height,
                width: (propensity/32767 * 90),
                color: lawfulColor[level-1]
              ),
            ]),
          ),
        ),
        Text(lawfulText, style: TextStyle(color: lawfulColor[level-1], fontWeight: FontWeight.bold),),
      ]),
    );
  }
}
