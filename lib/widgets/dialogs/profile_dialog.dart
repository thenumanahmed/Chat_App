import 'package:chat_app/screens/view_profile_screen.dart';
import 'package:flutter/cupertino.dart';

import '../../headers.dart';
import '../../models/chat_user.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * 0.6,
        height: mq.height * 0.35,
        child: Stack(
          children: [
            // user profile picture
            Positioned(
              top: mq.height * 0.075,
              left: mq.width * 0.14,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.33),
                child: CachedNetworkImage(
                  width: mq.width * 0.5,
                  // height: mq.height * 0.2,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  // placeholder: (context, url) => const Icon(Icons.error),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),

            //user name
            Positioned(
              left: mq.width * 0.04,
              top: mq.height * 0.02,
              width: mq.width * 0.55,
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              right: 8,
              top: 6,
              child: MaterialButton(
                  onPressed: () {
                    //hide the alert dialog
                    Navigator.pop(context);
                    // move to user profile screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewProfileScreen(user: user)));
                  },
                  padding: const EdgeInsets.all(0),
                  minWidth: 0,
                  child: const Icon(Icons.info_outline,
                      color: Colors.blue, size: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
