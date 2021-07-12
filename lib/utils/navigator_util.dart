import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NavigatorUtil {
  ///跳转页面
  static Future<T> pushName<T>(String routeName, {dynamic arguments}) {
    return Get.toNamed<T>(routeName, arguments: arguments);
  }

  ///跳转页面
  static Future<T> push<T>(Widget routeWidget) {
    return Get.to<T>(() => routeWidget);
  }

  ///清除其他的
  static Future<T> offAllNamed<T>(String routeName, {dynamic arguments}) {
    return Get.offAllNamed(routeName, arguments: arguments);
  }

  ///把当前页面替换为新的页面
  static Future<T> pushReplacementNamed<T>(String routeName,
      {dynamic arguments}) {
    return Get.offNamed<T>(routeName, arguments: arguments);
  }

  ///清除其他的
  static Future<T> offAll<T>(Widget page, {dynamic arguments}) {
    return Get.offAll(page, arguments: arguments);
  }

  ///一直删掉路由栈中的路由，直到遇到untilName，然后再push routeName
  static Future pushNamedAndRemoveUntil(String routeName, String untilName,
      {Object arguments}) async {
    debugPrint("page name:" + routeName);
    return Get.offNamedUntil(routeName, ModalRoute.withName(untilName),
        arguments: arguments);
  }

  static Future<T> pushTransparentPage<T>(Widget page, {String pageName}) {
    if (page == null || pageName.isNotEmpty) null;
    debugPrint("page name:" + pageName);

    return Get.to(_TransparentRoute(builder: (ctx) => page));
  }

  static void until(String untilName, {int id}) {
    return Get.until(ModalRoute.withName(untilName), id: id);
  }

  static void pushAndRemoveUntil(String pageName) {
    if (pageName.isNotEmpty) {
      offAllNamed(pageName);
    }
  }

  ///返回
  static void pop<T>({T result}) {
    return Get.back(result: result);
  }

  ///弹出弹窗
  static Future<T> showCommonDialog<T>(Widget dialog) {
    return Get.generalDialog(pageBuilder: (BuildContext context,
        Animation<double> animation, Animation<double> secondaryAnimation) {
      return dialog;
    });
  }

  ///底部弹窗
  static Future<T> bottomSheet<T>(Widget dialog) {
    return Get.bottomSheet(dialog);
  }

  //pop
  static Future showPopup(GlobalKey globalKey, Widget child) async {
    return Navigator.push(globalKey.currentContext,
        _PopRoute(child: child, globalKey: globalKey));
  }

  //类似退出对话框
  static showAlertDialog(
    BuildContext context,
    String title,
    Function() onPressedOk, {
    Function() onPressedCancel,
  }) async {
    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: Text(title),
            actions: [
              TextButton(
                onPressed: onPressedCancel ?? () => pop(),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: onPressedOk,
                child: Text('确定'),
              )
            ],
          );
        });
  }

  ///退出应用
  static void exitApp() {
    if (GetPlatform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }
}

class _TransparentRoute<T> extends PageRoute<T> {
  _TransparentRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: FadeTransition(
        opacity: animation,
        child: result,
      ),
    );
  }
}

class _PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 0);

  final Widget child;
  final GlobalKey globalKey;
  final double offsetChild;

  _PopRoute({this.child, this.globalKey, this.offsetChild = 0.0});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset(0.0, renderBox.size.height));
    var screenHeight = Get.height;

    return _Popup(
      child: Container(
        child: child,
        height: screenHeight - offset.dy,
        color: Color(0xff000000).withOpacity(0.6),
      ),
      left: 0,
      top: offset.dy + offsetChild,
      onClick: () {},
    );
  }

  @override
  Duration get transitionDuration => _duration;
}

class _Popup extends StatelessWidget {
  final Widget child;
  final Function onClick; //点击child事件
  final double left; //距离左边位置
  final double top; //距离上面位置

  _Popup({
    @required this.child,
    this.onClick,
    this.left,
    this.top,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
            Positioned(
              child: GestureDetector(
                  child: child,
                  onTap: () {
                    //点击子child
                    if (onClick != null) {
                      NavigatorUtil.pop();
                      onClick();
                    }
                  }),
              left: left,
              top: top,
            ),
          ],
        ),
        onTap: () {
          //点击空白处
          NavigatorUtil.pop();
        },
      ),
    );
  }
}
