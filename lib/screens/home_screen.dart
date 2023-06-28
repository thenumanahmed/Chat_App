import 'package:chat_app/headers.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //app bar
        appBar: AppBar(
          leading: const Icon(CupertinoIcons.home),
          title: const Text('We Chat'),
          actions: [
            //search user button
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),

            //more features button
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        //floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ));
            },
            child: const Icon(Icons.add_comment_rounded),
          ),
        ),
        body: ListView.builder(
          itemCount:60 ,
          //for little spacing at start of the screen
          padding: EdgeInsets.only(top: mq.height *0.005),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return const ChatUserCard();
          },
        ));
  }
}
