import 'dart:io';
import 'dart:async';
import 'dart:convert';

import '../shared/dtos.dart';

class DeviceService {
  static const int defaultStrip = 0;

  String name;
  String host;
  int port;
  int strip;

  HttpClient _httpClient = HttpClient();

  DeviceService(this.name, this.host, this.port);

  Future<List<ModeDto>> getModes() {
    return _httpClient.get(host, port, "/modes")
        .then((HttpClientRequest request) {
          return request.close();})
        .then((HttpClientResponse response) {
          if (response.statusCode != 200)
            return null;

          response.transform(utf8.decoder).listen((String data) {
            List<Map> result = json.decode(data);
            return result.map((Map m) => new ModeDto.fromJson(m));
          });
    });
  }

  Future<StripDto> getStrip({int strip = defaultStrip}) {
    return _httpClient.get(host, port, "/strip/$strip")
        .then((HttpClientRequest request) {
          return request.close();})
        .then((HttpClientResponse response) {
      if (response.statusCode != 200)
        return null;

      response.transform(utf8.decoder).listen((String data) {
        Map result = json.decode(data);
        StripDto strip = new StripDto.fromJson(result);
        return strip;
      });
    });
  }

  Future<Iterable<StripDto>> getStrips() {
    return _httpClient.get(host, port, "/strip")
        .then((HttpClientRequest request) {
          return request.close();})
        .then((HttpClientResponse response) {
      if (response.statusCode != 200)
        return null;

      response.transform(utf8.decoder).listen((String data) {
        List<Map> result = json.decode(data);
        return result.map((Map m) =>
        new StripDto.fromJson(m));
      });
    });
  }


}
