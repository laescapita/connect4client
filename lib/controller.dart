import 'package:c4clientdart/uicontrol.dart';
import 'package:c4clientdart/webcontrol.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class Controller {
  //Controls all aspects of the project
  start() async {
    var ui = UiControl();
    var web = WebControl();
    ui.welcome();
    var url = ui.promptForServer(web.DEFAULT_URL);
    print("Connecting to Server...");
    var info = await web.getInfo(url);
    var strategy = ui.promptForStrategy(info.strategies);
    print("Creating new game...");
    var game = await web.getNew(url, strategy);
    // print('response: ' + newGame.response.toString());
    // print('strategy: ' + newGame.strategy);
    // print('pid: ' + newGame.pid);
    var board = Board(info.width, info.height);
    //LOOP UNTIL WIN
    ui.setBoard(board);
    var anyWon = false;
    do {
      var columnChosen = ui.promptMove();
      print("Making a move...");
      var move = await web.getMove(url, game.pid, columnChosen);
      if (move.ack_move.isWin) {
        anyWon = move.ack_move.isWin;
      }
      if (move.move.isWin) {
        anyWon = move.move.isWin;
      }
      ui.promptBoard(
          move.ack_move.x, move.ack_move.y, move.move.x, move.move.y);
    } while (anyWon == false);
  }
}
