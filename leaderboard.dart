// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:langapp/chatroom/chartui.dart';

import '../chatroom/activity.dart';

// ignore: must_be_immutable, camel_case_types
class leaderboard extends StatefulWidget {
  late ColorScheme dync;
  leaderboard({required this.dync, super.key});

  @override
  State<leaderboard> createState() => _leaderboardState();
}

// ignore: camel_case_types
class _leaderboardState extends State<leaderboard> {
  @override
  void initState() {

    super.initState();

    // ignore: avoid_print
    print("object");

  }

  @override
  void dispose() {
    super.dispose();
    online_offline.setstatus(false);
  }

  Activity online_offline = Activity();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          child: const Center(
              child: Text(
            "Leaderboard",
            style: TextStyle(
                fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(
            height: 600,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('user').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text("Loading .."),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("404"),
                    );
                  }
                  var data = snapshot.data!.docs;

                  ///removed
                  if (snapshot.hasData) {
                    online_offline.setstatus(true);
                  }

                  List udata = sort_data(data);

                  return ListView.builder(
                      itemCount: udata.length,
                      itemBuilder: (context, index) {
                        return leadcont(
                            status: udata[index].data()["status"] == true
                                ? (udata[index]
                                            .data()["name"]
                                            .toString()
                                            .toLowerCase() ==
                                        user!.displayName!
                                            .toLowerCase()
                                            .toString())
                                    ? Colors.transparent
                                    : Colors.green
                                : Colors.transparent,
                            user: user,
                            name: udata[index].data()["1"]["name"],
                            email: udata[index].reference.id,
                            dync: widget.dync,
                            imageurl: udata[index].data()['avtar_url'],
                            index: index,
                            shield: rank_colors[index < 3 ? index : 3],
                            context: context,
                            rank: udata[index].data()["leader_board"]);
                      });
                }))
      ],
    );
  }

  List rank_colors = [
    const Color.fromARGB(255, 241, 186, 20),
    const Color.fromARGB(255, 231, 205, 205),
    Colors.brown,
    Colors.white
  ];
}

List sort_data(List liss) {
  for (int i = 0; i < liss.length; i++) {
    for (int j = 0; j <= i; j++) {
      if (liss[i].data()["leader_board"] > liss[j].data()["leader_board"]) {
        var temp = liss[j];
        liss[j] = liss[i];
        liss[i] = temp;
      }
    }
  }
  return (liss);
}

GestureDetector leadcont(
    {required user,
    required name,
    required String email,
    required ColorScheme dync,
    required imageurl,
    required int index,
    required Color shield,
    required BuildContext context,
    required rank,
    required Color status}) {
  return GestureDetector(
    onTap: () {
      (name.toString().toLowerCase() ==
              user!.displayName!.toLowerCase().toString())
          ? {}
          : {
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return chatUI(
                    reciver: name.toString().toLowerCase(),
                    reciver_name: name,
                    dync: dync);
              })))
            };
    },
    child: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: (name.toString().toLowerCase() ==
                  user!.displayName!.toLowerCase().toString())
              ? dync.primaryContainer
              : Colors.white,
          border: Border.all(
              color: (name.toString().toLowerCase() !=
                      user!.displayName!.toLowerCase().toString())
                  ? dync.primaryContainer
                  : Colors.white,
              width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            index < 3
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                    width: MediaQuery.of(context).size.width / 13,
                    child: Icon(
                      Icons.shield,
                      color: shield,
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                    width: MediaQuery.of(context).size.width / 10,
                    child: Center(
                        child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: dync.primary),
                    )),
                  ),
            Stack(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    child: Image.network(imageurl.toString()),
                  ),
                ),
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color: status,
                      borderRadius: const BorderRadius.all(Radius.circular(50))),
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.6,
              height: MediaQuery.of(context).size.width / 14,
              child: Text(
                name,
                textAlign: TextAlign.left,
                style:
                    TextStyle(color: dync.primary, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              rank.toString(),
              textAlign: TextAlign.left,
              style:
                  TextStyle(color: dync.primary, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ),
  );
}
