import 'dart:async';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  final String key;
  final String cluster;
  final bool useTLS;
  final _pusher = PusherChannelsFlutter.getInstance();
  bool _initialized = false;
  final Set<String> _subscribedChannels = {};
  final Map<String, List<void Function(PusherEvent)>> _handlers = {};

  PusherService({required this.key, required this.cluster, this.useTLS = true});

  Future<void> connect() async {
    if (_initialized) return;
    await _pusher.init(
      apiKey: key,
      cluster: cluster,
      onEvent: (event) {
        final key = '${event.channelName}:${event.eventName}';
        final list = _handlers[key];
        if (list != null) {
          for (final h in List.of(list)) {
            h(event);
          }
        }
      },
      onConnectionStateChange: (currentState, previousState) {},
      onError: (message, code, e) {},
      enableStats: false,
    );
    await _pusher.connect();
    _initialized = true;
  }

  Future<void> subscribe(String channelName, void Function(PusherEvent) onEvent,
      {required String eventName}) async {
    await connect();
    if (!_subscribedChannels.contains(channelName)) {
      await _pusher.subscribe(channelName: channelName);
      _subscribedChannels.add(channelName);
    }
    final mapKey = '$channelName:$eventName';
    final list = _handlers[mapKey] ?? <void Function(PusherEvent)>[];
    list.add(onEvent);
    _handlers[mapKey] = list;
  }

  Future<void> disconnect() async {
    if (_initialized) {
      await _pusher.disconnect();
      _initialized = false;
      _subscribedChannels.clear();
      _handlers.clear();
    }
  }
}
