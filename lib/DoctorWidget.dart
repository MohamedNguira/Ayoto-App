import 'package:flutter/material.dart';


class DoctorWidget extends StatefulWidget {
  const DoctorWidget({super.key, required this.name,required this.address,required this.time,required this.selected});
  final String name,address,time;
  final bool selected;
  @override
  State<DoctorWidget> createState() => DoctorWidgetState();
}

class DoctorWidgetState extends State<DoctorWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 345,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 345,
              height: 60,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            left: 270,
            top: 10,
            child: Container(
              width: 71,
              height: 41,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
              decoration: ShapeDecoration(
                color: widget.selected?Color(0xFFD4DDFC):Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.time,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF152D37),
                      fontSize: 14,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,

                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 60,
            top: 12,
            child: Text(
              widget.name,
              style: TextStyle(
                color: Color(0xFF152D37),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,

              ),
            ),
          ),
          Positioned(
            left: 60,
            top: 32,
            child: Text(
              widget.address,
              style: TextStyle(
                color: Color(0xFF152D37),
                fontSize: 12,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,

              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 10,
            child: Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/40x40"),
                  fit: BoxFit.fill,
                ),
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
