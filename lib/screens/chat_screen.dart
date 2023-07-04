import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_user.dart';
import '../headers.dart';
import '../widgets/message_card.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all the messages
  // ignore: prefer_final_fields
  List<Message> _list = [];

  // frohandling text field
  final _textController = TextEditingController();

  //show and hiding emoji
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // to hide the keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          // if emojis are shown & back buton is pressed then close search
          // or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              _showEmoji = !_showEmoji;
              setState(() {});
              return Future.value(false);
            } else {
              // to pop the screen
              return Future.value(true);
            }
          },
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
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // if data is loading
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(child: SizedBox());

                        // if some or all data is loaded then show this
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

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
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController:
                          _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]\

                      config: Config(
                        bgColor: Colors.white.withOpacity(.8),
                        columns: 8,
                        // initCategory: Category.SMILEYS,
                        emojiSizeMax: 32 *
                            (Platform.isIOS
                                ? 1.30
                                : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
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
                      onPressed: () {
                        FocusScope.of(context)
                            .unfocus(); //hide the normal keyboard if open

                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent)),

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    onTap: () {
                      // to hide emoji keyboard if normal keyboard is opened
                      setState(() => _showEmoji = false);
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
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
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);

                //clear the message field
                _textController.text = '';
              }
            },
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
