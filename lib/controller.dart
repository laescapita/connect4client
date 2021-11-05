import 'package:c4clientdart/uicontrol.dart';
import 'package:c4clientdart/webcontrol.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class Controller {
  //Controls all aspects of the project
  start() async {
    var ui = UiControl();
    var web = WebControl();
    ui.welcome(); //Welcomes User
    var url = ui.promptForServer(web.DEFAULT_URL); //Prompts User for the server
    print("Connecting to Server...");
    var info = await web.getInfo(url); //Calls getter for info from server
    var strategy =
        ui.promptForStrategy(info.strategies); //Prompts User for strategy
    print("Creating new game...");
    var game =
        await web.getNew(url, strategy); //Calls getter for new game instance
    var board = Board(info.width, info.height);
    //LOOP UNTIL WIN
    ui.setBoard(board);
    var playerWon = false;
    var cpuWon = false;
    var move;
    print(
        "cheat mode activated?"); //Activates Cheat Code, which lets user move cpu chips
    dynamic userChoice = stdin.readLineSync();

    if (userChoice == "yes") {
      //Cheat Mode
      do {
        var columnChosen = ui.promptMove();
        print("Making a move...");
        move = await web.getMove(url, game.pid, columnChosen);

        if (ui.board?.isBoardFull()) {
          //Checks if board is full
          break;
        }

        if (move.ack_move.isWin) {
          //Places chip before game ends
          playerWon = move.ack_move.isWin;
          board.insertTokens(int.parse(move.ack_move.x), 1);

          ui.promptBoard(
              move.ack_move.x, move.ack_move.y, move.move.x, move.move.y);
          break;
        }
        if (move.move.isWin) {
          //Places chip before game ends
          cpuWon = move.move.isWin;
          board.insertTokens(move.move.x, 2);
          ui.promptBoard(
              move.ack_move.x, move.ack_move.y, move.move.x, move.move.y);
          break;
        } else {
          //User moving cpu Chip
          board.insertTokens(int.parse(move.ack_move.x), 1);
          print("CPU old move" + move.move.x.toString());
          print("New cpu move?");
          var cpuNewMove = stdin.readLineSync();
          board.insertTokens(int.parse(cpuNewMove!), 2);
        }
        ui.promptBoard(move.ack_move.x, move.ack_move.y, move.move.x,
            move.move.y); //show board
      } while (playerWon == false && cpuWon == false);

      ui.promptWin(move);
    } else {
      //Normal Game without Cheats
      do {
        var columnChosen = ui.promptMove();
        print("Making a move...");
        move = await web.getMove(url, game.pid, columnChosen);

        if (ui.board?.isBoardFull()) {
          break;
        }

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
