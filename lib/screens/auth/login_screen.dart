import 'dart:developer';
import 'dart:io';

import 'package:chat_app/headers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration( 
          milliseconds: 500,
        ), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log('\n User ${user.user}');
        log('\n User additional info  ${user.additionalUserInfo}');

        if (await APIs.userExists()) {
          
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen())));
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow(shows pop up)
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n _signInGoogle $e');
      Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //app bar
      appBar: AppBar(
        title: const Text('Welcome to We Chat  '),
      ),

      body: Stack(children: [
        AnimatedPositioned(
          top: mq.height * 0.15,
          right: _isAnimate ? mq.width * 0.25 : -mq.width * 0.5,
          width: mq.width * 0.5,
          duration: const Duration(seconds: 1),
          child: Image.asset('images/icon.png'),
        ),
        Positioned(
          bottom: mq.height * 0.15,
          left: mq.width * 0.05,
          width: mq.width * 0.9,
          height: mq.height * 0.06,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 83, 159, 178),
              shape: const StadiumBorder(),
              elevation: 1,
            ),
            onPressed: () {
              _handleGoogleBtnClick();
            },
            icon: Image.asset(
              'images/google.png',
              height: mq.height * 0.05,
            ),
            label: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 15),
                children: [
                  TextSpan(text: 'Sign In with '),
                  TextSpan(
                    text: 'Google',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
