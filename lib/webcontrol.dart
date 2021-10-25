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
