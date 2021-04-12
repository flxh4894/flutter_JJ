
import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:get/get.dart';

import 'chatting.dart';

class ChatList extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final double listHeight = 70;
  final double paddingHorizontal = 16;

  Widget _appbar() {
    return AppBar(
      title: Text('채팅'),
      elevation: 1,
    );
  }

  Widget _body() {
    List<Map<String, dynamic>> chatList = chatController.chatList;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: Obx(
        () => RefreshIndicator(
          onRefresh: _refreshChatList,
          child: ListView.separated(
            controller: chatController.scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: chatList.length + 1,
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

              final String rommName = index.isOdd ? 'appleRoom' : 'samsungRoom';
              return Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: GestureDetector(
                  onTap: (){
                    Get.to(() => ChattingRoom(), transition: Transition.rightToLeftWithFade, arguments: rommName);},
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(listHeight/2),
                        child: FadeInImage.assetNetwork(
                          image: chatList[index]['thumbnailUrl'],
                          placeholder: "assets/images/common/loading.gif",
                          width: listHeight,
                          height: listHeight,
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
                              Text('우주미남도원',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(chatList[index]['title'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          image: chatList[index]['thumbnailUrl'],
                          placeholder: "assets/images/common/loading.gif",
                          width: listHeight,
                          height: listHeight,
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
      ),
    );
  }

  Future<void> _refreshChatList() async {
    chatController.refreshChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }
}
