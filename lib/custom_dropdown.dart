import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String text;
  const CustomDropdown({ Key? key, required this.text }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late GlobalKey actionKey;
  bool isDropDownOpen = false;
  late double height, width, xPosition, yPosition;

  OverlayEntry? floatingDropdown;



  @override
  void initState() {
    super.initState();
    actionKey = LabeledGlobalKey(this.widget.text);
  }

  void findDropDownPosition() {
    RenderBox renderbox = actionKey.currentContext!.findRenderObject() as RenderBox;
    height = renderbox.size.height;
    width = renderbox.size.width;
    Offset offset = renderbox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;


    print(height);
    print(width);
    print(xPosition);
    print(yPosition);
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition + height,
        height: 4 * height,
        child: DropDown(
          itemHeight: height,
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () {
        
        setState(() {
          isDropDownOpen = !isDropDownOpen;
          if(isDropDownOpen) {
            floatingDropdown!.remove();
          } else {
            findDropDownPosition();
            floatingDropdown = _createFloatingDropdown();
            Overlay.of(context)!.insert(floatingDropdown!);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.red,
        child: Row(
          children: [
            Text('Call to Action'.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_drop_down, color: Colors.white)
          ],
        )
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  final double itemHeight;
  const DropDown({ Key? key, required this.itemHeight }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 5),
        Align(
          alignment: Alignment(-0.85, 0),
          child: ClipPath(
            clipper: ArrowClipper(),
            child: Container(
              height: 10,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.red
              ),
            ),
          ),
        ),
        Container(
          height: 3 * itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.red,
              width: 1
            ),
          ),
        )
      ],
    );
  }
}


class ArrowClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}