import 'package:flutter/cupertino.dart';

import '../headers.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //app bar
        appBar: AppBar(
          title: const Text('Profile Screen'),
        ),
        //floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            icon: const Icon(Icons.logout_rounded),
            backgroundColor: Colors.blue,
            label: const Text("Log Out"),
            onPressed: () async {
              //show the loading progress indicator
              Dialogs.showProgressBar(context);

              //signing out the user
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //removing the progress indicator
                  Navigator.pop(context);

                  //movinfg to home screen
                  Navigator.pop(context);

                  //replacing the current screen with login screen
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ));
                });
              });
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              SizedBox(width: mq.width, height: mq.height * .03),
              Stack(
                children: [
                  //profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 0.1),
                    child: CachedNetworkImage(
                      height: mq.height * 0.2,
                      width: mq.height * 0.2,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => const Icon(Icons.error),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),

                  //edit image button
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      onPressed: () {},
                      elevation: 1,
                      shape: const CircleBorder(),
                      color: Colors.white,
                      child: const Icon(Icons.edit, color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(height: mq.height * .03),
              Text(widget.user.email,
                  style: const TextStyle(color: Colors.black54)),
              SizedBox(height: mq.height * .05),
              TextFormField(
                initialValue: widget.user.name,
                decoration: InputDecoration(
                  hintText: 'e.g CHATING PERSON',
                  prefixIcon: const Icon(Icons.person, color: Colors.blue),
                  label: const Text('Name'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: mq.height * .02),
              TextFormField(
                initialValue: widget.user.about,
                decoration: InputDecoration(
                  hintText: 'e.g Feeling Happy',
                  prefixIcon:
                      const Icon(Icons.info_outline, color: Colors.blue),
                  label: const Text('About'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: mq.height * .04),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: Size(mq.width * .5, mq.height * 0.06)),
                icon: const Icon(Icons.edit, size: 25),
                label: const Text(
                  "Update",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ));
  }
}
