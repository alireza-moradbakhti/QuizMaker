import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizmaker_bzte/models/question_model.dart';
import 'package:quizmaker_bzte/services/database.dart';
import 'package:quizmaker_bzte/views/results.dart';
import 'package:quizmaker_bzte/widgets/quiz_play_widget.dart';
import '../utils/colors.dart';
import '../widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  const PlayQuiz({Key? key, required this.quizId}) : super(key: key);

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;

Stream? infoStream;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = DatabaseService();
  QuerySnapshot? questionSnapshot;

  bool isLoading = true;

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot<dynamic> questionSnapshot) {
    QuestionModel questionModel = QuestionModel();
    questionModel.question = questionSnapshot.data()["question"];

    List<String> options = [
      questionSnapshot.data()["option1"],
      questionSnapshot.data()["option2"],
      questionSnapshot.data()["option3"],
      questionSnapshot.data()["option4"],
    ];
    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.data()["option1"];
    questionModel.answered = false;

    print(questionModel.correctOption!.toLowerCase());

    return questionModel;
  }

  @override
  void initState() {
    databaseService.getQuizesData(widget.quizId).then((value) {
      questionSnapshot = value;
      _notAttempted = questionSnapshot!.docs.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnapshot!.docs.length;
      setState(() {});
      print("init don $total ${widget.quizId} ");
    });
    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        print("this is x $x");
        return [_correct, _incorrect];
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: hexStringToColor("CB2B93"),
        elevation: 0.0,
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    InfoHeader(
                      length: questionSnapshot!.docs.length,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    questionSnapshot!.docs == null
                        ? Container(
                            child: Center(
                              child: Text("No Data"),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: questionSnapshot?.docs.length,
                            itemBuilder: (context, index) {
                              return QuizPlayTile(
                                questionModel: getQuestionModelFromDatasnapshot(
                                    questionSnapshot!.docs[index]),
                                index: index,
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                        correct: _correct,
                        incorrect: _incorrect,
                        total: total,
                      )));
        },
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      NoOfQuestionTile(
                        text: "Total",
                        number: widget.length,
                      ),
                      NoOfQuestionTile(
                        text: "Correct",
                        number: _correct,
                      ),
                      NoOfQuestionTile(
                        text: "Incorrect",
                        number: _incorrect,
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  const QuizPlayTile(
      {Key? key, required this.questionModel, required this.index})
      : super(key: key);

  @override
  State<QuizPlayTile> createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q${widget.index + 1}) ${widget.questionModel.question!}",
            style: TextStyle(fontSize: 17, color: Colors.black87),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (widget.questionModel.answered == false) {
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option1!;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option1!;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTitle(
                option: "A",
                desc: widget.questionModel.option1!,
                cans: widget.questionModel.correctOption!,
                optionSelected: optionSelected),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (widget.questionModel.answered == false) {
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option2!;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option2!;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTitle(
                option: "B",
                desc: widget.questionModel.option2!,
                cans: widget.questionModel.correctOption!,
                optionSelected: optionSelected),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (widget.questionModel.answered == false) {
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option3!;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option3!;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTitle(
                option: "C",
                desc: widget.questionModel.option3!,
                cans: widget.questionModel.correctOption!,
                optionSelected: optionSelected),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (widget.questionModel.answered == false) {
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option4!;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option4!;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTitle(
                option: "D",
                desc: widget.questionModel.option4!,
                cans: widget.questionModel.correctOption!,
                optionSelected: optionSelected),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
