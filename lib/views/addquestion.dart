import 'package:flutter/material.dart';
import '../services/database.dart';
import '../utils/colors.dart';
import '../widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
   final String quizId;
   AddQuestion({Key? key, required this.quizId}) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  String? question, option1, option2, option3, option4;
  DatabaseService databaseService = DatabaseService();
  bool _isLoading= false;

  uploadQuestionData() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      Map<String,String> questionMap = {
        "question" : question!,
        "option1": option1!,
        "option2": option2!,
        "option3": option3!,
        "option4": option4!,
      };

     await databaseService.addQuestionData(questionMap, widget.quizId).then((value){
       setState(() {
         _isLoading = false;
       });
     });
    }
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
      body: _isLoading ? Container(
        child: Center(child: CircularProgressIndicator(),),
      ) : Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter The Question" : null,
                decoration: InputDecoration(
                    hintText: "Question ",
                    hintStyle: TextStyle(color: Colors.white70)),
                onChanged: (val) {
                  question = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Option 1" : null,
                decoration: InputDecoration(
                    hintText: "Option 1 (Correct Answer) ",
                    hintStyle: TextStyle(color: Colors.white70)),
                onChanged: (val) {
                  option1 = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Option 2" : null,
                decoration: InputDecoration(
                    hintText: "Option 2 ",
                    hintStyle: TextStyle(color: Colors.white70)),
                onChanged: (val) {
                  option2 = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Option 3" : null,
                decoration: InputDecoration(
                    hintText: "Option 3 ",
                    hintStyle: TextStyle(color: Colors.white70)),
                onChanged: (val) {
                  option3 = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Option 4" : null,
                decoration: InputDecoration(
                    hintText: "Option 4 ",
                    hintStyle: TextStyle(color: Colors.white70)),
                onChanged: (val) {
                  option4 = val;
                },
              ),
              Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: BButton(
                        context: context,
                        label: "Submit",
                        buttonWidth: MediaQuery.of(context).size.width / 2 - 36),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  GestureDetector(
                    onTap: (){
                      uploadQuestionData();
                    },
                      child: BButton(
                          context: context,
                          label: "Add Question",
                          buttonWidth:
                              MediaQuery.of(context).size.width / 2 - 36)),
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
