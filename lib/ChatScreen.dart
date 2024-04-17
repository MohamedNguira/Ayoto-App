import 'package:ayoto/DateWidget.dart';
import 'package:ayoto/PriorityWidget.dart';
import 'package:ayoto/ServerCreateChat.dart';
import 'package:flutter/material.dart';

import 'ChoosingScreen.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.token});

  final String token;

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late Query query;
  static bool finished = false;
  static bool noneed = false;
  String msg = '';
  @override
  void initState() {
    finished = false;
    Chatboxes = [createChatBox("Write what's the problem", false, [],(){setState(() {

    });})];
    super.initState();
  }
  void addQuery(Function f){
      List<String> suggestions = [];
      if(query.question == null)return;
      for(Evidence evidences in query.question!.evidences!){
        suggestions.add(evidences.label!);
      }
      Chatboxes.add(createChatBox(query.question!.label, false, suggestions,f));
      _scrollDown();
  }
  void chooseChoice(int i,Function f){

    SubmitEvidence evidence = SubmitEvidence();
    evidence.id = query.id;
    evidence.message = query.question!.evidences![i].label;
    List<EvidenceChoice> choices = [];
    List<Evidence> evidences = query.question!.evidences!;
    for(int j = 0;j<evidences.length;j++){
      choices.add(EvidenceChoice(id: evidences[j].id,choiceId: "absent"));
      if(i == j)choices[choices.length - 1].choiceId = "present";
    }
    evidence.evidences = choices;
    ChatHandler(token: widget.token).submitevidence(evidence, f);
  }
  List<Widget> Chatboxes = [];
  String convertmsg(String s){
    String msg = "";
    int j = 0;
    for(int i = 0;i<s.length;i++){
      j++;
      if(j > 20 && s[i] == ' '){
        msg += '\n';
        j = 0;
      }else {
        msg += s[i];
      }
    }
    return msg;
  }
  TextEditingController controller = TextEditingController();
  Widget createChatBox(String ?msg, bool mine, List<String> suggestions,Function f){
    msg = convertmsg(msg!);
    if(suggestions.length == 1){
      suggestions = ["Yes" , "No"];
    }
    if(mine){
      return SizedBox(width: 345,child:
      Align(alignment: Alignment.centerRight,child:
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Color(0xFF577DF5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child:
            Text(
              msg!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w500,
              ),
            )),
          ],
        ),
      )
        ,),);
    }
    else {
      Widget w = SizedBox(width: 345,child:
      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,children: [Image.asset("assets/logo.png",scale: 13,),SizedBox(width: 10,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Flexible(child: Text(
                msg!,
                style: TextStyle(
                  color: Color(0xFF152D37),
                  fontSize: 15,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                ),
              ),)
            ],
          ),
        )


      ],),);

      if(suggestions.isEmpty){
        return w;
      }
      else {
        List<Widget> buttons = [];
        int i = 0;
        for(String s0 in suggestions){
          print(s0);
          String s = s0.replaceAll(RegExp('[Â]'), "");
          buttons.add(TextButton(onPressed: (){
            Chatboxes.add(createChatBox(s, true, [],(){setState(() {});}));
            f();
            chooseChoice(i++,(Query q){setState(() {
              this.query = q;

              addQuery(f);
            });



            });
          }, child: Container(

            height: 33,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.50, color: Color(0xFF03B2F0)),
                borderRadius: BorderRadius.circular(27),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Flexible(child:Text(
                  s,
                  style: TextStyle(
                    color: Color(0xFF03B2F0),
                    fontSize: 12,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w500,

                  ),
                ),)
              ],
            ),
          )));
        }
        return Column(children: [
          w,
          SingleChildScrollView(scrollDirection: Axis.horizontal,child: Row(children: buttons,),)
        ],);}
    }
    return Text("test");
  }


  final ScrollController _controller = ScrollController();

// This is what you're looking for!
  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Diagnosis complete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("You don't need medical intervention, you can heal at home"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Return to home'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    if(noneed){
      _showMyDialog();
    }
    Widget buttonToThe3rdScreen = Container(
      height: 48, //...USING WRAPPER
      margin: EdgeInsets.fromLTRB(27, 0, 27, 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChoosingScreen()));
        },
        child: Text(
          'Proceed with booking',
          style:  TextStyle (
            fontFamily: 'Outfit',
            fontSize:  16,
            fontWeight:  FontWeight.w500,
            height:  1.1,
            color:  Color(0xffffffff),
          ),
        ),
        style: ButtonStyle(
          //maximumSize: MaterialStateProperty.all(Size(130, 31)),
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff577df5)),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27),
            ),
          ),
        ),
      )
    );


    Widget textInputField = TextField(
      controller: controller,
      onChanged: (String s){this.msg = s;},
      onSubmitted: (String msg) {
        if(msg.isEmpty)return;
      setState(() {
        Chatboxes.add(createChatBox(msg, true, [], () {
          setState(() {
            controller.clear();
          });
        }));
        ChatHandler(token: widget.token).createchat(msg, (Query q) {
          setState(() {
            this.query = q;
            addQuery(() {
              setState(() {

              });
            });
          });
        });
        print("hi");
      });
    }, decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50)
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: "Type a message...",
        suffixIcon: TextButton(onPressed: (){
            if(msg.isEmpty)return;
            setState(() {
              Chatboxes.add(createChatBox(msg, true, [], () {
                setState(() {
                  controller.clear();
                });
              }));
              ChatHandler(token: widget.token).createchat(msg, (Query q) {
                setState(() {
                  this.query = q;
                  addQuery(() {
                    setState(() {

                    });
                  });
                });
              });
              controller.clear();
              print("hi");
            });
        }, child: Icon(Icons.send,)),
        suffixIconColor: Color(0xFF577DF5)),
    );



    /*
    if(finished){
      //Navigator.pop(context);
      WidgetsBinding.instance.addPostFrameCallback((_) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChoosingScreen())));
    }*/
    // ignore: prefer_const_constructors
    List<Widget> boxes = [];
    for(Widget w in Chatboxes){
      boxes.add(w);
      boxes.add(SizedBox(height: 20,));
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0xf5, 0xf7, 0xff, 1),
        body: SingleChildScrollView(


            child: Center(child: SizedBox(width: 345, child:
          Column(children: [SizedBox(height: 40, ),

            Row(children: [
              Image.asset("assets/logobot.png", scale: 3, ), Icon(Icons.person)
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
            SizedBox(height: 20, ),
            Text(
              'Our chatbot evaluates your current situation and \nbooks and appointment depending on how critical it is.',
              style: TextStyle(
                color: Color(0xFF152D37),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 40, ),
            SizedBox(height: 500,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(controller: _controller,
                    child: Column(children: boxes, ),
                  ),
                )
            ),
            SizedBox(height: 40, ),

            finished ? buttonToThe3rdScreen : textInputField
          ])))));
  }
}
