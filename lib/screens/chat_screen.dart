import 'package:chat_app/headers.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      child: Row(
        children: [
          //back button
          IconButton(
            onPressed: () {
              //remove the chat screen
              Navigator.pop(context);
            },
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
