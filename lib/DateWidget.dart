import 'package:flutter/material.dart';


class DateWidget extends StatefulWidget {
  const DateWidget({super.key, required this.selected, required this.date, required this.day});
  final String day;
  final bool selected;
  final int date;
  @override
  State<DateWidget> createState() => DateWidgetState();
}

class DateWidgetState extends State<DateWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 60,
      height: 70,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 60,
              height: 70,
              decoration: ShapeDecoration(
                color: super.widget.selected?const Color(0xFFD4DDFC):const Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 15,
            child: Text(
              super.widget.date.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF152D37),
                fontSize: 22,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 44,
            child: Text(
              super.widget.day  .toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF152D37),
                fontSize: 12,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
