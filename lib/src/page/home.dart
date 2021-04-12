import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/homeController.dart';
import 'package:flutter_get/src/page/itemDetail.dart';
import 'package:flutter_get/src/utils/dataUtils.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  Widget _appbar() {
    return AppBar(
      title: GestureDetector(
        child: PopupMenuButton<String>(
            shape: ShapeBorder.lerp(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                1),
            onSelected: (String where){controller.setLocation(where); print(controller.location);},
            itemBuilder: (BuildContext context) {
              List<PopupMenuItem<String>> list = [];
              controller.locationList.forEach((key, value) { list.add(PopupMenuItem(child: Text(value), value: value)); });
              return list;
            },
            child: Row(children: [
              Text('${controller.location}'),
              Icon(Icons.arrow_drop_down)
            ]
            ),
          ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.tune), onPressed: () {}),
        IconButton(icon: SvgPicture.asset("assets/svg/bell.svg", width: 22,),
            onPressed: () {}),
      ],
      elevation: 1,
    );
  }

  Future fetchData () async{
    controller.setListCount();
  }

  Future<void> refreshData() async {
    controller.refreshData();
  }

  Widget _body() {
    return RefreshIndicator(
      color: Styles.primaryColor,
      onRefresh: refreshData,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: controller.datas.length+1,
          itemBuilder: (BuildContext _context, index) {
            if (index == controller.datas.length) {
              if(index >= 10) {
                return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    )
                );
              } else {
                return Container();
              }
            }

            return GestureDetector(
              onTap: () => {
                Get.to(() => ItemDetailView(),
                    arguments: controller.datas[index]
                    )
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GetBuilder<HomeController>(
                      builder: (_) =>
                          Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Hero(tag: controller.datas[index]['cid'],
                                  child: Image.asset(controller.datas[index]['image'], width: 100, height: 100,))
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.datas[index]['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        controller.datas[index]['location'],
                                        style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.4)),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        DataUtils.calcNumFormat(controller.datas[index]['price']),
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 5),
                                      Expanded(
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              SvgPicture.asset("assets/svg/heart_off.svg", width: 13, height: 13,),
                                              SizedBox(width: 5,),
                                              Text(
                                                controller.datas[index]['likes'],
                                              ),
                                            ]
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                  )
              ),
            );
          },
          // separatorBuilder: (BuildContext _context, index) {
          //   return Container(height: 1, color: Colors.black.withOpacity(0.3));
          // },
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: _appbar(),
        body: _body(),
      ),
    );
  }
}


