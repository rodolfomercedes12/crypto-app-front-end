
import 'package:crypto_app/features/crypto/presentation/providers/crypto_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';





class CryptoChart extends ConsumerWidget {
  const CryptoChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final auth = ref.watch(authProvider.notifier);
    final cryptos = ref.watch(cryptoProvider);


    return Scaffold(
        appBar: AppBar(
          title: const Text(' CryptoApp '),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: (){
                auth.logout();
              },
              icon: const Icon(Icons.exit_to_app)  )
          ],
        ),
        body: Column(children: [
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Crypto Currency'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<Crypto, String>>[
                LineSeries<Crypto, String>(
                    dataSource: cryptos.take(3).where((crypto) => crypto.price > 0).toList(),
                    xValueMapper: (Crypto crypto, _) => crypto.name,
                    yValueMapper: (Crypto crypto, _) => crypto.price,
                    name: 'Chart',
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ]),
             

              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  //color: Colors.red,
                  child: ListView.builder(
                    itemCount: cryptos.length,
                    itemBuilder: (BuildContext context, int index) {
                      final crypto = cryptos[index];
                      return ListTile(
                        title: Text(crypto.name, style: const TextStyle( color: Colors.grey )),
                        subtitle: Text(crypto.price.toString(), style: const TextStyle( fontSize: 30, fontWeight: FontWeight.bold )),
                      );
                    },
                  ),
                ),
              ),

        
        ]));
  }
}