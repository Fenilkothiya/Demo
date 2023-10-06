import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearnProvider extends StatefulWidget {
  const LearnProvider({super.key});

  @override
  State<LearnProvider> createState() => _LearnProviderState();
}

class _LearnProviderState extends State<LearnProvider> {
   
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
       counter.increment();
      },),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Consumer<Counter>(
                builder: (context, counter, child) {
                  return Center(
                    child: Text(
                      '${counter._count}',
                      style: TextStyle(fontSize: 36)),
                  );
                })
        ],
      ),
    );
  }
}


class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // Notify listeners when the count changes
  }
}