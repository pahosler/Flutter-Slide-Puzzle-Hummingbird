import 'package:flutter_web/material.dart';
import 'dart:math';
import 'dart:async';

var now = new DateTime.now();
Random rnd = new Random(now.millisecondsSinceEpoch);

class Puzzle extends StatefulWidget {
  Puzzle({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  final winner = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0];
  final _white = Colors.white70;
  final _green = Colors.greenAccent;
  List<int> scrambled = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0];
  int min = 0, max = 16;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: board(),
          ),
          Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: scrambleButton(),
                  ),
                  Center(
                    child: resetButton(),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Widget board() {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      width: 400,
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        children: List.generate(scrambled.length, (index) {
          // if (!isSolvable(scrambled) && !checkWin()) scramble();
          return gameTile(scrambled[index]);
        }),
      ),
    );
  }

  Widget gameTile(num) {
    bool isBlank = num == 0;
    return GestureDetector(
      onTap: () {
        moveTile(num);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isBlank ? _white : _green,
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            "${isBlank ? ' ' : num}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.green[700]),
          ),
        ),
      ),
    );
  }

  Widget scrambleButton() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.all(10.0),
      child: RaisedButton(
        highlightElevation: 6.0,
        color: Colors.lightBlueAccent,
        splashColor: Colors.blue[100],
        onPressed: (() {
          do {
            scrambled.clear();
            scramble();
            setState(() {});
            isSolvable(scrambled) ? print('Solvable') : print('Not solvable');
          } while (!isSolvable(scrambled));
        }),
        child: Text(
          'Click to Scramble!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget resetButton() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.all(10.0),
      child: RaisedButton(
        highlightElevation: 6.0,
        color: Colors.pinkAccent,
        splashColor: Colors.red[100],
        onPressed: (() {
          reset();
        }),
        child: Text(
          'Reset',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  void scramble() {
    int num = rnd.nextInt(max);
    if (scrambled.length == winner.length) {
      return;
    }

    if (scrambled.contains(num)) {
      scramble();
    } else {
      scrambled.add(num);
    }

    if (scrambled.length < winner.length) {
      scramble();
    }
    // return;
  }

  int getInvCount(arr) {
    var inv_count = 0;
    var N = 4;
    for(int i = 0; i < N * N -1; i++){
      for (int j = i + 1; j < N * N; j++){
        if (arr[j] >0 && arr[i]>0 && arr[i] > arr[j])
          inv_count++;
      }
    }
    return inv_count;
  }

  findXPosition(arr) {
    int N = 4;
    for(int i = N-1; i >= 0; i--)
      for(int j = N-1; j>=0; j--)
        if(arr[i+(j*4)] == 0)
          return N - i;
  }

  bool isSolvable(puzzle) {
    var N = puzzle.length - 1;
    var inv_count = getInvCount(puzzle);
    if (N % 1 == 1)
      return !(inv_count % 1 == 1);
    else {
      var pos = findXPosition(puzzle);
      if(pos % 2 == 0)
        return !(inv_count % 2 == 1);
      else
        return inv_count % 2 == 1;
    }
  }

  void reset() {
    scrambled.clear();
    scrambled = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0];
    setState(() {});
    return;
  }

  void moveTile(tileClicked) {
    int blankTile = scrambled.indexOf(0);
    int selectedTile = scrambled.indexOf(tileClicked);
    if (tileClicked == 0 || checkWin()) {
      return;
    }
    if (blankTile == 3 && selectedTile == 4) {
      return;
    } else if (blankTile == 7 && selectedTile == 8) {
      return;
    } else if (blankTile == 11 && selectedTile == 12) {
      return;
    } else if (blankTile == 4 && selectedTile == 3) {
      return;
    } else if (blankTile == 8 && selectedTile == 7) {
      return;
    } else if (blankTile == 12 && selectedTile == 11) {
      return;
    } else if (selectedTile - 4 == blankTile ||
        selectedTile + 4 == blankTile ||
        selectedTile - 1 == blankTile ||
        selectedTile + 1 == blankTile) {
      setState(() {
        scrambled[selectedTile] = 0;
        scrambled[blankTile] = tileClicked;
      });
      if (checkWin()) {
        _handleWin();
      }
    } else {
      return;
    }
  }

  bool checkWin() {
    bool win = true;
    for (var i = 0; i < winner.length; i++) {
      win = winner[i] == scrambled[i];
      if (!win) {
        break;
      }
    }
    return win;
  }

  void _handleWin() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("GREAT JOB"),
          content: Text("You Solved the Puzzle!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                // scrambled.clear();
                // scramble();
                // setState(() {});
                reset();
                Navigator.pop(context);
              },
              child: Text("Play again"),
            ),
          ],
        );
      },
    );
  }
}
