
import 'package:flutter/material.dart';
import 'package:flutter_get/src/components/chat/chatBubble.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:flutter_get/src/controller/chattingController.dart';

import 'package:flutter_get/src/repository/chatRepository.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:get/get.dart';

class ChattingRoom extends StatefulWidget {
  @override
  _ChattingRoomState createState() => _ChattingRoomState();
}

class _ChattingRoomState extends State<ChattingRoom> {

  final ChatController chatController = Get.find<ChatController>();
  final ChattingController chattingController = Get.put(ChattingController(roomId: Get.arguments));
  final ScrollController listScrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final String roomName = Get.arguments as String;
  final ChatRepository chatRepository = ChatRepository();


  @override
  void initState() {
    listScrollController.addListener(() async {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        await new Future.delayed(const Duration(milliseconds: 500));
        print('새로고침중');
        chatController.readMoreChatHistory(roomName);
      }
    });
    super.initState();
  }

  Widget _appbar() {
    return AppBar(
      title: Container(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset("assets/images/ara-1.jpg",width: 40, height: 40,)
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(chatController.userId, style: TextStyle(fontSize: 16),),
                  Text('Online',  style: TextStyle(fontSize: 14),)
                ],
              )
            ],
          )
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        _buildItemInfo(),
        _buildMessage(),
      ],
    );
  }

  Widget _buildItemInfo() {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage.assetNetwork(placeholder: "assets/images/common/loading.gif", image: "https://i.pinimg.com/originals/6c/15/b0/6c15b0166c044974d4e4e9234f881f92.jpg" ,width: 60, height: 60, fit: BoxFit.cover,)
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AMD Ryzen 5600X',
                style: TextStyle(fontSize: 16),
              ),
              Text('560,000원 ${chattingController.myChatData.length.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(onPressed: (){}, child: Text('현재시세'), style: ElevatedButton.styleFrom(elevation: 5, primary: Styles.primaryColor), )
              )
          )
        ],
      ),
    );
  }

  Widget _buildMessage() {
    final String user = chatController.userId;
    final List myChat = chattingController.myChatData;

    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        controller: listScrollController,
        reverse: true,
        shrinkWrap: true,
        itemCount: myChat == null ? 0 : myChat.length,
        itemBuilder: (context, index) {
          // if (index == chatData.length - 1) {
          //     return Center(
          //         child: Padding(
          //           padding: const EdgeInsets.all(8),
          //           child: CircularProgressIndicator(),
          //         )
          //     );
          // }

          return myChat[myChat.length-index-1]['sendUser'] == user ?  ChatBubble(sendUser: SendUser.ME, text: myChat[myChat.length-index-1]['text'], read: myChat[myChat.length-index-1]['read'])
              :  youBubble(myChat, index);
        }
      )
    );
  }

  Widget youBubble (myChat, index) {
    return ChatBubble(sendUser: SendUser.YOU, text: myChat[myChat.length-index-1]['text'], userId: myChat[myChat.length-index-1]['sendUser'], read: myChat[myChat.length-index-1]['read'],);
  }

  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(
                  hintText: '메세지를 입력해 주세요.',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10)
              ),
            ),
          ),
          IconButton(icon: Icon(Icons.send, color: Colors.blue,), onPressed: () {
            if(textController.text != '') {
              var data = {
                'roomId': Get.arguments.toString(),
                'text': textController.text,
                'date': DateTime.now().toString()
              };
              chatController.onEmitMessage(roomName, data);

              listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
              textController.clear();
            }
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus)
          currentFocus.unfocus();
      },
      child: Scaffold(
        appBar: _appbar(),
        body: Obx(
          () =>  _body(context),
        ),
        bottomNavigationBar: _buildInput(),
      ),
    );
  }
}
