class CartData {
  int CartCount;

  CartData({this.CartCount});
}

class SaveDataClass {
  String Message;
  bool IsSuccess;
  String Data;
  bool IsRecord;

  SaveDataClass({this.Message, this.IsSuccess, this.Data, this.IsRecord});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
      Message: json['Message'] as String,
      IsSuccess: json['IsSuccess'] as bool,
      Data: json['Data'] as String,
      IsRecord: json['IsRecord'] as bool,
    );
  }
}

// Local Database Class
class PhotoOpenCountClass {
  String MemberId;
  String PhotoId;
  String Count;

  PhotoOpenCountClass({
    this.MemberId,
    this.PhotoId,
    this.Count,
  });

  String get _MemberId => MemberId;

  String get _PhotoId => PhotoId;

  String get _Count => Count;

  set _MemberId(String newMemberId) {
    this.MemberId = newMemberId;
  }

  set _PhotoId(String newPhotoId) {
    this.PhotoId = newPhotoId;
  }

  set _Count(String newCount) {
    this.Count = newCount;
  }

  //Convert a DBNote Object into a Map Object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['MemberId'] = MemberId;
    map['PhotoId'] = PhotoId;
    map['Count'] = Count;
    return map;
  }

  //Convert a Map Object into a DBNote Object
  PhotoOpenCountClass.fromMapObject(Map<String, dynamic> map) {
    this.MemberId = map["MemberId"];
    this.PhotoId = map["PhotoId"];
    this.Count = map["Count"];
  }

  factory PhotoOpenCountClass.fromJson(Map<String, dynamic> json) {
    return PhotoOpenCountClass(
      MemberId: json['MemberId'] as String,
      PhotoId: json['PhotoId'] as String,
      Count: json['Count'] as String,
    );
  }
}

class categoryClassData {
  String Message;
  bool IsSuccess;
  List<categoryClass> Data;
  categoryClassData({
    this.Message,
    this.IsSuccess,
    this.Data,
  });
  factory categoryClassData.fromJson(Map<String, dynamic> json) {
    return categoryClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data']
            .map<categoryClass>((json) => categoryClass.fromJson(json))
            .toList());
  }
}

class categoryClass {
  String id;
  String name;
  categoryClass({this.id, this.name});
  factory categoryClass.fromJson(Map<String, dynamic> json) {
    return categoryClass(
        id: json['Id'].toString() as String,
        name: json['Name'].toString() as String);
  }

}

class stateClassData {
  String Message;
  bool IsSuccess;
  List<stateClass> Data;

  stateClassData({
    this.Message,
    this.IsSuccess,
    this.Data,
  });

  factory stateClassData.fromJson(Map<String, dynamic> json) {
    return stateClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data']
            .map<stateClass>((json) => stateClass.fromJson(json))
            .toList());
  }
}

class stateClass {
  String id;
  String name;

  stateClass({this.id, this.name});

  factory stateClass.fromJson(Map<String, dynamic> json) {
    return stateClass(
        id: json['Id'].toString() as String,
        name: json['Name'].toString() as String);
  }
}

class cityClassData {
  String Message;
  bool IsSuccess;
  List<cityClass> Data;

  cityClassData({
    this.Message,
    this.IsSuccess,
    this.Data,
  });

  factory cityClassData.fromJson(Map<String, dynamic> json) {
    return cityClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data']
            .map<cityClass>((json) => cityClass.fromJson(json))
            .toList());
  }
}

class cityClass {
  //String id;
  String name;

  cityClass({this.name});

  factory cityClass.fromJson(Map<String, dynamic> json) {
    return cityClass(
        //id: json['Id'].toString() as String,
        name: json['Name'].toString() as String);
  }
}
