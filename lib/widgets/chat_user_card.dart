import 'package:chat_app/headers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.02,vertical:0.5 ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.5,
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          title: Text('Demo User',),
          subtitle:  Text('Last message from tkskvjs hjksjkbvjka sjbvcs nmnjnsajknm jkanjkfn sa,cmbjkb jkbajkhe user',maxLines: 1,),
          trailing: Text('12:05 pm',style: TextStyle(color: Colors.black54),),
        ),
      ),
    );
  }
}
