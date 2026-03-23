import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nat_tester/value_formatters.dart';
import 'package:nat_tester/widgets/editable_combo_action_tile.dart';
import 'package:nat_tester/widgets/expander_section.dart';
import 'package:nat_tester/widgets/number_field_tile.dart';
import 'package:nat_tester/widgets/read_only_value_tile.dart';
import 'package:nat_tester/widgets/switch_tile.dart';
import 'package:nat_tester/widgets/text_field_tile.dart';
import 'package:stun/stun.dart';

class NatDiagnosticsPage extends HookWidget {
  static const int _maxLogEntries = 200;

  const NatDiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final serverUri = useState<String>('stun:stun.hot-chilli.net:3478');
    final localIp = useState<String>('');
    final localPort = useState<int>(0);
    final initialRtoMs = useState<int>(200);
    final maxRetransmissions = useState<int>(2);
    final responseTimeoutMultiplier = useState<int>(2);
    final requestTimeoutMs = useState<int>(1000);
    final initialBindingLifetimeProbeMs = useState<int>(300);
    final maxBindingLifetimeProbeMs = useState<int>(1000);
    final bindingLifetimePrecisionMs = useState<int>(200);
    final fragmentPaddingBytes = useState<int>(1024);
    final includeFingerprint = useState<bool>(true);
    final software = useState<String>('');
    final isLoading = useState<bool>(false);
    final report = useState<NatBehaviorReport?>(null);
    final errorMessage = useState<String?>(null);
    final logEntries = useState<List<String>>(const <String>[]);
    final warnings = report.value?.warnings ?? const <String>[];

