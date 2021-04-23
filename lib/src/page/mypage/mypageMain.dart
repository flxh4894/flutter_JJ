import 'package:flutter/material.dart';
import 'package:flutter_get/src/components/propensityLevel.dart';
import 'package:flutter_get/src/controller/mypage/mypageController.dart';
import 'package:flutter_get/src/page/mypage/mypageDealList.dart';
import 'package:get/get.dart';

class MyPageMainPage extends StatelessWidget {

  final MyPageController controller = Get.put(MyPageController());

  Widget _countRow(String name, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        child: Column(
          children: [
            Text('0', style: TextStyle(fontSize: 20),),
            Text(name),
          ],
        ),
      ),
    );
  }

  Widget _iconRow(IconData icon, String name, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            IconButton(icon: Icon(icon, size: 30,), onPressed: (){},),
            Text(name),
          ],
        ),
      ),
    );
  }

  Widget _body(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Container(
            height: 80,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.network("https://pbs.twimg.com/media/ExUElF7VcAMx7jx.jpg" ,width: 70, height: 70, fit: BoxFit.cover)
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('우주미남도원', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      Text('서울시 북가좌동')
                    ],
                  )
                ),
                SizedBox(width: 16,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PropensityLevel(width: 100, height: 10,),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(child: Container(width: size.width, height: 30, child: Center(child: Text('마이프로필', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(5)
          ),), onTap: (){}),
          SizedBox(height: 15),
          // Container(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       _countRow('찜', null),
          //       _countRow('후기', null),
          //       _countRow('팔로잉', null),
          //       _countRow('팔로워', null),
          //     ],
          //   ),
          // ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _iconRow(Icons.shopping_bag_outlined, '거래내역', null),
                _iconRow(Icons.local_shipping_outlined, '배송현황', null),
                _iconRow(Icons.verified_outlined, '검수내역', null),
                _iconRow(Icons.favorite_border, '관심목록', null),
              ],
            ),
          ),
          SizedBox(height: 20),
          DefaultTabController(
              length: 3,
              initialIndex: controller.tabIndex.value,
              child: Expanded(
                child: Column(
                  children: [
                    PreferredSize(
                      preferredSize: Size.fromHeight(kTextTabBarHeight),
                      child: Container(
                        width: double.infinity,
                          child: TabBar(
                            unselectedLabelColor: Colors.black,
                            indicatorColor: Colors.black,
                            isScrollable: true,
                            indicatorWeight: 5,
                            labelPadding: EdgeInsets.symmetric(horizontal: 5),
                            onTap: (index) {controller.setTabInfo(index);},
                            tabs: [
                              Tab(text: '판매중',),
                              Tab(text: '예약중',),
                              Tab(text: '판매완료',),
                            ],
                          )
                      ),
                    ),
                    Expanded(
                        child: MyPageDealList()
                    )
                  ]
                ),
              ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        elevation: 1,
      ),
      body: _body(size),
    );
  }
}
