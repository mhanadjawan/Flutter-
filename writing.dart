import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:flutter/material.dart';
import '../../writingbrain/writingbrain.dart';

// ignore: must_be_immutable
class Writing extends StatefulWidget {
  late ColorScheme dync;
  Writing({required this.dync, super.key});

  @override
  State<Writing> createState() => _WritingState();
}

class _WritingState extends State<Writing> {
  String headingcheck = "🐧🐧🐧🐧🐧";

  // ignore: unused_field
  final WritingBrain _writingBrain = WritingBrain();

  @override
  Widget build(BuildContext context) {
    GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();

    return Scaffold(
      backgroundColor: widget.dync.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            color: widget.dync.primary,
            height: MediaQuery.of(context).size.height / 10,
            child: Center(
                child: Text(
              headingcheck,
              style: const TextStyle(fontSize: 20),
            )),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: widget.dync.primaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: SfSignaturePad(
                minimumStrokeWidth: 5,
                maximumStrokeWidth: 5,
                strokeColor: widget.dync.primary,
                key: signaturePadKey,
                backgroundColor: widget.dync.primaryContainer,
              ),
            ),
          ),
          GestureDetector(
              onTap: () async {
                signaturePadKey.currentState!.clear();
                // final signatureImage =
                //     await _signaturePadKey.currentState?.toImage();
                // final ByteData? byteData = await signatureImage?.toByteData(
                //     format: ui.ImageByteFormat.png);
                // final Uint8List? signatureBytes =
                //     byteData?.buffer.asUint8List();

                // // Save the signature image to the device's local storage
                // final directory = await getApplicationDocumentsDirectory();
                // final filePath = '${directory.path}/signature.png';
                // final File file = File(filePath);
                // await file.writeAsBytes(signatureBytes!);

                // _writingBrain.extractTextFromImage(
                //     filePath);
              },
              child: Expanded(
                  child: Container(
                margin: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height / 11,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: widget.dync.inversePrimary),
                child: const Center(
                  child: Text(
                    "Clear",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              )))
        ],
      ),
    );
  }
}
