import 'dart:io';
import 'dart:convert';

class uicontrol {
  //Anything having to do with presentation
  dynamic parseInfo(response) {
    try {
      return json.decode(response.body) as Map;
    } on FormatException {
      print('Invalid URL');
      //return json.decode(defaultUrl.body) as Map;
    }
  }
}
