import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:langapp/chatroom/chatbrain.dart';
import 'package:langapp/chatroom/message.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable, camel_case_types
class chatUI extends StatefulWidget {
  late String reciver;
  late ColorScheme dync;
  // ignore: non_constant_identifier_names
  late String reciver_name;

  chatUI(
      {required this.reciver,
      required this.dync,
      // ignore: non_constant_identifier_names
      required this.reciver_name,
      super.key});

  @override
  State<chatUI> createState() => _chatUIState();
}

// ignore: camel_case_types
class _chatUIState extends State<chatUI> {
  late chatbrain brain;
  String? sender = FirebaseAuth.instance.currentUser!.displayName;

  TextEditingController messagefield = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brain = chatbrain(reciver: widget.reciver);
    brain.chatroomid();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.dync.onPrimaryContainer,
          title: Text(widget.reciver_name),
        ),
        backgroundColor: widget.dync.primary,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: brain.recivemessage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading ..");
                      }

                      if (snapshot.hasError) {
                        return const Text("Error occured pls try later ..");
                      }
                      ScrollController scrollController = ScrollController();
                      if (snapshot.hasData) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          scrollController.jumpTo(
                            scrollController.position.maxScrollExtent,
                          );
                        });
                      }


                      return ListView(
                        controller: scrollController,
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Align(
                            alignment: data['Reciver'] != widget.reciver_name
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color:
                                        data['Reciver'] != widget.reciver_name
                                            ? widget.dync.primaryContainer
                                            : widget.dync.onPrimaryContainer),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      "  " + data['Message'] + "  ",
                                      style: TextStyle(
                                          color: data['Reciver'] ==
                                                  widget.reciver_name
                                              ? widget.dync.primaryContainer
                                              : widget.dync.onPrimaryContainer),
                                    ),
                                    Text(
                                      timeago.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              data['TimeStamp']
                                                  .millisecondsSinceEpoch),
                                          locale: 'en_short'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 8,
                                          color: data['Reciver'] ==
                                                  widget.reciver_name
                                              ? widget.dync.primaryContainer
                                              : widget.dync.onPrimaryContainer),
                                    )
                                  ],
                                )),
                          );
                        }).toList(),
                      );
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                    color: widget.dync.onPrimaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: widget.dync.inversePrimary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        // width: MediaQuery.of(context).size.width / 1.3,
                        height: MediaQuery.of(context).size.width / 6.5,
                        child: TextField(
                          controller: messagefield,
                          cursorColor: widget.dync.primary,
                          style: TextStyle(color: widget.dync.primary),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: widget.dync.onPrimary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: IconButton(
                            onPressed: () {
                              if (messagefield.text.isNotEmpty) {
                                message msg = message(
                                    sender: sender!,
                                    reciver: widget.reciver_name,
                                    msg: messagefield.text.toString());

                                messagefield.clear();

                                brain.sendmessage(msg.getFmsg());
                              }
                            },
                            icon: const Icon(Icons.send))),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
