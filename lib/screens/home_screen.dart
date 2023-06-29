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
  // for storing all items
  List<ChatUser> _list = [];

  //for storing search items
  List<ChatUser> _searchList = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding the keyboard
      onTap: () => FocusScope.of(context).unfocus(),

      child: WillPopScope(
        //if searching is on & back buton is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            _isSearching = !_isSearching;
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
              leading: const Icon(CupertinoIcons.home),
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name, Email .... '),
                      autofocus: true,
                      style: const TextStyle(fontSize: 16),
                      //to search text changes update the search field
                      onChanged: (value) {
                        //search logic
                        _searchList = [];
                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            _searchList.add(i);
                          }
                        }
                        //to update the ui
                        setState(() {
                          _searchList;
                        });
                      },
                    )
                  : const Text('We Chat'),
              actions: [
                //search user button
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: _isSearching
                        ? const Icon(CupertinoIcons.clear_circled)
                        : const Icon(Icons.search)),

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
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        //for little spacing at start of the screen
                        padding: EdgeInsets.only(top: mq.height * 0.005),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index],
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
            )),
      ),
    );
  }
}
