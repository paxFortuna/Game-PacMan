import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_pacman/player.dart';
import 'package:game_pacman/path.dart';
import 'package:game_pacman/pixel.dart';

import 'barriers.dart';
import 'ghost.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberOfSquares = numberInRow * 17;
  static int numberInRow = 11;

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
    147,
    148,
    149,
    158,
    160
  ];

  int player = numberInRow * 15 + 1; // 166;
  int ghost = -1;
  bool preGame = true;
  bool mouthClosed = false;
  int score = 0;

  List<int> food = [];

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  bool gameStarted = false;
  String direction = "right"; // default 방향

  void startGame() {
    // print(MediaQuery.of(context).size.width);
    preGame = false;
    moveGhost();
    gameStarted = true;
    getFood();

    //Duration duration = const Duration(milliseconds: 120);

    Timer.periodic(const Duration(milliseconds: 150), (timer) {

      // pacman 입 동작
      setState(() {
        mouthClosed = !mouthClosed;
      });

      // packman이 음식 사라지고, 점수 추가하기
      if (food.contains(player)) {
        food.remove(player);
        score++;
      }

      if (player == ghost) {
        ghost = -1;
      }

      // 이동 방향
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

      // 벽이 없을 때 이동
      if (!barriers.contains(player + 1)) {
        setState(() {
          player++;
        });
      }


    });
  }

  // pack 우로 이동
  void moveRight() {
    setState(() {
      if (!barriers.contains(player + 1)) {
        player++;
      }
    });
  }
  // pack 좌로 이동
  void moveLeft() {
    setState(() {
      if (!barriers.contains(player - 1)) {
        player--;
      }
    });
  }
  // pack 위로 이동
  void moveUp() {
    setState(() {
      if (!barriers.contains(player - numberInRow)) {
        player -= numberInRow;
      }
    });
  }
  // pack 아래로 이동
  void moveDown() {
    setState(() {
      if (!barriers.contains(player + numberInRow)) {
        player += numberInRow;
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
                padding: const EdgeInsets.only(top: 20),
                //color: Colors.green,
                height: 45,
                child: Text(
                  "P A C K  M A N",
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 30,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: GestureDetector(
                    // pacman이 세로 벽에 부딪혔을 때 반응
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > 0) {
                        direction = "down";
                      } else if (details.delta.dy < 0) {
                        direction = "up";
                      }
                      print(direction);
                    },
                    // pacman이 가로 벽에 부딪혔을 때 반응
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
                            crossAxisCount: numberInRow),

                        itemBuilder: (BuildContext context, int index) {
                          if(mouthClosed && player == index){
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          }
                          else if (player == index) {
                            switch(direction) {
                              case "left":
                                return Transform.rotate(
                                  angle: pi,
                                  child: MyPlayer(),);
                              case "right":
                                return MyPlayer();
                              case "up":
                                return Transform.rotate(
                                  angle: 3 * pi / 2,
                                  child: MyPlayer(),
                                );
                              case "down":
                                return Transform.rotate(
                                  angle: pi / 2,
                                  child: MyPlayer(),
                                );
                              default: return MyPlayer();
                            }

                             // if (direction == "right") {
                             //    return MyPlayer();
                             //  } else if (direction == "up") {
                             //    return Transform.rotate(
                             //      angle: 3 * pi / 2,
                             //      child: MyPlayer(),
                             //    );
                             //  } else if (direction == "left") {
                             //    return Transform.rotate(
                             //      angle: pi,
                             //      child: MyPlayer(),
                             //    );
                             //  } else if (direction == "down") {
                             //    return Transform.rotate(
                             //      angle: pi / 2,
                             //      child: MyPlayer(),
                             //    );
                             //  }
                            // }
                          // } else if (ghost == index) {
                          //   return Ghost();
                          } else if (barriers.contains(index)) {
                            return MyPixel(
                              innerColor: Colors.blue[800],
                              outerColor: Colors.blue[900],
                              //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                            );
                          } else if (food.contains(index) || !gameStarted) {
                            return MyPath(
                              innerColor: Colors.yellow,
                              outerColor: Colors.black,
                              //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                            );
                          } else {
                            return MyPath(
                              innerColor: Colors.yellow,
                              outerColor: Colors.black,
                              //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                            );
                          }
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
                      style:
                          const TextStyle(color: Colors.white, fontSize: 40),
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
