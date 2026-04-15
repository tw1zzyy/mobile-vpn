// lib/utils/constants.dart
import '../models/server_model.dart';

class AppConstants {
  static const String tunnelName = 'FlutterVPN';
  static const String vpnConfigsKey = 'vpn_configs';
  static const String autoConnectKey = 'auto_connect';
  static const String darkThemeKey = 'dark_theme';
  static const String appVersion = '1.0.0';
  static const String ipApiUrl = 'https://api.ipify.org?format=json';

  //for backend
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
  static const String dummyDeviceId = 'test-device-uuid-123';

  static final List<ServerModel> freeServers = [
    const ServerModel(
      id: '1',
      flag: '🇩🇪',
      country: 'Germany',
      endpoint: 'de1.vpngate.net:51820',
      publicKey: 'oA9GxTDbsBMzdxUxbDycimxdjObiP98TsVUOsIlkRFc=',
      privateKey: 'WGvEEVjiqC0u8jxlQA/GedyoSJsBSCYbeovszTYq6FQ=',
      address: '10.8.0.2/32',
      dns: '1.1.1.1',
      presharedKey: '',
    ),
    const ServerModel(
      id: '2',
      flag: '🇳🇱',
      country: 'Netherlands',
      endpoint: 'nl1.vpngate.net:51820',
      publicKey: 'QI8QBTSSX4c0BsACxA/4ssKLbLb00nJcsMsVB7QDokQ=',
      privateKey: '1vWW2N14Fg8aVLhq7B6oSwpYAMeuRF6nxLDl3EMCfz4=',
      address: '10.8.0.3/32',
      dns: '1.1.1.1',
      presharedKey: '',
    ),
    const ServerModel(
      id: '3',
      flag: '🇫🇮',
      country: 'Finland',
      endpoint: 'fi1.vpngate.net:51820',
      publicKey: '2BAklLgvHi/8+LFRiC5CrYewBuOKnFcTCMI+0pblonw=',
      privateKey: 'XQXHVGRU6AcWS2qZh57HzuRbOOOOez+zOzTg6nhclGQ=',
      address: '10.8.0.4/32',
      dns: '8.8.8.8',
      presharedKey: '',
    ),
    const ServerModel(
      id: '4',
      flag: '🇺🇸',
      country: 'USA',
      endpoint: 'us1.vpngate.net:51820',
      publicKey: 'QIWzs5tByrjXecuFLQsyEd2pto9DDVZcYEt7w1+F5kc=',
      privateKey: 'yqTlbR0ugD++vgAahnxLXeRuFIaMIHDf74ZV8h/XtGY=',
      address: '10.8.0.5/32',
      dns: '8.8.8.8',
      presharedKey: '',
    ),
    const ServerModel(
      id: '5',
      flag: '🇯🇵',
      country: 'Japan',
      endpoint: 'jp1.vpngate.net:51820',
      publicKey: '6PbPooXuvZdQzMx9ksI3nVeABfZc3z/Q55hCGM9Hulg=',
      privateKey: 'AfkBjzqCM5tGfBco2lJhiYq35b4hyWaYSLqx6yBijUg=',
      address: '10.8.0.6/32',
      dns: '1.0.0.1',
      presharedKey: '',
    ),
  ];
}
