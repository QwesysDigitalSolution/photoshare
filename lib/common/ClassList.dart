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
