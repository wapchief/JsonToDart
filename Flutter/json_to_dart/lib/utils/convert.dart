import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

export 'dart:convert';

Future tryCatch(Function? f) async {
  try {
    await f?.call();
  } catch (e, _) {
    debugPrint('$e');
  }
}

// Future tryCatchLoading(Function? f, {String? status}) async {
//   try {
//     FPLoadingUtil.show(status: status);
//     await f?.call();
//   } finally {
//     FPLoadingUtil.dismiss();
//   }
// }

class FFConvert {
  FFConvert._();

  static T? convert<T extends Object?>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  }
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, _) {
    debugPrint('asT<$T>,error: $e');
    return defaultValue;
  }

  return defaultValue;
}

List<T>? asListT<T extends Object?>(
  dynamic value, {
  T Function(Map<String, dynamic> json)? fromJson,
  bool allowDirty = false,
}) {
  if (value is! List) return null;

  return value.fold<List<T>>([], (list, element) {
    try {
      if (element == null) {
        return list;
      } else {
        final parsedValue = fromJson != null ? fromJson(element) : asT<T>(element);
        if (parsedValue == null && !allowDirty) {
          throw Exception('asListT Parse Error: data: ${jsonEncode(element)}');
        }
        if (parsedValue != null) list.add(parsedValue);
      }
    } catch (_) {
      debugPrint('dirty data found: ${jsonEncode(element)}');
      if (!allowDirty) {
        rethrow;
      }
    }

    return list;
  });
}

T? asEntity<T extends Object?>(
  dynamic value, {
  required T Function(Map json) fromJson,
}) {
  if (value is T) {
    return value;
  }
  if (value is Map) {
    return fromJson(value);
  } else {
    return null;
  }
}

T? fromJsonCache<T extends Object?>(
  String? jsonStr, {
  required T Function(Map json) fromJson,
}) {
  if (jsonStr == null) {
    return null;
  }
  try {
    final obj = json.decode(jsonStr);
    if (obj is Map) {
      return fromJson(obj);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

String? asDateFormat(dynamic value, {String format = 'yyyy/MM/dd'}) {
  DateTime? dateTime = asDateTime(value);
  if (dateTime == null) {
    return null;
  }
  return DateFormat(format).format(dateTime);
}

DateTime? asDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }
  if (value is int) {
    int digit = value.toString().length;
    if (digit != 10 && digit != 13) {
      return null;
    }
    if (digit == 10) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    } else {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
  } else if (value is String) {
    if (RegExp('^[0-9]*\$').hasMatch(value)) {
      int digit = value.length;
      if (digit != 10 && digit != 13) {
        return null;
      }
      int time = int.parse(value);
      if (digit == 10) {
        return DateTime.fromMillisecondsSinceEpoch(time * 1000);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(time);
      }
    } else {
      return DateTime.tryParse(value);
    }
  }
  return null;
}
