# NAT 网络诊断工具

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Fluent UI](https://img.shields.io/badge/Fluent_UI-Desktop-0F6CBD?style=for-the-badge&logo=windows11&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-State_Management-40C4FF?style=for-the-badge)
![STUN](https://img.shields.io/badge/STUN-NAT_Diagnostics-1F8A70?style=for-the-badge)
![UDP](https://img.shields.io/badge/UDP-Network_Testing-FF7A00?style=for-the-badge)
![GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-EA4335?style=for-the-badge)
![Windows](https://img.shields.io/badge/Windows-Supported-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-Supported-111111?style=for-the-badge&logo=apple&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Supported-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Android](https://img.shields.io/badge/Android-Supported-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-Supported-000000?style=for-the-badge&logo=apple&logoColor=white)
![Web](https://img.shields.io/badge/Web-Not_Supported-8B0000?style=for-the-badge&logo=googlechrome&logoColor=white)

**一个基于 Flutter 构建的 NAT / STUN 网络诊断工具，用来快速观察公网映射、过滤行为、映射存活时间与扩展网络特征。**

</div>

---

## 项目简介

这个项目是一个用于 **NAT 行为检测与 STUN 诊断** 的 Flutter 应用，当前界面采用 Fluent UI 风格，适合在桌面环境下作为网络测试小工具使用。它可以帮助你观察当前网络是否经过 NAT、NAT 的映射与过滤策略、服务端能力、映射存活时间估算，以及一些更偏工程诊断用途的扩展指标。

相较于只返回一个“能不能通”的简单测试工具，这个项目更偏向“**把网络行为拆开来看**”。你既可以直接选择公开 STUN 服务快速执行测试，也可以手动调整本地绑定地址、端口、超时、重传、分片填充等参数，观察不同网络环境下的响应差异。

## 功能亮点

- 支持填写或选择目标 STUN 服务 URI，快速发起 NAT 探测。
- 支持自定义本地绑定 IP 与端口，便于多网卡或特定出口场景验证。
- 支持检测网络可达性、是否存在 NAT、公网映射地址与服务端端点。
- 支持分析 NAT 映射行为、过滤行为以及传统 NAT 类型归类。
- 支持估算 Binding Lifetime，辅助判断映射在空闲状态下可维持多久。
- 支持扩展诊断，包括 Hairpinning、分片处理能力、ALG 干预检测等。
- 支持展示服务端能力，例如 `OTHER-ADDRESS`、`RESPONSE-ORIGIN`、`CHANGE-REQUEST`、`RESPONSE-PORT`、`PADDING`。
- 支持输出运行日志，便于排查超时、重传和服务端响应细节。

## 界面预览

<p float="center">
   <img src="./screenshot/%7B9B4D2932-099C-4F07-83FA-FD1CB2382C9A%7D.png" width="47%"/>
   <img src="./screenshot/%7BE89C4CD0-0575-4F9E-A3B3-3261B0885182%7D.png" width="47%"/>
</p>
<p float="center">
   <img src="./screenshot/%7B125B347D-FED2-4D11-B8F3-F2F6F501B6A6%7D.png" width="47%"/>
   <img src="./screenshot/%7B2E6AC64A-C24F-4EF7-AED3-83F4D80EEADD%7D.png" width="47%"/>
</p>

## 适用场景

- 想快速确认当前网络是否经过 NAT，以及 NAT 的大致行为类型。
- 想验证某个网络环境下 UDP 是否可达、是否被限制、是否存在映射超时问题。
- 想在开发打洞、P2P、实时通信、游戏联网或自定义 UDP 协议前做基础网络体检。
- 想比较不同 STUN 服务、不同出口网络、不同探测参数下的结果差异。

## 快速开始

### 运行环境

- 已安装 Flutter SDK
- 已安装对应目标平台开发环境
- 具备可访问外部 STUN 服务的网络环境

### 安装依赖

```bash
flutter pub get
```

### 直接运行

```bash
flutter run
```

### 运行到指定平台

```bash
flutter run -d windows
flutter run -d macos
flutter run -d linux
flutter run -d android
flutter run -d ios
```

## 技术栈

- Flutter
- Dart
- Fluent UI
- flutter_riverpod
- hooks_riverpod
- flutter_hooks
- STUN

## 检测维度一览

| 维度 | 说明 |
| --- | --- |
| 网络可达性 | 判断当前网络是否能与 STUN 服务完成基本 UDP 通信 |
| NAT 是否存在 | 通过本地地址与映射地址对比判断是否存在 NAT |
| 映射行为 | 观察 NAT 对不同目标是否复用相同外部映射 |
| 过滤行为 | 观察 NAT / 防火墙对外部来包的接收条件 |
| 传统 NAT 类型 | 将结果映射为常见 NAT 分类名称 |
| 映射存活时间 | 估算 NAT 映射空闲状态下的生命周期 |
| Hairpinning | 判断局域网设备能否通过公网映射回访自身 |
| 分片处理能力 | 判断较大 UDP 报文或分片在路径中的处理表现 |
| ALG 检测 | 判断中间设备是否可能对报文做了协议级干预 |
| 服务端能力 | 判断 STUN 服务是否支持扩展属性和相关行为 |

## 不支持 Web 平台

由于浏览器在通过 WebSockets 使用 UDP 时存在限制，此应用程序不支持网页平台。欲了解更多信息，请参阅以下链接：

- [Why can't I send UDP packets from a browser?](https://gafferongames.com/post/why_cant_i_send_udp_packets_from_a_browser/)
- [JavaScript WebSockets with UDP?](https://stackoverflow.com/questions/4657033/javascript-websockets-with-udp)
- [Reading from UDP port in browser](https://www.codeease.net/programming/questions/reading-from-udp-port-in-browser)
