import 'package:flutter/material.dart';
import 'package:flutter_blog/pages/all_pages.dart';
import 'base_config.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(homePage, child: (_, args) => HomePage()),
        ModularRouter(tagPage, child: (_, args) => TagPage()),
        ModularRouter(archivePage, child: (_, args) => ArchivePage()),
        ModularRouter(linkPage, child: (_, args) => FriendLinkPage()),
        ModularRouter(aboutPage, child: (_, args) => AboutPage()),
        ModularRouter("$articlePage/:name",
            child: (_, args) => ArticlePage(
                  name: args.params['name'],
                  articleData: args.data,
                )),
      ];

  @override
  Widget get bootstrap => MyApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int curHour = DateTime.now().hour;
    return MaterialApp(
      title: '老晨子的flutter blog',
      navigatorKey: Modular.navigatorKey,
      theme: ThemeData(
        brightness:
            (curHour > 18 || curHour < 7) ? Brightness.dark : Brightness.light,
      ),
      initialRoute: homePage,
      onGenerateRoute: Modular.generateRoute,
    );
  }
}
