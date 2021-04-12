import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:flutter_get/src/page/components/chat/chatBubble.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:get/get.dart';

class ChattingRoom extends StatefulWidget {
  @override
  _ChattingRoomState createState() => _ChattingRoomState();
}

class _ChattingRoomState extends State<ChattingRoom> {
  final ChatController chatController = ChatController();
  final ScrollController listScrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final String roomName = Get.arguments as String;

  @override
  void initState() {
    listScrollController.addListener(() async {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        await new Future.delayed(const Duration(milliseconds: 500));
        print('새로고침중');
        chatController.readMoreChatHistory();
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
                  Text('우주미남도원', style: TextStyle(fontSize: 16),),
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
              Text('560,000원',
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

    final String user = 'supersexy';
    final List<Map<String, dynamic>> chatData = chatController.tes[roomName]['list'];
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        controller: listScrollController,
        reverse: true,
        shrinkWrap: true,
        itemCount: chatData == null ? 0 : chatData.length,
        itemBuilder: (context, index) {
          // if (index == chatData.length - 1) {
          //     return Center(
          //         child: Padding(
          //           padding: const EdgeInsets.all(8),
          //           child: CircularProgressIndicator(),
          //         )
          //     );
          // }
          return chatData[chatData.length-index-1]['sendUser'] == user ?  ChatBubble(sendUser: SendUser.ME, text: chatData[chatData.length-index-1]['text'],)
              :  ChatBubble(sendUser: SendUser.YOU, text: chatData[chatData.length-index-1]['text'], userId: chatData[chatData.length-index-1]['sendUser'],);
        }
      )
    );
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
              // 나중에 서버로 전송 username 은 토큰에서 내가 보낼껀 데이터만 보내면 됨
              String name = chatController.tes[roomName]['list'].length % 2 == 0 ? 'dowon' : 'supersexy';
              chatController.newAddChatting(roomName, {
                'chatid': 124,
                'sendUser': name,
                'text': textController.text,
                'date': '2021-04-11 23:20'
              });
              // chatController.addChatting({
              //   'chatid': 124,
              //   'sendUser': name,
              //   'text': textController.text,
              //   'date': '2021-04-11 23:20'
              // });
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
