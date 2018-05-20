
class StripDto {
  String state;
  int length;

  StripDto({this.state, this.length});

  StripDto.fromJson(Map json)
    : state = json['state'],
      length = json['length'];
}

class ModeDto {
  String id;
  String name;
  String description;
  String engine;
  String author;

  Map<String, Map<String, String>> strings;
  Map<String, Map<String, Object>> params;

  dynamic data;

  ModeDto.fromJson(Map json)
    : id = json['id'],
      name = json['name'],
      description = json['description'],
      engine = json['engine'],
      author = json['author'],
      strings = json['strings'],
      params = json['params'],
      data = json['data'];

  void solveStringReferences(String locale) {
    // if no locale is given, just use the first available
    if (locale == null) {
      locale = strings.keys.first;
      // if there are no locale definitions, then use every value literally
      if (locale == null)
        return;
    }

    Map<String, String> lstrs = strings[locale];

    if (name.startsWith('\$') && lstrs.containsKey(name.substring(1)))
      name = lstrs[name.substring(1)];
    
    if (description.startsWith('\$') && 
        lstrs.containsKey(description.substring(1)))
      description = lstrs[description.substring(1)];

    params.forEach((String param, Map<String, Object> props) {
      if (props.containsKey('label') && props['label'] is String &&
          (props['label'] as String).startsWith('\$') &&
          lstrs.containsKey((props['label'] as String).substring(1)))
        props['label'] = lstrs[(props['label'] as String).substring(1)];

      if (props.containsKey('description') && props['description'] is String &&
          (props['description'] as String).startsWith('\$') &&
          lstrs.containsKey((props['description'] as String).substring(1)))
        props['description'] = lstrs[(props['description'] as String).substring(1)];
    });
  }
}

class DeviceDto {
  String name;
  String address;
  int port;

  DeviceDto({this.name, this.address, this.port});
}