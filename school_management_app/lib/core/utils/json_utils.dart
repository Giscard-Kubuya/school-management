import 'dart:convert';

/// A utility class for handling JSON serialization and deserialization
class JsonUtils {
  /// Safely parses a JSON string into a Map<String, dynamic>
  static Map<String, dynamic>? tryParseJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final decoded = jsonDecode(jsonString);
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } catch (e) {
      return null;
    }
  }

  /// Converts a map to a pretty-printed JSON string
  static String toPrettyJson(Map<String, dynamic> json) {
    return const JsonEncoder.withIndent('  ').convert(json);
  }

  /// Safely gets a value from a map with type checking
  static T? safeGet<T>(
    Map<String, dynamic>? json,
    String key, {
    T? defaultValue,
  }) {
    if (json == null || !json.containsKey(key) || json[key] == null) {
      return defaultValue;
    }

    try {
      final value = json[key];

      // Handle different types
      if (T == String) {
        return (value?.toString() ?? defaultValue) as T?;
      } else if (T == int) {
        return (value is int ? value : int.tryParse(value.toString())) as T? ??
            defaultValue;
      } else if (T == double) {
        return (value is double ? value : double.tryParse(value.toString()))
                as T? ??
            defaultValue;
      } else if (T == bool) {
        if (value is bool) return value as T;
        if (value is String) {
          return (value.toLowerCase() == 'true') as T;
        }
        return (value == 1 || value == '1') as T? ?? defaultValue;
      } else if (T == DateTime) {
        if (value is DateTime) return value as T;
        if (value is String) {
          return DateTime.tryParse(value) as T? ?? defaultValue;
        }
        if (value is int) {
          return DateTime.fromMillisecondsSinceEpoch(value) as T? ??
              defaultValue;
        }
        return defaultValue;
      } else if (T == Map<String, dynamic>) {
        if (value is Map<String, dynamic>) return value as T;
        if (value is Map) {
          return Map<String, dynamic>.from(value) as T;
        }
        return defaultValue;
      } else if (T == List<dynamic>) {
        if (value is List<dynamic>) return value as T;
        if (value is List) {
          return List<dynamic>.from(value) as T;
        }
        return defaultValue;
      } else if (T == List<String>) {
        if (value is List<String>) return value as T;
        if (value is List) {
          try {
            return value.cast<String>().toList() as T;
          } catch (_) {
            return defaultValue;
          }
        }
        return defaultValue;
      } else if (T == List<int>) {
        if (value is List<int>) return value as T;
        if (value is List) {
          try {
            return value.cast<int>().toList() as T;
          } catch (_) {
            return defaultValue;
          }
        }
        return defaultValue;
      } else if (T == List<double>) {
        if (value is List<double>) return value as T;
        if (value is List) {
          try {
            return value.cast<double>().toList() as T;
          } catch (_) {
            return defaultValue;
          }
        }
        return defaultValue;
      } else if (T == List<bool>) {
        if (value is List<bool>) return value as T;
        if (value is List) {
          try {
            return value
                    .map(
                      (e) =>
                          e == true ||
                          e == 1 ||
                          e == '1' ||
                          (e is String && e.toLowerCase() == 'true'),
                    )
                    .toList()
                as T;
          } catch (_) {
            return defaultValue;
          }
        }
        return defaultValue;
      }

      // For other types, try to cast directly
      return value is T ? value : defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Converts a list of objects to a list of maps
  static List<Map<String, dynamic>> toMapList<T>(List<T> items) {
    return items
        .map((item) => _toMap(item))
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  /// Converts an object to a map if it has a toMap() or toJson() method
  static Map<String, dynamic>? _toMap(dynamic item) {
    if (item == null) return null;

    if (item is Map<String, dynamic>) {
      return item;
    }

    // Handle other Map types
    if (item is Map) {
      // Handle any Map type by converting to Map<String, dynamic>
      return Map<String, dynamic>.fromEntries(
        (item as Map).entries.map(
          (e) => MapEntry(
            e.key.toString(),
            e.value is Map ? _toMap(e.value) : e.value,
          ),
        ),
      );
    }

    // Try toMap() method
    try {
      final toMap = item.toMap;
      if (toMap is Function) {
        final result = toMap();
        if (result is Map) {
          return Map<String, dynamic>.from(result);
        }
      }
    } catch (_) {}

    // Try toJson() method
    try {
      final toJson = item.toJson;
      if (toJson is Function) {
        final result = toJson();
        if (result is Map) {
          return Map<String, dynamic>.from(result);
        } else if (result is String) {
          return tryParseJson(result);
        }
      }
    } catch (_) {}

    return null;
  }

  /// Merges two maps recursively
  static Map<String, dynamic> mergeMaps(
    Map<String, dynamic> original,
    Map<String, dynamic> updates, {
    bool recursive = true,
  }) {
    final result = Map<String, dynamic>.from(original);

    updates.forEach((key, value) {
      if (value == null) return;

      if (recursive &&
          value is Map<String, dynamic> &&
          original[key] is Map<String, dynamic>) {
        // If both values are maps, merge them recursively
        result[key] = mergeMaps(
          original[key] as Map<String, dynamic>,
          value,
          recursive: true,
        );
      } else {
        // Otherwise, just update the value
        result[key] = value;
      }
    });

    return result;
  }

  /// Converts a map to a URL-encoded query string
  ///
  /// Example:
  /// ```dart
  /// final params = {
  ///   'name': 'John Doe',
  ///   'age': 30,
  ///   'hobbies': ['reading', 'swimming'],
  ///   'filters': {'active': true, 'verified': true}
  /// };
  /// final query = JsonUtils.toQueryString(params);
  /// // Result: name=John%20Doe&age=30&hobbies=reading&hobbies=swimming&filters.active=true&filters.verified=true
  /// ```
  static String toQueryString(Map<String, dynamic> params) {
    final result = StringBuffer();
    var first = true;

    String encodeComponent(String component) =>
        Uri.encodeComponent(component).replaceAll('+', '%20');

    void addParameter(String key, dynamic value) {
      if (value == null) return;

      if (value is String && value.isEmpty) return;

      void writeParameter(String k, String v) {
        if (!first) {
          result.write('&');
        }
        result
          ..write(encodeComponent(k))
          ..write('=')
          ..write(encodeComponent(v));
        first = false;
      }

      if (value is List) {
        // Handle arrays as repeated parameters
        for (var item in value) {
          if (item != null) {
            writeParameter(key, item.toString());
          }
        }
      } else if (value is Map) {
        // Handle nested objects with dot notation
        for (var entry in value.entries) {
          if (entry.value != null) {
            writeParameter('$key.${entry.key}', entry.value.toString());
          }
        }
      } else {
        // Handle primitive values
        writeParameter(key, value.toString());
      }
    }

    // Process all parameters in a sorted order for consistent output
    final sortedKeys = params.keys.toList()..sort();
    for (var key in sortedKeys) {
      addParameter(key, params[key]);
    }

    return result.toString();
  }

  /// Deep clones a JSON-serializable object
  static T? deepClone<T>(T? value) {
    if (value == null) return null;

    if (value is Map) {
      return _cloneMap(value as Map) as T?;
    } else if (value is List) {
      return _cloneList(value) as T?;
    } else if (value is Set) {
      return value.map((e) => deepClone(e)).toSet() as T;
    } else if (value is DateTime) {
      return DateTime.fromMillisecondsSinceEpoch(value.millisecondsSinceEpoch)
          as T;
    } else if (value is String || value is num || value is bool) {
      return value;
    } else {
      // For other objects, try to serialize and deserialize
      try {
        final json = _toMap(value);
        if (json != null) {
          return json as T;
        }
      } catch (_) {}

      // If we can't clone it, return as is (this is a shallow copy)
      return value;
    }
  }

  static Map<K, V> _cloneMap<K, V>(Map<K, V> map) {
    final result = <K, V>{};
    for (final entry in map.entries) {
      final clonedValue = deepClone(entry.value);
      if (clonedValue != null) {
        result[entry.key] = clonedValue;
      } else if (null is V) {
        // Only add null if the value type V is nullable
        result[entry.key] = null as V;
      }
    }
    return result;
  }

  static List<T> _cloneList<T>(List<T> list) {
    return list.map((e) => deepClone(e) as T).toList();
  }
}
