import 'package:get/get.dart';

import 'pages/about_page.dart';
import 'pages/archive_page.dart';
import 'pages/article_page.dart';
import 'pages/friend_link_page.dart';
import 'pages/home_page.dart';
import 'pages/tag_page.dart';

class AppPages {
  static const INITIAL = HomePage.routeName;
  static final List<GetPage> routes = [
    GetPage(
      name: HomePage.routeName,
      page: () => HomePage(),
    ),
    GetPage(
      name: TagPage.routeName,
      page: () => TagPage(),
    ),
    GetPage(
      name: ArchivePage.routeName,
      page: () => ArchivePage(),
    ),
    GetPage(
      name: FriendLinkPage.routeName,
      page: () => FriendLinkPage(),
    ),
    GetPage(
      name: AboutPage.routeName,
      page: () => AboutPage(),
    ),
    GetPage(
      name: ArticlePage.routeName,
      page: () {
        ArticleArguments arguments = Get.arguments;
        return ArticlePage(
          articleData: arguments.articleData,
          name: arguments.name,
        );
      },
    ),
  ];
}
