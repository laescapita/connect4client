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
    var newGame = await web.getNew(url, strategy);
    print('response: ' + newGame.response.toString());
    print('strategy: ' + newGame.strategy);
    print('pid: ' + newGame.pid);
  }
}
