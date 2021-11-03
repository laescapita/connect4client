// ignore_for_file: unnecessary_this

import 'dart:io';
import 'dart:convert';
import 'package:c4clientdart/parsecontrol.dart';

class UiControl {
  //Anything having to do with presentation
  Board? board;

  welcome() {
    print("Welcome to Connect 4!");
  }

  dynamic promptForServer(DEFAULT_URL) {
    dynamic defaultUrl = DEFAULT_URL;
    print('Type in desired server!');
    //Type in: "https://cssrvlab01.utep.edu/Classes/cs3360/laescapita/c4service/src";
    //Or: "http://www.cs.utep.edu//cheon/cs3360/project/c4"
    dynamic localUrl = stdin.readLineSync();
    if (localUrl == null) {
      localUrl = defaultUrl;
    }
    return localUrl;
  }

  promptForStrategy(strategyList) {
    for (int i = 0; i < strategyList.length; i++) {
      print("$i " + strategyList[i]);
    }
    print('Choose Strategy!');
    dynamic num = stdin.readLineSync();
    var chosenStrategy = strategyList[int.parse(num)];
    print(chosenStrategy);
    return chosenStrategy;
  }

  setBoard(Board board) {
    this.board = board;
  }

  promptMove() {
    int? maxWidth = board?.width;
    bool loop = true;
    dynamic col;
    while (loop) {
      print('Choose a column! [1 - $maxWidth]');
      col = int?.parse(stdin.readLineSync()!);
      if (col > maxWidth || col < 1) {
        print('Invalid Selection: $col');
      } else {
        print('Valid Selection: $col');
        loop = false;
      }
    }
    return col;
  }

  promptBoard(playerX, playerY, cpuX, cpuY) {
    print("Board will show here");
    board?.showBoard(playerX, playerY, cpuX, cpuY);
  }

  promptWin(move) {
    if (move.ack_move.isWin) {
      var winningRow = move.ack_move.row;
      print("Player Win at: $winningRow");
    }
    if (move.move.isWin) {
      var winningRow = move.move.row;
      print("CPU Win at: $winningRow");
    }
  }
}

class Board {
  final int width;
  final int height;
  var player = Player("O");
  var cpu = Player("X");
  Board(this.width, this.height);
  List _board = List<List<int>>.generate(
      6, (i) => List<int>.generate(7, (i) => 0, growable: false),
      growable: false);

  showBoard(playerX, playerY, cpuX, cpuY) {
    print("Player placed Chip in column $playerX and landed in row $playerY");
    print("CPU placed Chip in column $cpuX and landed in row $cpuY");
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 7; j++) {
        if (_board[i][j] == 0) {
          stdout.write('. ');
        } // Empty slot.
        else if (_board[i][j] == 1) {
          stdout.write('O ');
        } // User slot.
        else {
          stdout.write('X ');
        } // Computer slot.
      }
      print('');
    }
    for (var i = 1; i <= 7; i++) {
      stdout.write("$i ");
    }
  }

  insertTokens(int move, int player) {
    for (int yCoordinate = 5; yCoordinate > -1; yCoordinate--) {
      if (_board[yCoordinate][move] == 0) {
        _board[yCoordinate][move] = player;
        return;
      }
    }
  }
}

class Player {
  final String token;
  Player(this.token);
}
