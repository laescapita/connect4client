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
    //Uses given server to connect to, if null uses default
    dynamic defaultUrl = DEFAULT_URL;
    print('Type in desired server!');
    //Type in: "https://cssrvlab01.utep.edu/Classes/cs3360/laescapita/c4service/src";
    dynamic localUrl = stdin.readLineSync();
    if (localUrl == null) {
      localUrl = defaultUrl;
    }
    return localUrl;
  }

  promptForStrategy(strategyList) {
    //Gives strategy list, and prompts user to choose
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
    //sets board for local use
    this.board = board;
  }

  promptMove() {
    //prompts user to choose column to place chip on
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
    //Shows board
    print("Board will show here");
    board?.showBoard(playerX, playerY, cpuX, cpuY);
  }

  promptWin(move) {
    //If win, prompt who won
    if (move.ack_move.isWin) {
      var winningRow = move.ack_move.row;
      print("Player Win at: $winningRow");
    } else if (move.move.isWin) {
      var winningRow = move.move.row;
      print("CPU Win at: $winningRow");
    } else {
      print("Game Ended in A Tie");
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
    //Uses local board inside class for UI purposes
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

  isBoardFull() {
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 7; j++) {
        if (_board[i][j] == 0) {
          return false;
        }
      }
    }
    return true;
  }

  insertTokens(move, int player) {
    for (int yposition = 5; yposition > -1; yposition--) {
      if (_board[yposition][move] == 0) {
        _board[yposition][move] = player;
        return;
      }
    }
  }
}

class Player {
  final String token;
  Player(this.token);
}
