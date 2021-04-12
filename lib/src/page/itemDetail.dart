import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/itemController.dart';
import 'package:flutter_get/src/page/components/propensityLevel.dart';
import 'package:flutter_get/src/utils/dataUtils.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'components/itemDetailInfo.dart';
import 'components/otherSellItems.dart';

class ItemDetailView extends StatefulWidget {
  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> with SingleTickerProviderStateMixin {
  final ItemController itemController = Get.put(ItemController());
  final Map<String, String> _dataInfo = Get.arguments;
  final ScrollController _scrollController = ScrollController();

  Size size;
  List<Map<String, String>> imgList = [];
  double _scrollHeightAlpha = 0;
  AnimationController _animationController;
  Animation _colorTween;
  bool _isWatchlist = false;

  @override
  void dispose() {
    itemController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    for (int i = 0; i < 5; i++) {
      imgList.add({"id": i.toString(), "url": Get.arguments['image']});
    }
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black).animate(_animationController);
    _scrollController.addListener(() {
      setState(() {
        _scrollHeightAlpha = _scrollController.offset > 255 ? 255 : _scrollController.offset;
        _animationController.value = _scrollHeightAlpha / 255;
      });
    });
    getWatchlistState();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  Future getWatchlistState() async {
    bool test = await itemController.getWatchlist(_dataInfo['cid']);
    setState(() {
      _isWatchlist = test;
    });
  }

  Future<void> _toggleWatchlist(bool status) async {
    String cid = _dataInfo['cid'];
    if(status) {
      itemController.removeWatchlist(cid);
      setState(() {
        _isWatchlist = false;
      });
    } else {
      itemController.addWatchlist(cid);
      setState(() {
        _isWatchlist = true;
      });
    }
  }

  Future<Map<String, String>> getItemData() async {
    await new Future.delayed(const Duration(milliseconds: 200));
    return {'name': '우주미남도짱', 'location': '서울시 북가좌동'};
  }

  Widget _gradientIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Icon(icon ,color: _colorTween.value,)
    );
  }

  Widget _appbar() {
    return AppBar(
      title: AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Text(
          '상세페이지',
          style: TextStyle(color: _colorTween.value),
        ),
      ),
      leading: IconButton(
        icon: _gradientIcon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      backgroundColor: Colors.white.withAlpha(_scrollHeightAlpha.toInt()),
      elevation: 0,
      actions: [
        IconButton(
            icon: _gradientIcon(Icons.share_outlined),
            onPressed: () {}),
        IconButton(
            icon: _gradientIcon(Icons.more_vert),
            onPressed: () {}),
      ],
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(children: <Widget>[
        _imageWithIndicator(),
        FutureBuilder(
            future: getItemData(),
            builder: (context, snapshot) {
              // 데이터 안불러온 경우 인디케이터 표시
              if (snapshot.hasData == false) {
                return CircularProgressIndicator();
              }
              // 하단 Column 부분
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(children: <Widget>[
                  _sellerSimpleInfo(
                      snapshot.data['name'], snapshot.data['location']),
                  _divider(),
                  ItemDetailInfo(data: _dataInfo),
                  _divider(),
                  OtherSellItems(),
                ]),
              );
            }),
      ]),
    );
  }

  Widget _divider() {
    return Container(
      child: Divider(),
    );
  }

  Widget _imageWithIndicator() {
    int _current = itemController.slideIndex.value;
    return Stack(
      children: [
        Hero(
          tag: Get.arguments['cid'],
          child: CarouselSlider(
            items: imgList.map((element) {
              return Image.asset(element['url'],
                  width: size.width, fit: BoxFit.fill);
            }).toList(),
            options: CarouselOptions(
                height: size.width,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  itemController.setSlideIndex(index);
                  // setState(() {
                  //   _current = index;
                  // });
                }),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((element) {
              int index = imgList.indexOf(element);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _sellerSimpleInfo(name, location) {
    return Container(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 50,
              height: 50,
              child: Image.asset("assets/images/user.png"),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(location),
            ],
          ),
          Expanded(child: PropensityLevel(width: 90, height: 6,))
        ],
      ),
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      width: size.width,
      child: Row(
        children: [
          IconButton(
              icon: SizedBox(
                height: 25,
                width: 25,
                child: SvgPicture.asset(
                  _isWatchlist ?
                  "assets/svg/heart_on.svg" :
                  "assets/svg/heart_off.svg",
                  color: Color(0xfff08f4f),
                ),
              ),
              onPressed: () {
                _toggleWatchlist(_isWatchlist);
                final snackBarText = _isWatchlist ? '관심목록에 추가 되었습니다.' : '관심목록이 해제 되었습니다.';
                final snackBar = SnackBar(content: Text(snackBarText), duration: Duration(milliseconds: 500),);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }),
          VerticalDivider(
            color: Colors.black.withOpacity(0.5),
          ),
          Column(
            children: [
              Text(
                DataUtils.calcNumFormat(_dataInfo['price']),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '가격제안불가',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                    color: Styles.primaryColor,
                    child: Text('채팅으로 거래하기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ),
              ])
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appbar(),
        body: _body(),
        bottomNavigationBar: _bottomBarWidget()),
    );
  }
}
