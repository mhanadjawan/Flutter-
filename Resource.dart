import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:langapp/progress_brain.dart/progress.dart';
import 'package:langapp/screens/profile_page.dart';
import 'package:lottie/lottie.dart';



// ignore: must_be_immutable
class ResourceDownloading extends StatefulWidget {
  late User user;
  late ColorScheme dync;
  ResourceDownloading({super.key, required this.user, required this.dync});

  @override
  State<ResourceDownloading> createState() => _ResourceDownloadingState();
}

class _ResourceDownloadingState extends State<ResourceDownloading> {
  @override
  void initState() {
    // TODO: implement initState
    progress prog = progress();
    prog.get_firebase_progress();


    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfilePage(
              user: widget.user,
              dync: widget.dync,
           ),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.primary,
      body: Center(
          child: LottieBuilder.asset("assets/animation_llgwflgi.json")),
    );
  }
}

