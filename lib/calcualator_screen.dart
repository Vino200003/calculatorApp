import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  List<String> history = [];
  bool isDarkTheme = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkTheme
          ? ThemeData.dark()
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
              ),
            ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkTheme
              ? Colors.black
              : const Color.fromARGB(255, 255, 255, 255),
          title: const Text('Calculator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: showHistoryDialog,
            ),
            IconButton(
              icon: Icon(
                isDarkTheme ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
              ),
              onPressed: toggleTheme,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Output Section
              Container(
                color: isDarkTheme
                    ? const Color.fromARGB(31, 135, 133, 133)
                    : const Color.fromARGB(255, 212, 210, 210),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "$number1$operand$number2".isEmpty
                          ? "0"
                          : "$number1$operand$number2",
                      style: TextStyle(
                        fontSize: getFontSize(),
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),

              // Buttons Section
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Wrap(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getFontSize() {
    String currentText = "$number1$operand$number2";
    if (currentText.length > 20) {
      return 30; 
    } else if (currentText.length > 15) {
      return 34; 
    } else {
      return 40; 
    }
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: getButtonColor(value),
          borderRadius: BorderRadius.circular(100),
          boxShadow: isDarkTheme
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    offset: const Offset(-4, -4),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: const Color.fromARGB(255, 95, 90, 90).withOpacity(0.3),
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getButtonColor(String value) {
    if (isDarkTheme) {
      if ([Btn.del, Btn.clr].contains(value)) {
        return const Color.fromARGB(255, 97, 89, 89);
      } else if ([Btn.per, Btn.divide, Btn.subtract, Btn.add, Btn.calculate, Btn.sqrt, Btn.multiply].contains(value)) {
        return const Color.fromARGB(255, 210, 130, 26);
      } else {
        return Colors.grey[900]!; 
      }
    } else {
      if ([Btn.del, Btn.clr].contains(value)) {
        return const Color.fromARGB(255, 179, 90, 74);
      } else if ([Btn.per, Btn.divide, Btn.subtract, Btn.add, Btn.calculate, Btn.sqrt, Btn.multiply].contains(value)) {
        return const Color.fromARGB(255, 255, 165, 0);
      } else {
        return const Color.fromARGB(255, 204, 200, 200);
      }
    }
  }

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  void showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: isDarkTheme ? const Color.fromARGB(255, 33, 33, 33) : Colors.white,
          title: Text(
            "Calculation History",
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          content: SizedBox(
            height: 300,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    history[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                setStateDialog(() {
                  history.clear();
                });
              },
              child: Text(
                "Clear History",
                style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
    if (value == Btn.sqrt) {
      calculateSquareRoot();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
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
      if (number1.isEmpty) {
        number1 = "0";
      }

      
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }

      
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      
      if (number1.length >= 30) return; 
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      
      if (number2.length >= 30) return; 
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    if (operand == Btn.divide && num2 == 0) {
      setState(() {
        number1 = "Error"; 
        operand = "";
        number2 = "";
      });
      return;
    }

    double result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      String calculation = "$number1 $operand $number2 = $result";

      history.insert(0, calculation);
      if (history.length > 20) {
        history.removeLast();
      }

      number1 = result.toString();
      operand = "";
      number2 = "";
    });
  }

  void calculateSquareRoot() {
    if (number1.isEmpty || operand.isNotEmpty || number2.isNotEmpty) {
      return;
    }

    final double num = double.parse(number1);
    if (num < 0) {
      setState(() {
        number1 = "Error"; 
      });
      return;
    }

    setState(() {
      double result = sqrt(num);
      String calculation = "√$number1 = $result";

      history.insert(0, calculation);
      if (history.length > 20) {
        history.removeLast();
      }

      number1 = result.toString();
    });
  }

  void convertToPercentage() {
    if (number1.isEmpty) return;

    double result = double.parse(number1) / 100;
    setState(() {
      number1 = result.toString();
    });
  }
}