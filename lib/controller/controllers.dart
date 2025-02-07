import 'package:get/get.dart';
import 'package:imagine_retailer/config/ResultState.dart';
import 'package:imagine_retailer/config/common_methods.dart';
import 'package:imagine_retailer/models/Product.dart';
import 'package:imagine_retailer/repository/barcode_repository.dart';
import 'package:imagine_retailer/screens/warranty_view.dart';
import 'package:imagine_retailer/screens/widgets/error_page.dart';

import '../screens/user_view.dart';

class BarCodeController extends GetxController {


  var product = Rx<Result<Product>>(Result.loading());
  BarcodeRepository repository = BarcodeRepository();
  Rx<bool> isLoading = false.obs;
  Rx<bool> isBarCode = true.obs;
  @override
  void onReady() {
  }




  Future getProductSold(Product data) async{
    if(product.value.data?.status == 'sold'){
      Get.to(const WarrantyView(),arguments: data);
    }
    else if (product.value.data?.status == 'billed'){
      Get.to(()=>UserView(),arguments: data);
    }
    else{
      Get.to(()=>ErrorPage("Product Not Found", onHomePressed: Get.back),);
    }
  }
  Future<void> fetchProduct(String serialNumber)async{
    final result = await repository.fetchProduct(serialNumber);
    product.value = result;
    switch(result.state){

      case ResultState.SUCCESS:
        isLoading.value = false;
        getProductSold(result.data!);
      case ResultState.ERROR:
        isLoading.value = false;

        showError(result.message!);
      case ResultState.LOADING:
        isLoading.value = true;
      case ResultState.INITIAL:

    }

  }
}
