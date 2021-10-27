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
    return chosenStrategy;
  }

  setBoard(Board board) {
    this.board = board;
  }

  promptMove() {
    int? maxWidth = board?.width;
    print('Choose a column! [1 - $maxWidth]');
    dynamic col = int?.parse(stdin.readLineSync()!);
    if (col > maxWidth || col < 1) {
      print('Invalid Selection: $col');
    } else {
      print('Valid Selection: $col');
      //CALL WEB TO MAKE A MOVE
    }
  }
}

class Board {
  final int width;
  final int height;
  Board(this.width, this.height);
}
