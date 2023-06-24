import 'package:chat_app/headers.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(
          milliseconds: 700,
        ), () {
      //exit- full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );

      //navigate to home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Padding(
            padding:  EdgeInsets.all(8.0),
            child:  LoginScreen(),
          )));
    });
  }



  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
        Positioned(
          top: mq.height * 0.15,
          right: mq.width * 0.25,
          width: mq.width * 0.5,
          child: Image.asset('images/icon.png'),
        ),
        Positioned(
          bottom: mq.height * 0.15,
          width: mq.width,
          child: const Text(
            'Let\'s Chat 💗',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ]),
    );
  }
}
