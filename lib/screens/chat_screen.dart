import 'dart:convert';

import 'package:chat_app/headers.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';

import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all the messages
  List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //app bar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        backgroundColor: Colors.white.withOpacity(.8),

        //body(messages)
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    // if data is loading
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());

                    // if some or all data is loaded then show this
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      print('Data: ${jsonEncode(data![0].data())}');
                      _list.clear();
                      _list.add(Message(
                          toId: 'xyz',
                          msg: 'hii',
                          read: '',
                          type: 'text',
                          sent: '12:00 AM',
                          fromId: APIs.user.uid));
                      _list.add(Message(
                          toId: APIs.user.uid,
                          msg: 'Hello',
                          read: '',
                          type: 'text',
                          sent: '12:00 AM',
                          fromId: 'xyz'));

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _list.length,
                          //for little spacing at start of the screen
                          padding: EdgeInsets.only(top: mq.height * 0.005),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(message: _list[index]);
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'Say Hi to ${widget.user.name}👋! ',
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            __chatInput(),
          ],
        ),

        // input
      ),
    );
  }

  Widget __chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * .02, vertical: mq.height * .01),
      child: Row(
        children: [
          //input field and buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent)),

                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type Something....',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      border: InputBorder.none,
                    ),
                  )),

                  //gallery button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.image, color: Colors.blueAccent)),

                  //camera button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent)),
                  const SizedBox(width: 2),
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            onPressed: () {},
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      child: Row(
        children: [
          //back button to remove chat screen
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
          ),

          //user profile pic
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.3),
            child: CachedNetworkImage(
              height: mq.height * 0.06,
              width: mq.height * 0.06,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => const Icon(Icons.error),
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          const SizedBox(width: 10),

          //user name & last seen time
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //user name
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              //last seen time
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
