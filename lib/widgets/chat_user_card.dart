import 'package:chat_app/headers.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.02, vertical: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.5,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          //profile pic
          leading: const CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),

          //user name
          title: Text(widget.user.name),

          //user last message
          subtitle: Text(widget.user.about, maxLines: 1),

          //message time
          trailing: const Text(
            '12:05 pm',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
