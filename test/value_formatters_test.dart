import 'package:nat_tester/value_formatters.dart';
import 'package:stun/stun.dart';
import 'package:test/test.dart';

void main() {
  group('ValueFormatters.formatEnum', () {
    test('formats reachability values with Chinese-first bilingual text', () {
      expect(
        ValueFormatters.formatEnum(NatReachability.reachable),
        '可达 (Reachable)',
      );
      expect(
        ValueFormatters.formatEnum(NatReachability.udpBlocked),
        'UDP 被阻断 (UDP Blocked)',
      );
    });

    test('formats NAT behavior values with technical bilingual labels', () {
      expect(
        ValueFormatters.formatEnum(NatMappingBehavior.endpointIndependent),
        '端点无关型 (Endpoint-Independent)',
      );
      expect(
        ValueFormatters.formatEnum(
          NatFilteringBehavior.addressAndPortDependent,
        ),
        '地址与端口相关型 (Address-and-Port-Dependent)',
      );
    });

    test('formats probe, capability and legacy type values', () {
      expect(
        ValueFormatters.formatEnum(NatProbeStatus.unsupported),
        '无法探测 (Unsupported)',
      );
      expect(
        ValueFormatters.formatEnum(NatCapabilitySupport.unknown),
        '未知 (Unknown)',
      );
      expect(
        ValueFormatters.formatEnum(NatLegacyType.portRestrictedCone),
        '端口受限圆锥型 (Port-Restricted Cone NAT)',
      );
    });

    test('returns placeholder for null enum', () {
      expect(ValueFormatters.formatEnum(null), ValueFormatters.unavailable);
    });
  });

  group('ValueFormatters.formatBool', () {
    test('formats boolean values with bilingual labels', () {
      expect(ValueFormatters.formatBool(true), '是 (Yes)');
      expect(ValueFormatters.formatBool(false), '否 (No)');
      expect(ValueFormatters.formatBool(null), ValueFormatters.unavailable);
    });
  });

  group('ValueFormatters.formatDuration', () {
    test('formats milliseconds, seconds and minutes', () {
      expect(
        ValueFormatters.formatDuration(const Duration(milliseconds: 300)),
        '300 毫秒 (300 ms)',
      );
      expect(
        ValueFormatters.formatDuration(const Duration(seconds: 2)),
        '2 秒 (2 s)',
      );
      expect(
        ValueFormatters.formatDuration(const Duration(minutes: 3)),
        '3 分钟 (3 min)',
      );
    });

    test('formats hour durations', () {
      expect(
        ValueFormatters.formatDuration(const Duration(hours: 1, minutes: 30)),
        '1 小时 30 分钟 (1 h 30 min)',
      );
    });
  });

  group('ValueFormatters validation helpers', () {
    test(
      'requiredServerUri rejects empty values with normalized Chinese text',
      () {
        expect(
          () => ValueFormatters.requiredServerUri('  '),
          throwsA(
            isA<FormatException>().having(
              (FormatException e) => e.message,
              'message',
              'STUN 服务 URI 不能为空。',
            ),
          ),
        );
      },
    );

    test('parseInt rejects invalid values with normalized Chinese text', () {
      expect(
        () => ValueFormatters.parseInt('abc', fieldName: '请求超时'),
        throwsA(
          isA<FormatException>().having(
            (FormatException e) => e.message,
            'message',
            '请求超时 必须为整数。',
          ),
        ),
      );
      expect(
        () => ValueFormatters.parseInt('1', fieldName: '最大重传次数', min: 2),
        throwsA(
          isA<FormatException>().having(
            (FormatException e) => e.message,
            'message',
            '最大重传次数 必须大于或等于 2。',
          ),
        ),
      );
    });
  });
}
