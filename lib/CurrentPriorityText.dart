import 'package:flutter/material.dart';

class CurrentPriorityText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current priority:  ',
              style:  TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                //height: 1.26,
                color: Color(0xff152d37),
              ),
            ),
            Container(
              width: 43,
              height: 23,
              decoration: BoxDecoration (
                color: Color(0xffff3a2e),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                'High',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize:  12,
                  fontWeight:  FontWeight.w500,
                  //height:  1.26,
                  color:  Color(0xffffffff),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'In order to prevent any major consequences. You should book an appointment within 2 days',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize:  16,
            color:   Color(0xff152d37),
          ),
        ),
      ],
    );
  }
}