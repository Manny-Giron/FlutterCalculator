import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator by Manny',
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _accumulator = '';
  bool _evaluated = false; // Indicates if the last action was evaluation

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        // Clear functionality
        _accumulator = '';
        _evaluated = false;
      } else if (value == '=') {
        try {
          // Evaluate the expression using the "expressions" package
          Expression exp = Expression.parse(_accumulator);
          final evaluator = const ExpressionEvaluator();
          var eval = evaluator.eval(exp, {});

          // Check for division by zero (Infinity)
          if (eval is double && eval.isInfinite) {
            _accumulator = 'Error';
          } else {
            _accumulator = '$_accumulator = $eval';
          }
          _evaluated = true;
        } catch (e) {
          _accumulator = 'Error';
          _evaluated = true;
        }
      } else {
        // If the previous action was evaluation and user starts a new input,
        // then reset the accumulator.
        if (_evaluated) {
          _accumulator = '';
          _evaluated = false;
        }
        _accumulator += value;
      }
    });
  }

  Widget _buildButton(String label, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.blueGrey,
            padding: const EdgeInsets.all(24.0),
          ),
          onPressed: () => _onButtonPressed(label),
          child: Text(
            label,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator by Manny'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display/Accumulator
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            color: Colors.black12,
            width: double.infinity,
            height: 120,
            child: Text(
              _accumulator,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          const Divider(height: 1),
          // Buttons
          Expanded(
            child: Column(
              children: [
                // Row 1: 7, 8, 9, /
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('/', color: Colors.orange),
                  ],
                ),
                // Row 2: 4, 5, 6, *
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('*', color: Colors.orange),
                  ],
                ),
                // Row 3: 1, 2, 3, -
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-', color: Colors.orange),
                  ],
                ),
                // Row 4: C, 0, =, +
                Row(
                  children: [
                    _buildButton('C', color: Colors.red),
                    _buildButton('0'),
                    _buildButton('=', color: Colors.green),
                    _buildButton('+', color: Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
