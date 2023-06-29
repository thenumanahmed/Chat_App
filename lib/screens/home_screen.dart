import 'package:chat_app/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:chat_app/headers.dart';

import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

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
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIs.me),
                      ));
                },
                icon: const Icon(Icons.more_vert))
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
            child: const Icon(Icons.logout_rounded),
          ),
        ),
        body: StreamBuilder(
          stream: APIs.getAllUsers(),
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
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];

                if (list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: list.length,
                    //for little spacing at start of the screen
                    padding: EdgeInsets.only(top: mq.height * 0.005),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUserCard(
                        user: list[index],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No Connections found',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
            }
          },
        ));
  }
}
