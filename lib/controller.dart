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
    var playerWon = false;
    var cpuWon = false;
    var move;
    print("cheat mode activated?");
    dynamic userChoice = stdin.readLineSync();

    if (userChoice == "yes") {
      do {
        var columnChosen = ui.promptMove();
        print("Making a move...");
        move = await web.getMove(url, game.pid, columnChosen);

        if (move.ack_move.isWin) {
          playerWon = move.ack_move.isWin;
          board.insertTokens(int.parse(move.ack_move.x), 1);

          ui.promptBoard(
              move.ack_move.x, move.ack_move.y, move.move.x, move.move.y);
          break;
        }
        if (move.move.isWin) {
          cpuWon = move.move.isWin;
          board.insertTokens(move.move.x, 2);
          ui.promptBoard(
              move.ack_move.x, move.ack_move.y, move.move.x, move.move.y);
          break;
        } else {
          board.insertTokens(int.parse(move.ack_move.x), 1);
          print("CPU old move" + move.move.x.toString());
          print("New cpu move?");
          var cpuNewMove = stdin.readLineSync();
          board.insertTokens(int.parse(cpuNewMove!), 2);
        }
        ui.promptBoard(
            move.ack_move.x, move.ack_move.y, move.move.x, move.move.y);
      } while (playerWon == false && cpuWon == false);

      ui.promptWin(move);
    } else {
      do {
        var columnChosen = ui.promptMove();
        print("Making a move...");
        move = await web.getMove(url, game.pid, columnChosen);

        if (ui.board?.isBoardFull()) {
          playerWon = true;
          cpuWon = true;
          break;
        }

        if (move.ack_move.isWin) {
          playerWon = move.ack_move.isWin;
          board.insertTokens(int.parse(move.ack_move.x), 1);

          ui.promptBoard(
              move.ack_move.x, move.ack_move.y, move.move.x, move.move.y);
          break;
        }
        if (move.move.isWin) {
          cpuWon = move.move.isWin;
          board.insertTokens(move.move.x, 2);
          ui.promptBoard(
              move.ack_move.x, move.ack_move.y, move.move.x, move.move.y);
          break;
        } else {
          board.insertTokens(int.parse(move.ack_move.x), 1);
          board.insertTokens(move.move.x, 2);
        }
        ui.promptBoard(
            move.ack_move.x, move.ack_move.y, move.move.x, move.move.y);
      } while (playerWon == false && cpuWon == false);

      ui.promptWin(move);
    }
  }
}
