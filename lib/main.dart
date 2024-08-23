// ignore_for_file: prefer_const_constructors, dead_code, unused_element, prefer_typing_uninitialized_variables, sort_child_properties_last, avoid_unnecessary_containers

import 'package:calculatorgrey/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userQuestion = '';
  var userAnswer = '';

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    'X',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'ANS',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          userQuestion,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(userAnswer, style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blueGrey[700],
              child: Center(
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    // clear button
                    if (index == 0) {
                      return MyButton(
                        // make it diff color than rest
                        color: Colors.black87,
                        buttonText: buttons[index],
                        textColor: Colors.white,
                        buttonTapped: () {
                          setState(
                            () {
                              userQuestion = '';
                            },
                          );
                        },
                      );
                    }

                    // delete button
                    else if (index == 1) {
                      return MyButton(
                        // make it diff color then rest
                        color: Colors.blueGrey[900],
                        buttonText: buttons[index],
                        textColor: Colors.white,
                        buttonTapped: () {
                          setState(() {
                            if (userQuestion.length <= 1) {
                              userQuestion = '';
                            } else {
                              userQuestion = userQuestion.substring(
                                  0, userQuestion.length - 1);
                            }
                          });
                        },
                      );
                    } else if (index == buttons.length - 1) {
                      return MyButton(
                        buttonText: buttons[index],
                        color: Colors.blueGrey[600],
                        textColor: Colors.white,
                        buttonTapped: () {
                          setState(() {
                            equalPressed();
                          });
                        },
                      );
                    }

                    // rest of the buttons
                    else {
                      return MyButton(
                        buttonTapped: () {
                          setState(() {
                            userQuestion += buttons[index];
                          });
                        },
                        // if button is operator then dark coloured, else light coloured
                        color: isOperator(buttons[index])
                            ? Colors.blueGrey[600]
                            : const Color.fromARGB(74, 255, 255, 255),
                        buttonText: buttons[index],
                        textColor: isOperator(buttons[index])
                            ? Colors.white
                            : Colors.black87,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // method to change button color if the button is operator
  bool isOperator(String x) {
    if (x == '%' || x == '/' || x == 'X' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('X', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
  }
}
