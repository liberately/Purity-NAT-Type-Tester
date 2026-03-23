import 'package:stun/stun.dart';

final class ValueFormatters {
  const ValueFormatters._();

  static const String unavailable = '-';

  static const Map<Type, Map<String, String>> _enumLabels =
      <Type, Map<String, String>>{
        NatReachability: <String, String>{
          'reachable': '可达 (Reachable)',
          'udpBlocked': 'UDP 被阻断 (UDP Blocked)',
          'undetermined': '待判定 (Undetermined)',
        },
        NatMappingBehavior: <String, String>{
          'endpointIndependent': '端点无关型 (Endpoint-Independent)',
          'addressDependent': '地址相关型 (Address-Dependent)',
          'addressAndPortDependent': '地址与端口相关型 (Address-and-Port-Dependent)',
          'unsupported': '服务端不支持 (Unsupported)',
          'undetermined': '待判定 (Undetermined)',
        },
        NatFilteringBehavior: <String, String>{
          'endpointIndependent': '端点无关型 (Endpoint-Independent)',
          'addressDependent': '地址相关型 (Address-Dependent)',
          'addressAndPortDependent': '地址与端口相关型 (Address-and-Port-Dependent)',
          'unsupported': '服务端不支持 (Unsupported)',
          'undetermined': '待判定 (Undetermined)',
        },
        NatProbeStatus: <String, String>{
          'yes': '支持 (Yes)',
          'no': '不支持 (No)',
          'unsupported': '无法探测 (Unsupported)',
          'undetermined': '待判定 (Undetermined)',
        },
        NatCapabilitySupport: <String, String>{
          'supported': '支持 (Supported)',
          'unsupported': '不支持 (Unsupported)',
          'unknown': '未知 (Unknown)',
        },
        NatLegacyType: <String, String>{
          'openInternet': '开放互联网 (Open Internet)',
          'fullCone': '完全圆锥型 (Full Cone NAT)',
          'restrictedCone': '受限圆锥型 (Restricted Cone NAT)',
          'portRestrictedCone': '端口受限圆锥型 (Port-Restricted Cone NAT)',
          'symmetric': '对称型 (Symmetric NAT)',
          'symmetricUdpFirewall': '对称型 UDP 防火墙 (Symmetric UDP Firewall)',
          'udpBlocked': 'UDP 被阻断 (UDP Blocked)',
          'unknown': '未知 (Unknown)',
        },
      };

  static String formatEnum(Enum? value) {
    if (value == null) {
      return unavailable;
    }

    final labels = _enumLabels[value.runtimeType];
    return labels?[value.name] ?? _humanizeEnumName(value.name);
  }

  static String formatBool(bool? value) {
    if (value == null) {
      return unavailable;
    }

    return value ? '是 (Yes)' : '否 (No)';
  }

  static String formatValue(Object? value) => value?.toString() ?? unavailable;

  static String formatDuration(Duration? value) {
    if (value == null) {
      return unavailable;
    }

    if (value.inMilliseconds < 1000) {
      return '${value.inMilliseconds} 毫秒 (${value.inMilliseconds} ms)';
    }
    if (value.inSeconds < 60) {
      return '${value.inSeconds} 秒 (${value.inSeconds} s)';
    }
    if (value.inMinutes < 60) {
      return '${value.inMinutes} 分钟 (${value.inMinutes} min)';
    }

    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    if (minutes == 0) {
      return '$hours 小时 ($hours h)';
    }
    return '$hours 小时 $minutes 分钟 ($hours h $minutes min)';
  }

  static int parseInt(String raw, {required String fieldName, int min = 0}) {
    final value = int.tryParse(raw.trim());
    if (value == null) {
      throw FormatException('$fieldName 必须为整数。');
    }
    if (value < min) {
      throw FormatException('$fieldName 必须大于或等于 $min。');
    }
    return value;
  }

  static String requiredServerUri(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('STUN 服务 URI 不能为空。');
    }
    return trimmed;
  }

  static String? optionalText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String _humanizeEnumName(String raw) {
    final words = raw
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (Match match) => '${match.group(1)} ${match.group(2)}',
        )
        .split(' ')
        .where((String segment) => segment.isNotEmpty)
        .map(
          (String segment) =>
              '${segment[0].toUpperCase()}${segment.substring(1)}',
        )
        .join(' ');

    return '$words ($raw)';
  }
}
