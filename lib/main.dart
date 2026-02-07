import 'package:basic_app/button_value.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "$number1 $operand $number2".trim().isEmpty
                        ? "0"
                        : "$number1 ${operand == Btn.equal ? " " : operand} $number2",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: screenSize.width / 4,
                      height: screenSize.width / 5,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Material(
      textStyle:
          [
            Btn.ac,
            Btn.del,
            Btn.percent,
            Btn.divide,
            Btn.equal,
            Btn.multiply,
            Btn.minus,
            Btn.plus,
            Btn.convert,
          ].contains(value)
          ? TextStyle(color: Colors.red.shade300)
          : TextStyle(color: Colors.black),
      child: InkWell(
        onTap: () => onBtnTap(value),
        child: Center(
          child: Text(
            value,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.ac) {
      number1 = "";
      number2 = "";
      operand = "";
      setState(() {});
      return;
    }
    if (value == Btn.equal) {
      equal();
    }
    appendValue(value);
  }

  void equal() {
    if (number1.isEmpty || number2.isEmpty || operand.isEmpty) {
      return;
    }
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);
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
        if (num2 != 0) {
          result = num1 / num2;
        } else {
          // Handle division by zero
          number1 = "Error";
          number2 = "";
          operand = "";
          setState(() {});
          return;
        }
        break;
      case Btn.percent:
        result = num1 % num2;
        break;
      default:
        return;
    }

    number1 = "$result";
    number2 = "";
    operand = "";
    setState(() {});
    return;
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isEmpty) {}
      operand = value;
    } //
    else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (number1.isEmpty || number1 == "0")) {
        value = "0.";
      }
      number1 += value;
    } //
    else if (number2.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (number2.isEmpty || number2 == "0")) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }
}
