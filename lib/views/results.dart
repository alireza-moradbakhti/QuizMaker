import 'package:flutter/material.dart';
import 'package:quizmaker_bzte/widgets/widgets.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total;
  const Results(
      {Key? key,
      required this.correct,
      required this.incorrect,
      required this.total})
      : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${widget.correct}/${widget.total}",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "You Answered ${widget.correct} answers correctly and ${widget.incorrect} answers incorrectly",
              style: TextStyle(fontSize: 17, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 14,
            ),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
                child: BButton(context: context, label: "go to home", buttonWidth: MediaQuery.of(context).size.width / 2))
          ],
        )),
      ),
    );
  }
}
