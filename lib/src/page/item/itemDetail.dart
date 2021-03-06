import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/src/components/itemDetailInfo.dart';
import 'package:flutter_get/src/components/otherSellItems.dart';
import 'package:flutter_get/src/components/propensityLevel.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:flutter_get/src/controller/itemController.dart';

import 'package:flutter_get/src/utils/dataUtils.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class ItemDetailView extends StatefulWidget {
  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> with SingleTickerProviderStateMixin {
  final ItemController itemController = Get.put(ItemController(itemDocId: Get.arguments['cid'], seller: Get.arguments['sellUser'], itemId: Get.arguments['itemInfo']));
  final ChatController chatController = ChatController();
  final Map<String, dynamic> _dataInfo = Get.arguments;
  final ScrollController _scrollController = ScrollController();

  Size size;
  List<Map<String, String>> imgList = [];
  double _scrollHeightAlpha = 0;
  AnimationController _animationController;
  Animation _colorTween;

  @override
  void dispose() {
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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }


  Future<void> _toggleWatchlist(bool status) async {
    if(status) {
      itemController.setWatchlistNew(false);
    } else {
      itemController.setWatchlistNew(true);
    }
  }

  Future<Map<String, String>> getItemData() async {
    await new Future.delayed(const Duration(milliseconds: 200));
    return {'name': '??????????????????', 'location': '????????? ????????????'};
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
          '???????????????',
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
              // ????????? ???????????? ?????? ??????????????? ??????
              if (snapshot.hasData == false) {
                return CircularProgressIndicator();
              }
              // ?????? Column ??????
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
          tag: _dataInfo['cid'],
          child: CarouselSlider(
            items: imgList.map((element) {
              return Image.network(element['url'],
                  width: size.width, fit: BoxFit.cover);
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

  Widget _bottomBarWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      width: size.width,
      child: Row(
        children: [
          Obx(
            () => IconButton(
                icon: SizedBox(
                  height: 25,
                  width: 25,
                  child: SvgPicture.asset(
                    itemController.isWatchlist.value ?
                    "assets/svg/heart_on.svg" :
                    "assets/svg/heart_off.svg",
                    color: Color(0xfff08f4f),
                  ),
                ),
                onPressed: () {
                  _toggleWatchlist(itemController.isWatchlist.value);
                  final snackBarText = itemController.isWatchlist.value ? '??????????????? ?????? ???????????????.' : '??????????????? ?????? ???????????????.';
                  final snackBar = SnackBar(content: Text(snackBarText), duration: Duration(milliseconds: 500),);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }),
          ),
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
                '??????????????????',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Expanded(
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    itemController.isMe.value == true ?
                    Container(
                      child: Text('?????????????????????'),
                    )
                    :
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: GestureDetector(
                        onTap: () {
                          chatController.createChatRoom(_dataInfo['sellUser'], _dataInfo['cid']);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                          color: Styles.primaryColor,
                          child: Text('???????????? ????????????', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ]
                ),
              )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appbar(),
        body: Obx (() => _body()),
        bottomNavigationBar: _bottomBarWidget()
    );
  }
}
