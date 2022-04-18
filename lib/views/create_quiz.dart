import 'package:flutter/material.dart';
import 'package:quizmaker_bzte/services/database.dart';
import 'package:quizmaker_bzte/utils/colors.dart';
import 'package:quizmaker_bzte/views/addquestion.dart';
import 'package:quizmaker_bzte/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({Key? key}) : super(key: key);

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String? quizImageUrl,quizTitle,quizDescription,quizId;
  DatabaseService databaseService = DatabaseService();

  bool _isLoading= false;

  createQuizOnline() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      quizId = randomAlphaNumeric(16);
      Map<String,String> quizMap = {
        "quizId" : quizId!,
        "quizImageUrl": quizImageUrl!,
        "quizTitle": quizTitle!,
        "quizDesc" : quizDescription!,

      };
      await databaseService.addQuizData(quizMap, quizId!).then((value){
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>  AddQuestion(
                quizId: quizId!,
              )
          ));
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
                validator: (val) => val!.isEmpty ? "Enter Image Url" : null,
                decoration: InputDecoration(
                  hintText: "Quiz Image Url " , hintStyle: TextStyle(color: Colors.white70)
                ),
                onChanged: (val){
                  quizImageUrl = val;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Quiz Title" : null,
                decoration: InputDecoration(
                  hintText: "Quiz Title",hintStyle: TextStyle(color: Colors.white70)
                ),
                onChanged: (val){
                  quizTitle = val;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter The Description of Your Quiz" : null,
                decoration: InputDecoration(
                  hintText: "Quiz Description", hintStyle: TextStyle(color: Colors.white70)
                ),
                onChanged: (val){
                  quizDescription = val;
                },
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  createQuizOnline();
                },
                  child: BButton(context: context,label: "Create Quiz")),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
