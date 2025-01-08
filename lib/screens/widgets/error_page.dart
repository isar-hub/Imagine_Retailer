import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imagine_retailer/config/constants.dart';

import '../../generated/assets.dart';

class ErrorPage extends StatelessWidget{

  final String? message;
  final VoidCallback onHomePressed;
  const ErrorPage(this.message, {super.key, required this.onHomePressed});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ImagineColors.black,
      body: Center(
        child: Row(
          children: [
            Expanded(child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  Text('Error 404',style:  TextStyle(fontWeight: FontWeight.bold),),
                  Text('Hey Buddy',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  Text(message ??"Error Occured",style: TextStyle(fontSize: 12),),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: onHomePressed,
                    child: Text("Go Home",style: TextStyle(color: ImagineColors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ImagineColors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Circular corners
                      ),
                    )
                  )

                ],
              ),
            ),),
            Expanded(child:Image.asset(Assets.catImage ))


          ],
        ),
      ),
    );
  }

}