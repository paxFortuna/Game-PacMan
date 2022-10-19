import 'package:flutter/material.dart';
import 'package:game_pacman/pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 17;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: numberInRow),
                  itemBuilder: (context, index) {
                    if (barriers.contains(index)) {
                      // return Padding(
                      //   padding: const EdgeInsets.all(1.0),
                      //   child: Container(
                      //     color: Colors.blue,
                      //     child: Center(child: Text(index.toString())),
                      //   ),
                      // );
                      return MyPixel(
                        color: Colors.blue[900],
                        child: Text(index.toString()),
                      );
                    } else {
                      return MyPixel(
                        color: Colors.black,
                        child: Text(index.toString()),
                      );
                      // return Padding(
                      //   padding: const EdgeInsets.all(1.0),
                      //   child: Container(
                      //     color: Colors.grey,
                      //     child: Center(child: Text(index.toString())),
                      //   ),
                      // );
                    }
                  }),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    "Score: ",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Text(
                    "P L A Y",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
