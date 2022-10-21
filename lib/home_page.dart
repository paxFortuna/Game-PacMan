import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_pacman/path.dart';

import 'barriers.dart';
import 'ghost.dart';
import 'pacman.dart';
import 'pixel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// omit: 147,
class _HomePageState extends State<HomePage> {
  static List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    26,
    28,
    37,
    38,
    39,
    123,
    134,
    145,
    156,
    129,
    140,
    151,
    162,
    103,
    114,
    125,
    105,
    116,
    127,

    148,
    149,
    158,
    160
  ];

  static int numberOfSquares = numberInRow * 17;
  static int numberInRow = 11;

  int player = numberInRow * 15 + 1;
  int ghost = numberInRow * 2 - 2;

  bool mouthClosed = true;
  int score = 0;
  List<int> food = [];

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  String direction = "right";
  bool gameStarted = false;

  void startGame() {
    gameStarted = true;

    moveGhost();
    getFood();

    Duration duration = const Duration(milliseconds: 150);

    Timer.periodic(duration, (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });

      if (food.contains(player)) {
        food.remove(player);
        score++;
      }

      if (player == ghost) {
        ghost = -1;
      }

      switch (direction) {
        case "right":
          moveRight();
          break;
        case "up":
          moveUp();
          break;
        case "left":
          moveLeft();
          break;
        case "down":
          moveDown();
          break;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!barriers.contains(player + 1)) {
        player++;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!barriers.contains(player - 1)) {
        player--;
      }
    });
  }

  void moveUp() {
    setState(() {
      if (!barriers.contains(player - numberInRow)) {
        player -= numberInRow;
      }
    });
  }

  void moveDown() {
    setState(() {
      if (!barriers.contains(player + numberInRow)) {
        player += numberInRow;
      }
    });
  }

  // ghost moving

  String ghostDirection = "left"; // initial

  void moveGhost() {
    Duration ghostSpeed = const Duration(milliseconds: 500);
    Timer.periodic(ghostSpeed, (timer) {
      if (!barriers.contains(ghost - 1) && ghostDirection != "right") {
        ghostDirection = "left";
      } else if (!barriers.contains(ghost - numberInRow) &&
          ghostDirection != "down") {
        ghostDirection = "up";
      } else if (!barriers.contains(ghost + numberInRow) &&
          ghostDirection != "up") {
        ghostDirection = "down";
      } else if (!barriers.contains(ghost + 1) && ghostDirection != "left") {
        ghostDirection = "right";
      }

      switch (ghostDirection) {
        case "right":
          setState(() {
            ghost++;
          });
          break;

        case "up":
          setState(() {
            ghost -= numberInRow;
          });
          break;

        case "left":
          setState(() {
            ghost--;
          });
          break;

        case "down":
          setState(() {
            ghost += numberInRow;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
        "P A C K M A N",
        style: TextStyle(
            color: Colors.grey[300],
            fontSize: 30,
            fontWeight: FontWeight.bold,
            ),
      ),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 9,
                child: Center(
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > 0) {
                        direction = "down";
                      } else if (details.delta.dy < 0) {
                        direction = "up";
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 0) {
                        direction = "right";
                      } else if (details.delta.dx < 0) {
                        direction = "left";
                      }
                    },
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: numberOfSquares,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numberInRow,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          if (!mouthClosed && player == index) {
                            return Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow,
                                  )),
                            );
                          } else if (player == index) {
                            if (direction == "right") {
                              return PacmanDude();
                            } else if (direction == "up") {
                              return Transform.rotate(
                                angle: 3 * pi / 2,
                                child: PacmanDude(),
                              );
                            } else if (direction == "left") {
                              return Transform.rotate(
                                angle: pi,
                                child: PacmanDude(),
                              );
                            } else if (direction == "down") {
                              return Transform.rotate(
                                angle: pi / 2,
                                child: PacmanDude(),
                              );
                            }
                          } else if (ghost == index) {
                            return Ghost();
                          } else if (barriers.contains(index)) {
                            return MyBarrier(
                              innerColor: Colors.blue[800],
                              outerColor: Colors.blue[900],
                              //child: Center(child: Text(index.toString(), ),
                            );
                          } else if (food.contains(index) || !gameStarted) {
                            return MyPixel(
                              innerColor: Colors.yellow,
                              outerColor: Colors.black,
                              //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                            );
                          } else {
                            return MyPixel(
                              innerColor: Colors.black,
                              outerColor: Colors.black,
                              //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                            );
                          }
                          return MyPath();
                        }),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Score: $score",
                      style: const TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    GestureDetector(
                      onTap: startGame,
                      child: const Text(
                        "P L A Y",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
