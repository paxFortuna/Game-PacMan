import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_pacman/pacman.dart';
import 'package:game_pacman/pixel.dart';

import 'barriers.dart';
import 'ghost.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 17;

  int player = 166;
  int ghost = -1;
  bool mouthClosed = true;
  int score = 0;

  List<int> barriers = [
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
    88,
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
    98,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
  ];

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
    print(MediaQuery.of(context).size.width);
    moveGhost();
    gameStarted = true;
    getFood();
    Duration duration = const Duration(milliseconds: 120);
    Timer.periodic(duration, (timer) {
      if (food.contains(player)) {
        food.remove(player);
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

  void moveRight() {
    setState(() {
      if (!barriers.contains(player + 1)) {
        player += 1;
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

  void moveLeft() {
    setState(() {
      if (!barriers.contains(player - 1)) {
        player -= 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            children: [
              Container(
                height: 35,
                child: GestureDetector(
                  onTap: startGame,
                  child: Text(
                    "P L A Y",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Expanded(
                // flex: 5,
                child: Container(
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
                    child: Container(
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: numberOfSquares,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: numberInRow),
                          itemBuilder: (BuildContext context, int index) {
                            if (player == index) {
                              if (!mouthClosed) {
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow,
                                      )),
                                );
                              } else {
                                if (direction == "right") {
                                  return PacmanDude();
                                } else if (direction == "up") {
                                  return Transform.rotate(
                                      angle: 3 * pi / 2, child: PacmanDude());
                                } else if (direction == "left") {
                                  return Transform.rotate(
                                      angle: pi, child: PacmanDude());
                                } else if (direction == "down") {
                                  return Transform.rotate(
                                      angle: pi / 2, child: PacmanDude());
                                }
                              }
                            } else if (ghost == index) {
                              return Ghost();
                            } else if (barriers.contains(index)) {
                              return MyBarrier(
                                innerColor: Colors.blue[800],
                                outerColor: Colors.blue[900],
                                //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
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
                            return Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow,
                                  )),
                            );
                          }),
                    ),
                  ),
                ),
              ),

        ],
      ),
    ),
    ),
    );
  }

}