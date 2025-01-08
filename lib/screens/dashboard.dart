import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imagine_retailer/config/constants.dart';
import 'package:imagine_retailer/controller/HomeController.dart';
import 'package:imagine_retailer/screens/widgets/LabelCard.dart';
import 'package:imagine_retailer/screens/widgets/small_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DashboardPage extends GetView<Homecontroller> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => Homecontroller());
    final controller = Get.find<Homecontroller>();

    // Log products if they are available

    final List<ChartData> chartData1 = [
      ChartData('Gold', 25, Colors.yellowAccent),
      ChartData('Silver', 25, Colors.blueGrey),
      ChartData('Platinum', 50, Colors.white),
    ];

    final List<ChartData> chartData = [
      ChartData('Apple', 25,getRandomColor()),
      ChartData('Motorola', 25, getRandomColor()),
      ChartData('Apple1', 50, getRandomColor()),
      ChartData('Apple2', 25, getRandomColor()),
      ChartData('Motorola2', 25, getRandomColor()),
      ChartData('Apple4', 50,getRandomColor()),
      ChartData('Appledd', 25, getRandomColor()),
      ChartData('Motorolad', 25,getRandomColor()),
      ChartData('Appled', 50, getRandomColor()),      ChartData('Apple', 25, getRandomColor()),
      ChartData('Motorolag', 25, getRandomColor()),
      ChartData('Apples', 50,getRandomColor()),

    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            const Labelcard(
              content: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SmallCard(
                        logo: Icons.wallet,
                        title: 'Orders',
                        num: '75',
                      ),
                      SmallCard(
                        logo: Icons.wallet,
                        title: 'Sales',
                        num: '150',
                      ),
                      SmallCard(
                        logo: Icons.wallet,
                        title: 'Returns',
                        num: '10',
                      ),
                      SmallCard(
                        logo: Icons.wallet,
                        title: 'Pending',
                        num: '20',
                      ),
                      // Add more SmallCards as needed
                    ],
                  ),
                ),
              ), title: 'Summary',
            ),
            SizedBox(height: 10,),
            Labelcard(
              title: 'Condition Wise Stock',
              content: SfCircularChart(
              title: const ChartTitle(),
              legend: const Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: [
                //
                DoughnutSeries(
                  explodeAll: true,
                  dataSource: chartData1,
                  pointColorMapper: (data, _) => data.color,
                  xValueMapper: (data, _) => data.x,
                  yValueMapper: (data, _) => data.y,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    useSeriesColor: true,
                  ),
                )
              ],
            ),),
            SizedBox(height: 10,),

            Labelcard(
             title: "Brand Wise Stock",
             content:  SingleChildScrollView( // Enable scrolling
             scrollDirection: Axis.horizontal, // Scroll horizontally
             child: SizedBox(
               width: chartData.length * 50.0, // Set width for scrolling
               child: SfCartesianChart(
                 legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                 primaryXAxis: const CategoryAxis(
                   labelRotation: -45, // Rotate labels for better visibility
                   labelStyle: TextStyle(fontSize: 10), // Adjust label font size if needed
                 ),
                 primaryYAxis: const NumericAxis(
                   title: AxisTitle(text: 'No. of Items'),
                 ),
                 series: <CartesianSeries>[
                   ColumnSeries<ChartData, String>(
                     dataSource: chartData,

                     xValueMapper: (ChartData data, _) => data.x,
                     yValueMapper: (ChartData data, _) => data.y,
                     pointColorMapper: (ChartData data, _) => data.color,
                     dataLabelSettings: const DataLabelSettings(
                       isVisible: true,
                       labelAlignment: ChartDataLabelAlignment.top,
                     ),
                   ),
                 ],
               ),
             ),
           ),
            )

          ],
        ),
      ),
    );
  }
}
final Random random = Random();
Color getRandomColor() => Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
