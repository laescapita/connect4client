import 'dart:convert';

class ParseControl {
  //Only parses JSON bodies
  dynamic parseInfo(response) {
    try {
      return json.decode(response.body) as Map;
    } on FormatException {
      print('Invalid URL');
      //return json.decode(defaultUrl.body) as Map;
    }
  }
}
