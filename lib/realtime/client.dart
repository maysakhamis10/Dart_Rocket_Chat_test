library realtime;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:ddp/ddp.dart' as ddp;
import 'package:jitsi/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

part 'channels.dart';
part 'emoji.dart';
part 'events.dart';
part 'messages.dart';
part 'permissons.dart';
part 'subscriptions.dart';
part 'users.dart';

abstract class _DdpClientWrapper {
  ddp.DdpClient _getDdpClient();
}

typedef void _StatusListener(ddp.ConnectStatus status);

class ClientReal extends Object
    with
        _ClientChannelsMixin,
        _ClientEmojiMixin,
        _ClientEventsMixin,
        _ClientPermissionsMixin,
        _ClientMessagesMixin,
        _ClientUsersMixin,
        _ClientSubscriptionsMixin
    implements _DdpClientWrapper {
  ClientReal(String name, Uri uri, bool debug) {
    String wsUrl = 'ws';
    int port = 80;
    if (uri.scheme == 'https') {
      wsUrl = 'wss';
      port = 443;
    }
    if (uri.port != null) {
      port = uri.port;
    }
    wsUrl = '$wsUrl://${uri.host}:$port${uri.path}/websocket';
    print('data: $wsUrl');
    this._ddp = ddp.DdpClient(name, wsUrl, uri.toString());
    if (debug) {
      this._ddp.setSocketLogActive(true);
    } else {
      this._ddp.setSocketLogActive(false);
    }
    this._ddp.connect();
  }

  ddp.DdpClient _ddp;

  @override
  ddp.DdpClient _getDdpClient() => this._ddp;

  void reconnect() {
    this._ddp.reconnect();
  }

  void connectionAway() => this._ddp.call('UserPresence:away', []);

  void connectionOnline() => this._ddp.call('UserPresence:online', []);

  void close() => this._ddp.close();

  void addStatusListener(_StatusListener listener) {
    this._getDdpClient().addStatusListener(listener);
    print(this._getDdpClient().stats());
  }
}

final Random _random = Random(DateTime.now().millisecondsSinceEpoch);

String _randomId() => '${_random.nextDouble()}';
