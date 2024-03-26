import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

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
  var calculField = TextEditingController();
  var resultField = TextEditingController();

  void addInput(String input) {
    if (calculField.text.length < 24) {
      setState(() {
        calculField.text += input;
      });
    }
  }

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
                      controller: calculField,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyTouch(touch: "7", onPressed: () => addInput("7")),
                      MyTouch(touch: "8", onPressed: () => addInput("8")),
                      MyTouch(touch: "9", onPressed: () => addInput("9")),
                      MyTouch(
                        touch: "C",
                        color: MyColors.deleteColor,
                        onPressed: () => {
                          if (calculField.text.isNotEmpty)
                            {
                              calculField.text = calculField.text
                                  .substring(0, calculField.text.length - 1)
                            }
                        },
                      ),
                      MyTouch(
                        touch: "AC",
                        color: MyColors.deleteColor,
                        onPressed: () {
                          calculField.text = "";
                          resultField.text = "";
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  color: MyColors.menuColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyTouch(touch: "4", onPressed: () => addInput("4")),
                      MyTouch(touch: "5", onPressed: () => addInput("5")),
                      MyTouch(touch: "6", onPressed: () => addInput("6")),
                      MyTouch(
                          touch: "+",
                          color: MyColors.accentColor,
                          onPressed: () => addInput("+")),
                      MyTouch(
                          touch: "-",
                          color: MyColors.accentColor,
                          onPressed: () => addInput("-")),
                    ],
                  ),
                ),
                Container(
                  color: MyColors.menuColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyTouch(touch: "1", onPressed: () => addInput("1")),
                      MyTouch(touch: "2", onPressed: () => addInput("2")),
                      MyTouch(touch: "3", onPressed: () => addInput("3")),
                      MyTouch(
                          touch: "x",
                          color: MyColors.accentColor,
                          onPressed: () => addInput("*")),
                      MyTouch(
                          touch: "/",
                          color: MyColors.accentColor,
                          onPressed: () => addInput("/")),
                    ],
                  ),
                ),
                Container(
                  color: MyColors.menuColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyTouch(touch: "0", onPressed: () => addInput("0")),
                      MyTouch(touch: ".", onPressed: () => addInput(".")),
                      MyTouch(touch: "00", onPressed: () => addInput("00")),
                      MyTouch(
                        touch: "=",
                        color: MyColors.accentColor,
                        onPressed: () {
                          try {
                            Parser p = Parser();
                            Expression exp = p.parse(calculField.text == ""
                                ? "0"
                                : calculField.text);
                            ContextModel cm = ContextModel();
                            double eval = exp.evaluate(EvaluationType.REAL, cm);

                            if (eval.toInt() == eval) {
                              resultField.text = eval.toInt().toString();
                            } else {
                              resultField.text = eval.toString();
                            }
                          } catch (e) {
                            debugPrint("Invalid calcul");
                            resultField.text = "Error";
                          }
                        },
                      ),
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
      onPressed: touch.isEmpty ? null : onPressed,
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
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
