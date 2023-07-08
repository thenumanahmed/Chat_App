import 'dart:developer';
import 'dart:io';

import 'package:chat_app/helper/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../headers.dart';
import '../models/chat_user.dart';

// to view the profile of any user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding the keyboard
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
          //app bar
          appBar: AppBar(
            title: Text(widget.user.name),
          ),
          floatingActionButton: //user about
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           const Text('Joined on: ',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
                Text(MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt ,showYear: true),
                    style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
              ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width, height: mq.height * .03),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 0.1),
                    child: CachedNetworkImage(
                      height: mq.height * 0.2,
                      width: mq.height * 0.2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => const Icon(Icons.error),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * .03),

                  //user email label
                  Text(widget.user.email,
                      style: const TextStyle(color: Colors.black)),

                  SizedBox(height: mq.height * .03),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('About: ',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                      Text(widget.user.about,
                          style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