    useEffect(() {
      return () {
        StunLog.logger = null;
      };
    }, const <Object>[]);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ScrollConfiguration(
          behavior: const FluentScrollBehavior(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  EditableComboActionTile(
                    icon: FluentIcons.server,
                    title: '目标 STUN 服务 URI (STUN Server URI)',
                    description: '选择或输入本次 NAT 探测要连接的 STUN 服务端点。',
                    options: const <String>[
                      'stun:stun.hot-chilli.net:3478',
                      'stun:stun.l.google.com:19302',
                      'stun:stun.cloudflare.com:3478',
                      'stun:global.stun.twilio.com:3478',
                      'stun:stun.nextcloud.com:443',
                      'stun:stun.sipgate.net:3478',
                      'stun:stun.ekiga.net:3478',
                      'stun:stun.ideasip.com:3478',
                      'stun:stun.callwithus.com:3478',
                      'stun:stun.voipbuster.com:3478',
                      'stun:stun.voiparound.com:3478',
                      'stun:stun.voipstunt.com:3478',
                      'stun:stun.counterpath.com:3478',
                      'stun:stun.internetcalls.com:3478',
                      'stun:stun.freeswitch.org:3478',
                    ],
                    value: serverUri.value,
                    onChanged: (String value) {
                      serverUri.value = value;
                    },
                    buttonText: isLoading.value
                        ? '执行中... (Running...)'
                        : '开始执行 (Run)',
                    onPressed: isLoading.value
                        ? null
                        : () async {
                            errorMessage.value = null;
                            report.value = null;
                            logEntries.value = const <String>[];
                            isLoading.value = true;
                            StunLog.logger = (StunLogEvent event) {
                              logEntries.value = _appendLogEntry(
                                logEntries.value,
                                _formatLogEntry(event),
                              );
                            };

                            try {
                              final detector = NatDetector.fromUri(
                                serverUri.value,
                                localIp: localIp.value.isEmpty
                                    ? null
                                    : localIp.value,
                                localPort: localPort.value,
                                initialRto: Duration(
                                  milliseconds: initialRtoMs.value,
                                ),
                                maxRetransmissions: maxRetransmissions.value,
                                responseTimeoutMultiplier:
                                    responseTimeoutMultiplier.value,
                                requestTimeout: Duration(
                                  milliseconds: requestTimeoutMs.value,
                                ),
                                initialBindingLifetimeProbe: Duration(
                                  milliseconds:
                                      initialBindingLifetimeProbeMs.value,
                                ),
                                maxBindingLifetimeProbe: Duration(
                                  milliseconds: maxBindingLifetimeProbeMs.value,
                                ),
                                bindingLifetimePrecision: Duration(
                                  milliseconds:
                                      bindingLifetimePrecisionMs.value,
                                ),
                                fragmentPaddingBytes:
                                    fragmentPaddingBytes.value,
                                includeFingerprint: includeFingerprint.value,
                                software: software.value.isEmpty
                                    ? null
                                    : software.value,
                              );
                              final result = await detector.detect();
                              if (!context.mounted) {
                                return;
                              }
                              report.value = result;
                            } catch (error) {
                              if (!context.mounted) {
                                return;
                              }
                              errorMessage.value = error.toString();
                            } finally {
                              StunLog.logger = null;
                              if (context.mounted) {
                                isLoading.value = false;
                              }
                            }
                          },
                  ),
                  ExpanderSection(
                    title: '高级参数 (Advanced Settings)',
                    children: <Widget>[
                      TextFieldTile(
                        icon: FluentIcons.input_address,
                        title: '本地绑定 IP 地址 (Local Bind IP)',
                        description: '指定 UDP socket 绑定的本地地址；多网卡场景下可用于固定出口接口。',
                        placeholder: '',
                        value: localIp.value,
                        onChanged: (String value) {
                          localIp.value = value;
                        },
                      ),
                      NumberFieldTile(
                        icon: FluentIcons.plug_connected,
                        title: '本地绑定端口 (Local Bind Port)',
                        description: '设置为 0 时由系统自动分配可用端口。',
                        placeholder: 0,
                        value: localPort.value,
                        onChanged: (int value) {
                          localPort.value = value;
                        },
                      ),
                      NumberFieldTile(
                        icon: FluentIcons.clock,
                        title: '初始重传超时 (Initial RTO)',
                        description: '单位为毫秒，用于控制首次 UDP 重传窗口。',
                        placeholder: 200,
                        value: initialRtoMs.value,
                        onChanged: (int value) {
                          initialRtoMs.value = value;
                        },
                      ),
                      NumberFieldTile(
                        icon: FluentIcons.sync,
                        title: '最大重传次数 (Max Retransmissions)',
                        description: '控制单次探测在超时前允许执行的最大重传次数。',
                        placeholder: 2,
                        value: maxRetransmissions.value,
                        onChanged: (int value) {
                          maxRetransmissions.value = value;
                        },
                      ),
                      NumberFieldTile(
                        icon: FluentIcons.timer,
                        title: '请求超时 (Request Timeout)',
                        description: '单位为毫秒，控制单次探测请求的总等待时间。',
                        placeholder: 1000,
                        value: requestTimeoutMs.value,
                        onChanged: (int value) {
                          requestTimeoutMs.value = value;
                        },
                      ),
                      NumberFieldTile(
                        icon: FluentIcons.calculator_percentage,
                        title: '响应超时倍数 (Response Timeout Multiplier)',
                        description: '用于计算 UDP 请求周期的等待上限。',
                        placeholder: 2,
                        value: responseTimeoutMultiplier.value,
                        onChanged: (int value) {
                          responseTimeoutMultiplier.value = value;
                        },
                      ),
                      NumberFieldTile(
                        icon: FluentIcons.alarm_clock,
                        title: '映射存活探测初始间隔 (Initial Binding Lifetime Probe)',
                        description: '单位为毫秒，用于第一次 Binding Lifetime 探测。',
                        placeholder: 300,
                        value: initialBindingLifetimeProbeMs.value,
                        onChanged: (int value) {
                          initialBindingLifetimeProbeMs.value = value;
                        },
                      ),
                      NumberFieldTile(
                        icon: FluentIcons.full_history,
                        title: '映射存活探测上限 (Max Binding Lifetime Probe)',
                        description: '单位为毫秒，决定 Binding Lifetime 探测窗口上限。',
                        placeholder: 1000,
                        value: maxBindingLifetimeProbeMs.value,
                        onChanged: (int value) {
                          maxBindingLifetimeProbeMs.value = value;
                        },
                      ),
                      NumberFieldTile(
                        icon: FluentIcons.skype_clock,
                        title: '映射存活探测精度 (Binding Lifetime Precision)',
                        description: '单位为毫秒，用于二分逼近生命周期估计值。',
                        placeholder: 200,
                        value: bindingLifetimePrecisionMs.value,
                        onChanged: (int value) {
                          bindingLifetimePrecisionMs.value = value;
                        },
                      ),
                      NumberFieldTile(
                        icon: FluentIcons.cube_shape,
                        title: '分片探测填充字节数 (Fragment Padding Bytes)',
                        description: '用于测试较大 UDP 报文的分片处理能力。',
                        placeholder: 1024,
                        value: fragmentPaddingBytes.value,
                        onChanged: (int value) {
                          fragmentPaddingBytes.value = value;
                        },
                      ),
                      SwitchTile(
                        icon: FluentIcons.fingerprint,
                        title: '包含指纹属性 (Include Fingerprint)',
                        description: '在 STUN 请求末尾附加 FINGERPRINT 属性。',
                        value: includeFingerprint.value,
                        onChanged: (bool value) {
                          includeFingerprint.value = value;
                        },
                      ),
                      TextFieldTile(
                        icon: FluentIcons.code,
                        title: '客户端软件标识 (SOFTWARE Attribute)',
                        description: '写入 STUN SOFTWARE 属性，便于服务端或日志侧识别客户端实现来源。',
                        placeholder: '',
                        value: software.value,
                        onChanged: (String value) {
                          software.value = value;
                        },
                      ),
                    ],
                  ),
                  ExpanderSection(
                    title: '探测结果 (Detection Results)',
                    initiallyExpanded: true,
                    children: <Widget>[
                      ReadOnlyValueTile(
                        '可达性 (Reachability)',
                        ValueFormatters.formatEnum(report.value?.reachability),
                        icon: FluentIcons.my_network,
                        description: '表示当前网络是否能与 STUN 服务端完成基本 UDP 通信。',
                      ),
                      ReadOnlyValueTile(
                        '是否存在 NAT 映射 (NAT Present)',
                        ValueFormatters.formatBool(report.value?.isNatted),
                        icon: WindowsIcons.gateway_router,
                        description: '根据本地地址与公网映射结果判断是否经过 NAT 转换。',
                      ),
                      ReadOnlyValueTile(
                        '映射行为 (Mapping Behavior)',
                        ValueFormatters.formatEnum(
                          report.value?.mappingBehavior,
                        ),
                        icon: FluentIcons.process_map,
                        description: '反映 NAT 对不同目标地址是否会复用相同的外部映射端口。',
                      ),
                      ReadOnlyValueTile(
                        '过滤行为 (Filtering Behavior)',
                        ValueFormatters.formatEnum(
                          report.value?.filteringBehavior,
                        ),
                        icon: FluentIcons.filter,
                        description: '反映 NAT/FW 对外部来包的接收条件严格程度。',
                      ),
                      ReadOnlyValueTile(
                        '传统 NAT 类型 (Legacy NAT Type)',
                        ValueFormatters.formatEnum(report.value?.legacyNatType),
                        icon: FluentIcons.tag,
                        description: '将多项探测结果映射为传统 STUN/NAT 分类名称。',
                      ),
                      ReadOnlyValueTile(
                        '本地地址 (Local Address)',
                        ValueFormatters.formatValue(report.value?.localAddress),
                        icon: FluentIcons.map_pin,
                        description: '发起探测时本地 UDP socket 使用的 IP 和端口。',
                      ),
                      ReadOnlyValueTile(
                        '公网映射地址 (Mapped Address)',
                        ValueFormatters.formatValue(
                          report.value?.mappedAddress,
                        ),
                        icon: FluentIcons.globe,
                        description: 'STUN 服务端观察到的公网源地址，即外部映射结果。',
                      ),
                      ReadOnlyValueTile(
                        'STUN 服务端点 (Server Endpoint)',
                        ValueFormatters.formatValue(
                          report.value?.serverEndpoint,
                        ),
                        icon: FluentIcons.azure_service_endpoint,
                        description: '本次实际响应探测请求的 STUN 服务端地址。',
                      ),
                    ],
                  ),
                  ExpanderSection(
                    title: '扩展能力 (Extended Diagnostics)',
                    children: <Widget>[
                      ReadOnlyValueTile(
                        '映射存活时间估计 (Binding Lifetime Estimate)',
                        ValueFormatters.formatDuration(
                          report.value?.bindingLifetimeEstimate,
                        ),
                        icon: FluentIcons.history,
                        description: '估算 NAT 映射在无活动情况下可保持多久。',
                      ),
                      ReadOnlyValueTile(
                        '回环支持 (Hairpinning)',
                        ValueFormatters.formatEnum(report.value?.hairpinning),
                        icon: FluentIcons.progress_loop_outer,
                        description: '反映局域网内设备能否通过公网映射地址回访自身。',
                      ),
                      ReadOnlyValueTile(
                        '分片处理能力 (Fragment Handling)',
                        ValueFormatters.formatEnum(
                          report.value?.fragmentHandling,
                        ),
                        icon: FluentIcons.cube_shape,
                        description: '测试路径对较大 UDP 报文及 IP 分片的处理表现。',
                      ),
                      ReadOnlyValueTile(
                        'ALG 检测结果 (ALG Detected)',
                        ValueFormatters.formatBool(report.value?.algDetected),
                        icon: FluentIcons.shield,
                        description: '判断中间设备是否可能对报文内容或地址进行了 ALG 干预。',
                      ),
                    ],
                  ),
                  ExpanderSection(
                    title: '服务端能力 (Server Capabilities)',
                    children: <Widget>[
                      ReadOnlyValueTile(
                        'OTHER-ADDRESS 支持 (OTHER-ADDRESS)',
                        ValueFormatters.formatEnum(
                          report.value?.serverCapabilities.otherAddress,
                        ),
                        icon: FluentIcons.add_link,
                        description: '表示服务端是否能在响应中提供备选的地址/端口信息。',
                      ),
                      ReadOnlyValueTile(
                        'RESPONSE-ORIGIN 支持 (RESPONSE-ORIGIN)',
                        ValueFormatters.formatEnum(
                          report.value?.serverCapabilities.responseOrigin,
                        ),
                        icon: FluentIcons.link,
                        description: '表示服务端是否会显式声明响应来自的源端点。',
                      ),
                      ReadOnlyValueTile(
                        'CHANGE-REQUEST 支持 (CHANGE-REQUEST)',
                        ValueFormatters.formatEnum(
                          report.value?.serverCapabilities.changeRequest,
                        ),
                        icon: FluentIcons.switcher_start_end,
                        description: '表示服务端是否支持根据 CHANGE-REQUEST 切换响应地址或端口。',
                      ),
                      ReadOnlyValueTile(
                        'RESPONSE-PORT 支持 (RESPONSE-PORT)',
                        ValueFormatters.formatEnum(
                          report.value?.serverCapabilities.responsePort,
                        ),
                        icon: FluentIcons.plug,
                        description: '表示服务端是否支持将响应发送到客户端指定的 UDP 端口。',
                      ),
                      ReadOnlyValueTile(
                        'PADDING 支持 (PADDING)',
                        ValueFormatters.formatEnum(
                          report.value?.serverCapabilities.padding,
                        ),
                        icon: FluentIcons.text_box,
                        description: '表示服务端是否接受或正确处理带有 PADDING 属性的请求。',
                      ),
                    ],
                  ),
                  ExpanderSection(
                    title: '诊断信息 (Diagnostics)',
                    initiallyExpanded: true,
                    children: <Widget>[
                      ReadOnlyValueTile(
                        '错误信息 (Error)',
                        errorMessage.value ?? ValueFormatters.unavailable,
                        icon: FluentIcons.error,
                        description: '探测失败时显示异常摘要或最后一次错误信息。',
                      ),
                      ReadOnlyValueTile(
                        '告警信息 (Warnings)',
                        warnings.isEmpty
                            ? ValueFormatters.unavailable
                            : warnings.join('\n'),
                        icon: FluentIcons.warning,
                        description: '列出不阻断探测但可能影响解读结果的提示信息。',
                        maxLines: warnings.isEmpty ? 1 : 8,
                      ),
                    ],
                  ),
                  ExpanderSection(
                    title: '运行日志(Logs)',
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SelectableText(logEntries.value.join('\n')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

List<String> _appendLogEntry(List<String> current, String entry) {
  final List<String> next = <String>[...current, entry];
  if (next.length <= NatDiagnosticsPage._maxLogEntries) {
    return next;
  }
  return next.sublist(next.length - NatDiagnosticsPage._maxLogEntries);
}

String _formatLogEntry(StunLogEvent event) {
  final String timestamp = event.timestamp.toLocal().toIso8601String();
  final String level = event.level.name.toUpperCase();
  return '[$timestamp] [$level] ${event.format()}';
}
