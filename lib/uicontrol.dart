import 'dart:io';
import 'dart:convert';

class UiControl {
  //Anything having to do with presentation

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
}
