import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:langapp/learning/learning.dart';
import 'package:langapp/progress_brain.dart/progress.dart';

// ignore: non_constant_identifier_names
List<String> Vocabulary = [
  "Basic words",
  "Numbers",
  "Colors",
  "Food and drinks",
  "Animals",
  "Common objects"
];

// ignore: non_constant_identifier_names
List<String> Vocabulary_Key = [
  "Basic_Words",
  "Numbers",
  "Colors_Data",
  "Food_Data",
  "Animals_Data",
  "Animals_Data"
];

// ignore: must_be_immutable
class IndProgress extends StatefulWidget {
  late String data;
  late ColorScheme dync;
  IndProgress({super.key, required this.dync, required this.data});
  @override
  State<IndProgress> createState() => _IndProgressState();
}

class _IndProgressState extends State<IndProgress> {
  progress prog = progress();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.dync.secondaryContainer,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              color: widget.dync.primary,
              child: Center(
                child: Text(
                  widget.data,
                  style: TextStyle(
                      color: widget.dync.secondaryContainer,
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: AlignedGridView.count(
                  padding: const EdgeInsets.all(8),
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  itemCount: Vocabulary.length,
                  // ignore: non_constant_identifier_names
                  itemBuilder: (context, Index) {
                    return GestureDetector(
                      onTap: () {
                        !(Index <= prog.progress_get()[0])
                            // ignore: avoid_print
                            ? {print("nothing")}
                            : {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => questionsUi(
                                              topic: Vocabulary_Key[Index],
                                              dync: widget.dync,
                                            )))
                              };
                      },
                      child: !(Index <= prog.progress_get()[0])
                          ? Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  decoration: BoxDecoration(
                                      color: widget.dync.primary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                    child: Text(
                                      Vocabulary[Index],
                                      style: TextStyle(
                                          color: widget.dync.inversePrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    decoration: BoxDecoration(
                                        color: widget.dync.onPrimaryContainer,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.lock,
                                            size: 25,
                                            color: widget.dync.primaryContainer,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              margin: const EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height / 5,
                              decoration: BoxDecoration(
                                  color: widget.dync.primaryContainer,
                                  border: Border.all(
                                      color: widget.dync.primary, width: 2),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20))),
                              child: Center(
                                child: Text(
                                  Vocabulary[Index],
                                  style: TextStyle(
                                      color: widget.dync.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    );
                  }),
            )
          ],
        ));
  }
}
