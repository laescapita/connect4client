import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:c4clientdart/parsecontrol.dart';

class WebControl {
  //Anything to do with connecting to a server
  dynamic DEFAULT_URL = Uri.parse(
      "http://www.cs.utep.edu//cheon/cs3360/project/c4"); //Does not work for now
  var parse = ParseControl();

  getInfo(dynamic url) async {
    var response;
    var info;
    Uri infoUrl = Uri.parse(url + '/info');
    try {
      response = await http.get(infoUrl);
      Map parsedInfo = parse.parseInfo(response);
      var strategyList = parsedInfo['strategies'] as List;
      var width = parsedInfo['width'] as int;
      var height = parsedInfo['height'] as int;
      info = new Info(width, height, strategyList);
      return info;
    } catch (e) {
      print(e);
    }
  }

  getNew(dynamic url, dynamic strategy) async {
    Uri newUrl = Uri.parse(url + '/new?strategy=$strategy');
    try {
      var response = await http.get(newUrl);
      Map parsedNew = parse.parseInfo(response);
      var responseBool = parsedNew['response'] as bool;
      var strategyChosen = parsedNew['reason'] as String;
      var pid = parsedNew['pid'] as String;
      var newGame = new NewGame(responseBool, strategyChosen, pid);
      return newGame;
    } catch (e) {
      print(e);
    }
  }

  getMove(dynamic url, dynamic pid, int columnChosen) async {
    Uri newUrl = Uri.parse(url + '/play?pid=$pid&move=$columnChosen');
    try {
      var response = await http.get(newUrl);
      Map parsedMove = parse.parseInfo(response);
      var responseBool = parsedMove['response'] as bool;
      var ack_move = parsedMove['ack_move'] as Map;
      var playerMove = new PlayerMove(ack_move["x"], ack_move["y"],
          ack_move["isWin"], ack_move["isDraw"], ack_move["row"]);
      var move = parsedMove['move'] as Map;
      var cpuMove = new PlayerMove(
          move["x"], move["y"], move["isWin"], move["isDraw"], move["row"]);
      var newMove = new Move(responseBool, playerMove, cpuMove);

      return newMove; //CREATE MOVE CLASS AND MOLD IT TO THAT
    } catch (e) {
      print(e);
    }
  }
}

class Info {
  final width;
  final height;
  final strategies;
  Info(this.width, this.height, this.strategies);
}

class NewGame {
  final response;
  final strategy;
  final pid;
  NewGame(this.response, this.strategy, this.pid);
}

class Move {
  final response;
  final PlayerMove ack_move;
  final PlayerMove move;
  Move(this.response, this.ack_move, this.move);
}

class PlayerMove {
  final x;
  final y;
  final isWin;
  final isDraw;
  final row;
  PlayerMove(this.x, this.y, this.isWin, this.isDraw, this.row);
}
