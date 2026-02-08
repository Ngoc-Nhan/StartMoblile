import 'package:flutter/material.dart';
import 'button_value.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String expression = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Calculator")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                expression.isEmpty ? "0" : expression,
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
                width: size.width / 4,
                height: size.width / 5,
                child: buildButton(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String value) {
    final isOperator = [
      Btn.ac,
      Btn.del,
      Btn.percent,
      Btn.divide,
      Btn.multiply,
      Btn.minus,
      Btn.plus,
      Btn.equal,
    ].contains(value);

    return InkWell(
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
    );
  }

  void onBtnTap(String value) {
    switch (value) {
      case Btn.ac:
        expression = "";
        break;

      case Btn.del:
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
        break;

      case Btn.equal:
        calculate();
        break;

      default:
        expression += value;
    }

    setState(() {});
  }

  void calculate() {
    final reg = RegExp(r'(\d+\.?\d*)([+\-×÷%])(\d+\.?\d*)');
    final match = reg.firstMatch(expression);

    if (match == null) return;

    final num1 = double.parse(match.group(1)!);
    final op = match.group(2)!;
    final num2 = double.parse(match.group(3)!);

    double result = 0;

    switch (op) {
      case "+":
        result = num1 + num2;
        break;
      case "-":
        result = num1 - num2;
        break;
      case "×":
        result = num1 * num2;
        break;
      case "÷":
        if (num2 == 0) {
          expression = "Error";
          return;
        }
        result = num1 / num2;
        break;
      case "%":
        result = num1 % num2;
        break;
    }

    expression = result.toString();
  }
}
