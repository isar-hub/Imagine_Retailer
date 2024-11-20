import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Gold', 25, Colors.yellowAccent),
      ChartData('Silver', 25, Colors.blueGrey),
      ChartData('Platinum', 50, Colors.white),
    ];
    return Scaffold(
      body: Column(
        children: [
          SfCircularChart(
            title: ChartTitle(text: 'Sales Distribution'),
            legend: const Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: [
              //
              DoughnutSeries(
                explodeAll: true,
                dataSource: chartData,
                pointColorMapper: (data, _) => data.color,
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  // Enable labels
                  labelPosition: ChartDataLabelPosition.outside,
                  useSeriesColor: true,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
