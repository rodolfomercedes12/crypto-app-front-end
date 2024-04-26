import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class Crypto {
  Crypto(this.name, this.price);

  final String name;
  double price;
}

final cryptoProvider = StateNotifierProvider<CryptoNotifier, List<Crypto>>((ref) {
  return CryptoNotifier();
});

class CryptoNotifier extends StateNotifier<List<Crypto>> {
  late final WebSocketChannel _channel;
  Timer? _timer;

  CryptoNotifier() : super([
    Crypto( 'BTCUSDT', 0),
    Crypto( 'ETHUSDT',  0),
    Crypto( 'BNBUSDT',  0),
    Crypto( 'ADABTC',  0),
    Crypto( 'XRPUSDT', 0),
  ]) {
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/stream?streams=!ticker@arr'),
    );

    _channel.stream.listen((message) {
      var data = jsonDecode(message)['data'];
      var filteredData = data.where((entry) => state.any((crypto) => crypto.name == entry['s'])).toList();
      
      for (var entry in filteredData) {
        var symbol = entry['s'];
        var price = double.parse(entry['c']);
        price = double.parse(price.toStringAsFixed(2));  // Redondear a dos decimales
        var cryptoIndex = state.indexWhere((c) => c.name == symbol);
        if (cryptoIndex != -1) {
          state = [
            ...state.sublist(0, cryptoIndex),
            Crypto( symbol,  price),
            ...state.sublist(cryptoIndex + 1),
          ];
        }
      }
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _timer?.cancel();
    super.dispose();
  }
}