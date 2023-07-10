import 'package:chat_app/headers.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/dialogs/profile_dialog.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_user.dart';
import '../models/message.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.02, vertical: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.5,
      child: InkWell(
          onTap: () {
            //navigate to the chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(user: widget.user),
                ));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) _message = list[0];

              return ListTile(
                //profile pic
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context, builder: (_) => ProfileDialog(user: widget.user));
                  },
                  child: ClipRRect(
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
                ),

                //user name
                title: Text(widget.user.name),

                //user last message
                subtitle: Text(
                    _message != null
                        ? _message!.type == 'image'
                            ? 'image'
                            : _message!.msg
                        : widget.user.about,
                    maxLines: 1),

                //message time
                trailing: _message == null
                    ? null // show nothing when no message is sent
                    : _message!.read.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        //show green symbol for unread message
                        ? Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        //message  sent time (when message is read)
                        : Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
