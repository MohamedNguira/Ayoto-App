import 'package:flutter/material.dart';
import 'ProfileScreen.dart';

class MyHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //SizedBox(width: 27),
        SizedBox(width: 11),
        Image.asset("assets/images/Group 94.png", height: 29.47, width: 107.51),
        Spacer(),
        IconButton(
          icon: Image.asset("assets/images/Group 85.png", height: 18.29, width: 18.89),
          onPressed: () {},
          splashRadius: 24,
        ),
        SizedBox(width: 6),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            borderRadius: BorderRadius.circular(30),
            //splashColor: Colors.blue.withOpacity(0.5),
            child: CircleAvatar(
              //radius: 24,
              backgroundImage: AssetImage("assets/images/MYZHIK.png"),
            ),
          ),
        ),
        /*
        CircleAvatar(
          //radius: 24,
          backgroundImage: AssetImage("assets/images/MYZHIK.png"),
        ),
         */
        SizedBox(width: 11),
        //SizedBox(width: 27),
      ],
    );
  }
}