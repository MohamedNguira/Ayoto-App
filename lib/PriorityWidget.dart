import 'package:flutter/material.dart';


class PriorityWidget extends StatefulWidget {
  const PriorityWidget({super.key, required this.state});
  final int state;
  @override
  State<PriorityWidget> createState() => PriorityWidgetState();
}

class PriorityWidgetState extends State<PriorityWidget> {

  List<Widget> widgets = [Container(
    width: 43,
    height: 23,
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Low',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  ),
    Container(
      width: 61,
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Color(0xFFF3CB3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Medium',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
    Container(
      width: 43,
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFFF3A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'High',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    )
  ];
  @override
  Widget build(BuildContext context) {

    return widgets[widget.state];
  }
}
