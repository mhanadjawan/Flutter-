import 'dart:math';

import 'package:langapp/learning/progress.dart';
import 'package:langapp/progress_brain.dart/progress.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_tts/flutter_tts.dart';

double height = 250;

// ignore: must_be_immutable, camel_case_types
class questionsUi extends StatefulWidget {
  final String topic;
  late ColorScheme dync;
  questionsUi({super.key, required this.topic, required this.dync});

  @override
  State<questionsUi> createState() => _questionsUiState();
}

class _questionsUiState extends State<questionsUi> {
  late int Randint;
  Color answer_opition = Colors.white;
  bool Popin_correct = false;
  bool Popin_incorrect = false;
  double Progress = 0;
  late List Question;
  List UQuestion = [];
  late String lang;
  late String lang_code;
  progress prog = progress();

  var box = Hive.box("LocalDB");
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    print(box.get("Data_downloaded"));

    Question = box.get(widget.topic);

    lang =
        box.get("Lang")[box.get("current_lang").toString()]['Selected_lang'][0];
    lang_code =
        box.get("Lang")[box.get("current_lang").toString()]['Selected_lang'][1];

    Map<dynamic, dynamic> RawData = box.get("Data_downloaded");

    var TempU = RawData[widget.topic];
    print(TempU);
    var i = 0;
    for (var element in Question) {
      UQuestion.add([TempU[i], element]);
      i++;
    }
    print(UQuestion.isNotEmpty);
    Random RandomNumber = Random();
    Randint = RandomNumber.nextInt(4);
    UQuestion.shuffle();
    super.initState();
  }

  int nextQuestion() {
    Random RandomNumber = Random();
    Randint = RandomNumber.nextInt(4);
    UQuestion.shuffle();
    return Randint;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.dync.primary,
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 17,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios_new_sharp)),
                    LinearPercentIndicator(
                      progressColor: Colors.black,
                      percent: Progress,
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                    const Icon(Icons.report)
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      "${(UQuestion[Randint][0])} in $lang",
                      style: const TextStyle(fontSize: 20),
                    )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        flutterTts.setLanguage(trcode[lang_code].toString());

                        flutterTts.speak(UQuestion[Randint][1]);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: widget.dync.primaryContainer,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        child: const Icon(
                          Icons.audio_file,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AnswerOptions(UQuestion[0][1], UQuestion[Randint][1]),
                      AnswerOptions(UQuestion[1][1], UQuestion[Randint][1]),
                      AnswerOptions(UQuestion[2][1], UQuestion[Randint][1]),
                      AnswerOptions(UQuestion[3][1], UQuestion[Randint][1]),
                    ],
                  ),
                ),
              )
            ],
          ),
          Incorrect(context),
          correct(context)
        ]),
      ),
    );
  }

  Visibility Incorrect(BuildContext context) {
    return Visibility(
      visible: Popin_incorrect,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          height: MediaQuery.of(context).size.height / 4,
          width: double.infinity,
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Incorrect",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Correct Answer",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  UQuestion[Randint][1],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Randint = nextQuestion();
                      Popin_incorrect = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: const Text(
                      "Got it",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Visibility correct(BuildContext context) {
    return Visibility(
      visible: Popin_correct,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          width: double.infinity,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  " Awesome!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Randint = nextQuestion();
                      Popin_correct = false;
                      if (Progress <= 0.8) {
                        Progress += 0.2;
                      } else {
                        prog.progress_update(0);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => IndProgress(
                                  data: widget.topic,
                                  dync: widget.dync,
                                )));
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: const Text(
                      "CONTINUE",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded AnswerOptions(String value, String answer) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        if (value == answer) {
          setState(() {
            Popin_correct = true;
          });
        } else {
          setState(() {
            Popin_incorrect = true;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
            color: widget.dync.primaryContainer,
            border: Border.all(color: widget.dync.onPrimary),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
            child: Text(
          value,
          style: TextStyle(
              color: widget.dync.secondary,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        )),
      ),
    ));
  }
}

Map<String, String> trcode = {
  "hr": "hr-HR",
  "ko": "ko-KR",
  "mr": "mr-IN",
  "ru": "ru-RU",
  "zh": "zh-TW",
  "hu": "hu-HU",
  "sw": "sw-KE",
  "th": "th-TH",
  "en": "en-US",
  "hi": "hi-IN",
  "fr": "fr-FR",
  "ja": "ja-JP",
  "ta": "ta-IN",
  "ro": "ro-RO"
};
