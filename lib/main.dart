import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _controller,_controller2;

  static const List<IconData> icons = const [ Icons.add, Icons.undo, Icons.refresh ];
  int _counter = 0;
  String lastAction = '';
//  FloatingActionButton floatingAdd, floatingSubtract, floatingReset;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      lastAction = 'Increment';
      _controller2.forward();
    });
  }
  void _decrementCOunter() {
    setState((){
      if (_counter > 0)
      _counter--;
      lastAction = 'Decrement';
      _controller2.forward();
    });
  }
  void _resetCounter() {
    setState((){
      _counter = 0;
      lastAction = 'Reset';
      _controller2.reverse();
    });
  }

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controller2 = new AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;

    return new Scaffold(
      appBar: new AppBar(title: new Text('Add Subtract Reset')),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Counter Value',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            new ScaleTransition(
              scale: new CurvedAnimation(parent: _controller2, curve: new Interval(
                  0.0,
                  1.0,
                  curve: Curves.easeOut
              ),
              ),
                  child: new Text(
                'Last Action: $lastAction'
            )
            )
          ],
        ),
      ),
      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        children: new List.generate(icons.length, (int index) {

          Widget child = new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(
                    0.0,
                    1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut
                ),
              ),
              child: new FloatingActionButton(
                backgroundColor: backgroundColor,
                mini: true,
                child: new Icon(icons[index], color: foregroundColor),
                onPressed: () {
                  if (index == 0) {
                    _incrementCounter();
                  }
                  if (index == 1) {
                    _decrementCOunter();
                  }
                  if (index == 2) {
                    _resetCounter();
                  }
                },
              ),
            ),
          );
          return child;
        }).toList()..add(
          new FloatingActionButton(
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 0.5 * 3.17),
                  alignment: FractionalOffset.center,
                  child: new Icon(_controller.isDismissed ? Icons.menu : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
      ),
    );
  }
}