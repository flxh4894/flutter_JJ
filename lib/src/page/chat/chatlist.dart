
import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:get/get.dart';
import 'chatting.dart';

class ChatList extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final double listHeight = 50;
  final double paddingHorizontal = 16;

  Widget _appbar() {
    return AppBar(
      title: Text(chatController.userId),
      elevation: 1,
    );
  }

  Widget _body() {
    List<Chatting> chatList = chatController.chatList;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: Obx(
        () => ListView.separated(
          controller: chatController.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: chatList.length,
          itemBuilder: (context, index) {

            if (index == chatList.length) {
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

            return Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: GestureDetector(
                onTap: (){
                  chatController.setUnreadZero(index);
                  Get.to(() => ChattingRoom(), transition: Transition.rightToLeftWithFade, arguments: chatList[index].roomId.toString());},
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(listHeight/2),
                      child: FadeInImage.assetNetwork(
                        image: "https://i.pinimg.com/originals/6c/15/b0/6c15b0166c044974d4e4e9234f881f92.jpg",
                        placeholder: "assets/images/common/loading.gif",
                        width: listHeight,
                        height: listHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Container(
                        height: listHeight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(chatList[index].nickname,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(chatList[index].lastMsg,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            ),
                          ]
                        ),
                      ),
                    ),
                    Text(chatList[index].unreadCount == 0 ? '' : chatList[index].unreadCount.toString(), style: TextStyle(color: Colors.red),),
                    SizedBox(width: 10,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        image: "https://i.pinimg.com/originals/6c/15/b0/6c15b0166c044974d4e4e9234f881f92.jpg",
                        placeholder: "assets/images/common/loading.gif",
                        width: listHeight,
                        height: listHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext _context, index) {
            return Container(height: 1, color: Colors.grey.withOpacity(0.3));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
      // body: Container(
      //   child: Text(chatController.chatList[0].roomId),
      // )
    );
  }
}
