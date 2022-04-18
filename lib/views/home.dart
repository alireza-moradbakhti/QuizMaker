import 'package:flutter/material.dart';
import 'package:quizmaker_bzte/services/database.dart';
import 'package:quizmaker_bzte/utils/colors.dart';
import 'package:quizmaker_bzte/views/create_quiz.dart';
import 'package:quizmaker_bzte/views/play_quiz.dart';
import 'package:quizmaker_bzte/widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? quizStream;
  DatabaseService databaseService = DatabaseService();

  Widget quizList() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: StreamBuilder<dynamic>(
            stream: quizStream,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Container()
                  : ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return QuizTitle(
                          imgUrl: snapshot.data.docs[index].data()["quizImageUrl"],
                          desc: snapshot.data.docs[index].data()["quizDesc"],
                          title: snapshot.data.docs[index].data()["quizTitle"],
                          quizId: snapshot.data.docs[index].data()["quizId"],
                        );
                      });
            }));
  }

  @override
  void initState() {
    databaseService.getQuizData().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
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
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: hexStringToColor("CB2B93"),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }
}

class QuizTitle extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;
  QuizTitle(
      {Key? key, required this.imgUrl, required this.title, required this.desc,required this.quizId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> PlayQuiz(
          quizId: quizId,
        )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8,top: 2),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
                child: Image.network(
              imgUrl,
              width: MediaQuery.of(context).size.width - 48,
              fit: BoxFit.cover,
            )),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 17),),
                  SizedBox(height: 2.5,),
                  Text(desc , style: TextStyle(color: Colors.white, fontSize: 14,),textAlign: TextAlign.center,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
