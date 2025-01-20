import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: JogoDaVelha(),
  ));
}

class JogoDaVelha extends StatefulWidget {
  const JogoDaVelha({Key? key}) : super(key: key);

  @override
  _JogoDaVelhaState createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  List<String> board = ['', '', '', '', '', '', '', '', ''];
  bool isXTurn = true;
  String winner = '';
  bool isGameOver = false;
  List<List<int>> winningPositions = [];

  void _handleTap(int index) {
    setState(() {
      if (board[index] == '' && !isGameOver) {
        board[index] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == board[pattern[1]] && board[pattern[1]] == board[pattern[2]] && board[pattern[0]] != '') {
        setState(() {
          winner = board[pattern[0]] == 'X' ? 'X' : 'O';
          isGameOver = true;
          winningPositions = [pattern];
        });
        return;
      }
    }

    if (!board.contains('') && winner == '') {
      setState(() {
        winner = 'Empate';
        isGameOver = true;
      });
    }
  }

  void _resetGame() {
    setState(() {
      board = ['', '', '', '', '', '', '', '', ''];
      isXTurn = true;
      winner = '';
      isGameOver = false;
      winningPositions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    double boxSize = MediaQuery.of(context).size.width / 6; // Reduzido em 40%

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogo da Velha"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Jogo da Velha Talento Tech\nCriado por Isabela",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isGameOver
                    ? (winner == 'Empate' ? "Empate!" : "O $winner venceu!")
                    : (isXTurn ? "É a vez do X" : "É a vez do O"),
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
                width: boxSize * 3,
                height: boxSize * 3,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              board[index],
                              style: TextStyle(
                                color: board[index] == 'X' ? Color(0xFF03FF57) : Color(0xFFFF0090),
                                fontSize: boxSize * 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (winningPositions.any((position) => position.contains(index)))
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: CustomPaint(
                                  painter: WinningLinePainter(positions: winningPositions[0]),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _resetGame,
                child: const Text("Reiniciar Jogo"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WinningLinePainter extends CustomPainter {
  final List<int> positions;

  WinningLinePainter({required this.positions});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    double boxSize = size.width / 3;

    double x1 = (positions[0] % 3) * boxSize + boxSize / 2;
    double y1 = (positions[0] ~/ 3) * boxSize + boxSize / 2;
    double x2 = (positions[1] % 3) * boxSize + boxSize / 2;
    double y2 = (positions[1] ~/ 3) * boxSize + boxSize / 2;
    double x3 = (positions[2] % 3) * boxSize + boxSize / 2;
    double y3 = (positions[2] ~/ 3) * boxSize + boxSize / 2;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    canvas.drawLine(Offset(x2, y2), Offset(x3, y3), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
