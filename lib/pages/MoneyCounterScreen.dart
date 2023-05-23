import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyCounterScreen extends StatefulWidget {
  const MoneyCounterScreen({super.key});

  @override
  _MoneyCounterScreen createState() => _MoneyCounterScreen();
}

class _MoneyCounterScreen extends State<MoneyCounterScreen> {
  static const String INCOMES = 'incomes';
  static const String OUTCOMES = 'outcomes';

  double _incomes = 0.0;
  double _outcomes = 0.0;
  double _resultSum = 0.0;

  final _newTransactionController = TextEditingController();

  @override
  void dispose() {
    _newTransactionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initMoney();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        alignment: Alignment.center,
        child: (Column(children: [
          Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 5)),
          AutoSizeText(
            _resultSum.toString(),
            style: const TextStyle(fontSize: 52),
            maxLines: 2,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: TextField(
                                controller: _newTransactionController,
                                decoration: const InputDecoration(
                                    hintText: "Enter your outcome"),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      addOutcome(
                                          _newTransactionController.text);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('SUBMIT'))
                              ],
                            ));
                  },
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(120, 120),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(4),
                    side: BorderSide(width: 3.0, color: Colors.red[700]!),
                  ),
                  child: AutoSizeText(
                    _outcomes.toString(),
                    style: TextStyle(
                        fontSize: 24,
                        color: _outcomes < 0 ? Colors.red[700] : Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 10)),
                OutlinedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: TextField(
                                  controller: _newTransactionController,
                                  decoration: const InputDecoration(
                                      hintText: "Enter your income"),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        addIncome(
                                            _newTransactionController.text);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('SUBMIT'))
                                ],
                              ));
                    },
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(120, 120),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(4),
                      side: const BorderSide(width: 3.0, color: Colors.green),
                    ),
                    child: AutoSizeText(
                      _incomes.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          color: _incomes > 0 ? Colors.green : Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    )),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 80))
        ])),
      ),
    );
  }

  addOutcome(String outcome) async {
    double? newOutcome = double.tryParse(outcome);
    if (newOutcome != null) {
      final prefs = await SharedPreferences.getInstance();
      _outcomes = (_outcomes - newOutcome).toPrecision(2);
      prefs.setDouble(OUTCOMES, _outcomes);
      setState(() {
        _outcomes = (prefs.getDouble(OUTCOMES) ?? 0);
        _resultSum = (_incomes + _outcomes).toPrecision(2);
      });
    }
  }

  addIncome(String income) async {
    double? newIncome = double.tryParse(income);
    if (newIncome != null) {
      final prefs = await SharedPreferences.getInstance();
      _incomes = (_incomes + newIncome).toPrecision(2);
      prefs.setDouble(INCOMES, _incomes);
      setState(() {
        _incomes = (prefs.getDouble(INCOMES) ?? 0);
        _resultSum = (_incomes + _outcomes).toPrecision(2);
      });
    }
  }

  void _initMoney() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _incomes = (prefs.getDouble(INCOMES) ?? 0);
      _outcomes = (prefs.getDouble(OUTCOMES) ?? 0);
      _resultSum = (_incomes + _outcomes).toPrecision(2);
    });
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
