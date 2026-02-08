import 'package:flutter/material.dart';
import 'button_value.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String number1 = "";
  String number2 = "";
  String operand = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                displayText(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Wrap(
            children: Btn.buttonValues.map((value) {
              return SizedBox(
                width: screenSize.width / 4,
                height: screenSize.width / 5,
                child: buildButton(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String displayText() {
    final text = "$number1 $operand $number2".trim();
    return text.isEmpty ? "0" : text;
  }

  Widget buildButton(String value) {
    final isOperator = [
      Btn.ac,
      Btn.del,
      Btn.plus,
      Btn.minus,
      Btn.multiply,
      Btn.divide,
      Btn.equal,
    ].contains(value);

    return Material(
      child: InkWell(
        onTap: () => onBtnTap(value),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isOperator ? Colors.deepPurple : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.ac) {
      clearAll();
      return;
    }

    if (value == Btn.del) {
      delete();
      setState(() {});
      return;
    }

    if (value == Btn.equal) {
      calculate();
      setState(() {});
      return;
    }

    appendValue(value);
    setState(() {});
  }

  void appendValue(String value) {
    // Toán tử
    if (int.tryParse(value) == null && value != Btn.dot) {
      if (number1.isEmpty) return;

      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
      return;
    }

    // Nhập number1
    if (operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      number1 += value;
    }
    // Nhập number2
    else {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      number2 += value;
    }
  }

  void calculate() {
    if (number1.isEmpty || number2.isEmpty || operand.isEmpty) return;

    final num1 = double.parse(number1);
    final num2 = double.parse(number2);
    double result = 0;

    switch (operand) {
      case Btn.plus:
        result = num1 + num2;
        break;
      case Btn.minus:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        if (num2 == 0) {
          number1 = "Error";
          number2 = "";
          operand = "";
          return;
        }
        result = num1 / num2;
        break;
    }

    number1 = result.toString();
    number2 = "";
    operand = "";
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
  }

  void clearAll() {
    number1 = "";
    number2 = "";
    operand = "";
    setState(() {});
  }
}
