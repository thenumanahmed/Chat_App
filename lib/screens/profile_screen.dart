import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../headers.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding the keyboard
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
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
                // set user status to offline
                await APIs.updateActiveStatus(false);

                //signing out the user
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //removing the progress indicator
                    Navigator.pop(context);

                    //movinfg to home screen
                    Navigator.pop(context);

                    APIs.auth = FirebaseAuth.instance;

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
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(width: mq.width, height: mq.height * .03),
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                            ?

                            //local image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.1),
                                child: Image.file(
                                  File(_image!),
                                  height: mq.height * 0.2,
                                  width: mq.height * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            :

                            //profile pic from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.1),
                                child: CachedNetworkImage(
                                  height: mq.height * 0.2,
                                  width: mq.height * 0.2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  // placeholder: (context, url) => const Icon(Icons.error),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    child: Icon(CupertinoIcons.person),
                                  ),
                                ),
                              ),

                        //edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            onPressed: () {
                              _showBottomSheet();
                            },
                            elevation: 1,
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(Icons.edit, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: mq.height * .03),
                    Text(widget.user.email,
                        style: const TextStyle(color: Colors.black54)),

                    SizedBox(height: mq.height * .05),

                    //Name text field
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? "",
                      validator: (val) =>
                          val != null && val != '' ? null : "Field Required",
                      decoration: InputDecoration(
                        hintText: 'e.g CHATING PERSON',
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.blue),
                        label: const Text('Name'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: mq.height * .02),

                    //about text field
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? "",
                      validator: (val) =>
                          val != null && val != '' ? null : "Field Required",
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

                    //update button
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          log('inside validate');
                          //to save the state of form
                          _formKey.currentState!.save();

                          //to update the info in firestore
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Profile Updated Succesfully');
                          });
                        }
                      },
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
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .05),
            children: [
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: mq.height * .01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //gallery icon
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      //Pick an image
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        // reduce the quality of image to save server space
                        imageQuality: 80,
                      );

                      //updating the image
                      if (image != null) {
                        //update the image
                        setState(() {
                          _image = image.path;
                        });
                        // print('\ndebug: pthname ${image.path} ');

                        //update the profile picture
                        APIs.updateProfilePicture(File(_image!));

                        //hiding the bottom sheet
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                    ),
                    child: Image.asset('images/add_image.png'),
                  ),

                  //Camera icon
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      //Pick an image
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);

                      //updating the image
                      if (image != null) {
                        //update the image
                        setState(() {
                          _image = image.path;
                        });
                        // print('\ndebug: pthname ${image.path} ');

                        //update the profile picture
                        APIs.updateProfilePicture(File(_image!));

                        //hiding the bottom sheet
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                    ),
                    child: Image.asset('images/camera.png'),
                  ),
                ],
              )
            ],
          );
        });
  }
}
