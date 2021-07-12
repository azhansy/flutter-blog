import 'package:flutter/material.dart';
import 'package:flutter_blog/app_pages.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int curHour = DateTime.now().hour;
    return GetMaterialApp(
      title: 'azhansy的flutter blog',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness:
            (curHour > 18 || curHour < 7) ? Brightness.dark : Brightness.light,
      ),
    );
  }
}
