import 'package:flutter/material.dart';

// ignore: must_be_immutable, camel_case_types
class callbox extends StatefulWidget {
  late ColorScheme dync;
  callbox({required this.dync, super.key});

  @override
  State<callbox> createState() => _callboxState();
}

// ignore: camel_case_types
class _callboxState extends State<callbox> {
  @override
  Widget build(BuildContext context) {
    double kh = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: kh / 3,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Row(
                children: [
                  Text(
                    "Hello \nAbilash",
                    style: TextStyle(
                        color: widget.dync.surface,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text("")
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Requested Students",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: widget.dync.inversePrimary,
          ),
        ),
        SizedBox(
          height: kh / 3,
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return SizedBox(
                 // color: //,
                  width: double.infinity,
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 40,
                        width: 40,
                      ),
                      const Column(
                        children: [Text("Name"), Text("Email")],
                      ),
                      Column(
                        children: [
                          Container(
                            child: const Text("Accept"),
                          ),
                          Container(
                            child: const Text("Decline"),
                          )
                        ],
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}

List<String> data = [
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh"
];
