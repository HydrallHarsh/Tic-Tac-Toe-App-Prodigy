// import 'dart:ffi';

import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // ignore: constant_identifier_names
  static const String PlayerX = 'X';
  // ignore: constant_identifier_names
  static const String PlayerO = 'O';
  late String currentPlayer = "";
  late bool gameEnd;
  late List<String> occupiedCells;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = PlayerX;
    gameEnd = false;
    occupiedCells = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [headText(), gameContainer(), restartbutton()],
        ),
      ),
    );
  }

  Widget headText() {
    return Column(
      children: [
        const Text(
          "Tic Tac Toe Game",
          style: TextStyle(
              color: Colors.green, fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(),
        Text("$currentPlayer Turn",
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        const SizedBox(),
      ],
    );
  }

  Widget gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 1.2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return box(index);
          }),
    );
  }

  Widget box(int index) {
    return InkWell(
      onTap: () {
        if (gameEnd || occupiedCells[index].isNotEmpty) {
          return;
        }
        setState(() {
          occupiedCells[index] = currentPlayer;
          changeTurn();
          checkforWinners();
          checkforDraw();
        });
      },
      child: Container(
        color: occupiedCells[index].isEmpty
            ? Colors.black26
            : occupiedCells[index] == PlayerX
                ? Colors.green
                : Colors.blue,
        margin: const EdgeInsets.all(8),
        child: Center(
            child: Text(occupiedCells[index],
                style: const TextStyle(fontSize: 30))),
      ),
    );
  }

  changeTurn() {
    if (currentPlayer == PlayerX) {
      currentPlayer = PlayerO;
    } else {
      currentPlayer = PlayerX;
    }
  }

  restartbutton() {
    return ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(Colors.green),
        ),
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Text("Restart Game"));
  }

  checkforWinners() {
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var winningpos in winningList) {
      String PlayerPosition0 = occupiedCells[winningpos[0]];
      String PlayerPosition1 = occupiedCells[winningpos[1]];
      String PlayerPosition2 = occupiedCells[winningpos[2]];
      if (PlayerPosition0.isNotEmpty) {
        if (PlayerPosition0 == PlayerPosition1 &&
            PlayerPosition0 == PlayerPosition2) {
          Color winningColor =
              PlayerPosition0 == 'X' ? Colors.green : Colors.blue;
          showGameOverDialog("Player $PlayerPosition0 Wins", winningColor);
          gameEnd = true;
          return;
        }
      }
    }
  }

  showGameOverDialog(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          "Game Over \n $message",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        duration: Duration(seconds: 3), // Automatically dismiss after 3 seconds
      ),
    );
  }

  checkforDraw() {
    if (gameEnd) {
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupiedCells) {
      if (occupiedPlayer.isEmpty) {
        draw = false;
      }
    }
    if (draw) {
      showGameOverDialog("Draw", Colors.black);
      gameEnd = true;
    }
  }
}
