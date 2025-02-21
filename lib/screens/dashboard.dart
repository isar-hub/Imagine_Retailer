import 'dart:developer' as developer;
import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imagine_retailer/controller/HomeController.dart';
import 'package:imagine_retailer/models/CharData.dart';
import 'package:imagine_retailer/screens/all_inventory/view.dart';
import 'package:imagine_retailer/screens/widgets/LabelCard.dart';
import 'package:imagine_retailer/screens/widgets/small_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends GetView<Homecontroller> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => Homecontroller());
    final controller = Get.find<Homecontroller>();

    // Log products if they are available


    return EasyRefresh(
      onRefresh: (){
        controller.fetchProducts();
        controller.fetchNotifications();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Labelcard(
                content: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      final totalQuantity = controller.distinctProducts.fold<int>(
                        0,
                        (sum, product) => sum + product.quantity,
                      );
                      final totalBrands = controller.distinctProducts.length;

                      return Row(
                        children: [
                          // Add SmallCards for total quantity and total brands count
                          GestureDetector(
                            onTap: (){
                              Get.to(()=>  All_inventoryComponent(product: controller.products.value.data!, isLoading: false,));
                            },
                            child: SmallCard(
                              logo: Icons.bar_chart,
                              title: 'Total Quantity',
                              num: totalQuantity.toString(),
                              colors: [
                                Colors.black12,
                                Colors.red.shade900,
                              ],
                            ),
                          ),
                          SmallCard(
                            logo: Icons.branding_watermark,
                            title: 'Total Brands',
                            num: totalBrands.toString(),
                            colors: [
                              Colors.red.shade900,
                              Colors.black12,
                            ],
                          ),
                          // Add SmallCards for each product
                          ...controller.distinctProducts.map((product) {
                            return SmallCard(
                              logo: Icons.wallet,
                              title: product.brand,
                              num: product.quantity.toString(),
                            );
                          }),
                        ],
                      );
                    }),
                  ),
                ),
                title: 'Summary',
              ),
              const SizedBox(
                height: 10,
              ),
              Labelcard(
                title: 'Condition Wise Stock',
                content: Obx(() {
                  // Wrap the entire chart with Obx to listen for changes
                  var dataSource = controller.distinctCondition;

                  // Check if the data source is not empty
                  if (dataSource.isEmpty) {
                    return const Center(
                        child: Text('No data available')); // Handle empty data
                  }

                  return SfCircularChart(
                    title:
                        const ChartTitle(text: 'Condition Wise Stock Overview'),
                    legend: const Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      header: 'Stock Information',
                      format: 'Condition: {point.x}\nStock: {point.y}',
                    ),
                    series: <CircularSeries>[
                      DoughnutSeries(
                        explodeAll: true,
                        dataSource: dataSource,
                        pointColorMapper: (data, _) => getColor(data),
                        xValueMapper: (data, _) => data.brand,
                        yValueMapper: (data, _) => data.quantity,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          useSeriesColor: true,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              Labelcard(
                title: "Brand Wise Stock",
                content: Obx(() {
                  var dataSource =
                      controller.distinctProducts; // Convert to a regular list
                  // Check if the data source is not empty
                  if (dataSource.isEmpty) {
                    return const Center(
                        child: Text('No data available')); // Handle empty data
                  }

                  return SingleChildScrollView(
                    // Enable scrolling
                    scrollDirection: Axis.horizontal, // Scroll horizontally
                    child: SizedBox(
                      width: dataSource.length * 50.0, // Set width for scrolling
                      child: SfCartesianChart(
                        legend: const Legend(
                            isVisible: true, position: LegendPosition.bottom),
                        primaryXAxis: const CategoryAxis(
                          labelRotation:
                              -45, // Rotate labels for better visibility
                          labelStyle: TextStyle(
                              fontSize: 10 // Adjust label font size if needed
                              ),
                        ),
                        primaryYAxis: const NumericAxis(
                          title: AxisTitle(text: 'No. of Items'),
                        ),
                        series: <CartesianSeries>[
                          ColumnSeries<CharData, String>(
                            dataSource: dataSource, // Reference directly
                            xValueMapper: (CharData data, _) => data.brand,
                            yValueMapper: (CharData data, _) => data.quantity,
                            pointColorMapper: (data, _) => getRandomColor(),
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelAlignment: ChartDataLabelAlignment.top,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final Random random = Random();
Color getColor(CharData data) {
  print(data.brand);
  if (data.brand == 'Platinum') {
    return Colors.blueGrey;
  } else if(data.brand == 'Silver'){
    return Colors.grey;
  }
  else {
    return Colors.yellowAccent; // Replace with your default color
  }
}
Color getRandomColor() =>
    Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
