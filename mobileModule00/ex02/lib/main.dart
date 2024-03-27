import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyColors {
  static const neutralColor = Color(0xFF010020);
  static const menuColor = Color(0xFF030170);
  static const deleteColor = Color(0xFFFF3232);
  static const primaryColor = Color(0xFFFFFFFF);
  static const accentColor = Color(0xFF00FFFF);
}

bool isLandscape(context) {
  return MediaQuery.of(context).orientation == Orientation.landscape;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var expressionField = TextEditingController();
  var resultField = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calculator",
      home: Scaffold(
        backgroundColor: const Color(0xFF01002B),
        appBar: AppBar(
          title: const Center(child: Text("Calculator")),
          backgroundColor: MyColors.menuColor,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      style: const TextStyle(
                          color: MyColors.primaryColor, fontSize: 24),
                      decoration: const InputDecoration(
                          hintText: '0',
                          hintStyle:
                              TextStyle(color: Colors.white60, fontSize: 24),
                          border: InputBorder.none),
                      textAlign: TextAlign.end,
                      enabled: false,
                      controller: expressionField,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      style: const TextStyle(
                          color: MyColors.primaryColor, fontSize: 24),
                      decoration: const InputDecoration(
                          hintText: '0',
                          hintStyle:
                              TextStyle(color: Colors.white60, fontSize: 24),
                          border: InputBorder.none),
                      textAlign: TextAlign.end,
                      enabled: false,
                      controller: resultField,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Container(
                  color: MyColors.menuColor,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyTouch(touch: "7"),
                      MyTouch(touch: "8"),
                      MyTouch(touch: "9"),
                      MyTouch(touch: "C", color: MyColors.deleteColor),
                      MyTouch(touch: "AC", color: MyColors.deleteColor),
                    ],
                  ),
                ),
                Container(
                  color: MyColors.menuColor,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyTouch(touch: "4"),
                      MyTouch(touch: "5"),
                      MyTouch(touch: "6"),
                      MyTouch(touch: "+", color: MyColors.accentColor),
                      MyTouch(touch: "-", color: MyColors.accentColor),
                    ],
                  ),
                ),
                Container(
                  color: MyColors.menuColor,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyTouch(touch: "1"),
                      MyTouch(touch: "2"),
                      MyTouch(touch: "3"),
                      MyTouch(touch: "x", color: MyColors.accentColor),
                      MyTouch(touch: "/", color: MyColors.accentColor),
                    ],
                  ),
                ),
                Container(
                  color: MyColors.menuColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const MyTouch(touch: "0"),
                      const MyTouch(touch: "."),
                      const MyTouch(touch: "00"),
                      const MyTouch(touch: "=", color: MyColors.accentColor),
                      MyTouch(
                        touch: "",
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyTouch extends StatelessWidget {
  const MyTouch({
    super.key,
    this.color,
    this.onPressed,
    required this.touch,
  });

  final Color? color;
  final VoidCallback? onPressed;
  final String touch;

  @override
  Widget build(BuildContext context) {
    // return Text(touch);
    return TextButton(
      onPressed: touch.isEmpty
          ? null
          : () {
              debugPrint(touch);
            },
      style: ElevatedButton.styleFrom(
        padding: isLandscape(context)
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 24),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          touch,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color ?? MyColors.primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
