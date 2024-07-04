import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_to_dart/utils/convert.dart';

class Root {
  Root({
    this.locationKey,
    this.remark,
    this.optionList,
    this.optionInts,
    this.optionStrs,
  });

  factory Root.fromJson(Map<String, dynamic> json) => Root(
    locationKey: asT<String?>(json['locationKey']),
    remark: asT<String?>(json['remark']),
    optionList: asListT<OptionList>(json['optionList'],
        fromJson: (Map<String, dynamic> item) => OptionList.fromJson(item)),
    optionInts: asListT<int>(json['optionInts']),
    optionStrs: asListT<String>(json['optionStrs']),
  );
  String? locationKey;
  String? remark;
  List<OptionList>? optionList;
  List<int>? optionInts;
  List<String>? optionStrs;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'locationKey': locationKey,
    'remark': remark,
    'optionList': optionList,
    'optionInts': optionInts,
    'optionStrs': optionStrs,
  };
}

class OptionList {
  OptionList({
    this.name,
    this.defaultFlag,
    this.key,
    this.orderNum,
  });

  factory OptionList.fromJson(Map<String, dynamic> json) => OptionList(
    name: asT<String?>(json['name']),
    defaultFlag: asT<int?>(json['defaultFlag']),
    key: asT<String?>(json['key']),
    orderNum: asT<int?>(json['orderNum']),
  );

  String? name;
  int? defaultFlag;
  String? key;
  int? orderNum;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'defaultFlag': defaultFlag,
    'key': key,
    'orderNum': orderNum,
  };
}


void main(){
  var json = {
    "locationKey": "radio_1719370123817",
    "remark": "",
    "optionList": [
      {
        "name": "A. 医生 ",
        "defaultFlag": 0,
        "key": "M_1719370322974",
        "orderNum": 1
      }
    ],
    "optionInts": [
      1,
      2,
      3
    ],
    "optionStrs": [
      "a"
    ]
  };

  final Root root = Root.fromJson(json);
  debugPrint('-----root${root.optionList?.length}');
  debugPrint('-----root${root.optionInts?.length}');
  debugPrint('-----root${root.optionStrs?.length}');
}