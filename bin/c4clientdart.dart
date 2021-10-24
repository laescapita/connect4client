import 'package:c4clientdart/uicontrol.dart';
import 'package:c4clientdart/webcontrol.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main(List<String> arguments) async {
  print('Welcome to Connect 4!');
  print('Type in desired server!');
  var defaultUrl = Uri.parse(
      "http://www.cs.utep.edu//cheon/cs3360/project/c4"); //Does not work for now
  // var localUrl =
  //     "https://cssrvlab01.utep.edu/Classes/cs3360/laescapita/c4service/src";
  dynamic localUrl = stdin.readLineSync();
  var ui = uicontrol();
  var web = webcontrol();
  var infoList = [];
  // var serverUrl =
  //     ui.connectServer(defaultUri);
  Uri infoUrl = Uri.parse(localUrl + '/info');
  try {
    var response = await http.get(infoUrl);
    Map parsedInfo = ui.parseInfo(response);

    var strategyList = parsedInfo['strategies'] as List;

    for (int i = 0; i < strategyList.length; i++) {
      print("$i " + strategyList[i]);
      infoList.add(strategyList[i]);
    }
  } catch (e) {
    print(e);
  }

  print('Choose your difficulty! Enter the corresponding number:');
  dynamic strategySelection = stdin.readLineSync();
  var chosenStrategy = infoList[int.parse(strategySelection)];
  // try {
  //   var chosenStrategy = infoList[strategySelection];
  // } catch (e) {
  //   print(e);
  // }
  print(chosenStrategy);

  Uri newUrl = Uri.parse(localUrl + '/new?strategy=$chosenStrategy');
  try {
    var response = await http.get(newUrl);
    Map parsedNew = ui.parseInfo(response);
    print(parsedNew);
  } catch (e) {
    print(e);
  }

  //var defaultResponse = await http.get(defaultUrl + 'info');
}
