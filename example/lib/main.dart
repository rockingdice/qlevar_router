import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers/database.dart';
import 'routes.dart';

void main() {
  // There are tow examples in this package, choose which one to run
  final runSimpleExample = true;

  QR.enableDebugLog = true;

  if (runSimpleExample) {
    runApp(SimpleApp());
  } else {
    Get.put(Database(), permanent: true);
    runApp(ExampleApp());
  }
}

/// ------- Simple App Example -------
/// Simple Example that has 4 Nasted routes.
/// each route takes a number from the previous one and multiply it with 5

class SimpleApp extends StatelessWidget {
  // TODO: The problem is the router in level 2 will be created again
  // becuase the page isComponent
  // but the old one is still used in the page level2.
  // and that why container still showed in level2
  final pages = [
    QRoute(path: '/simple', page: (child) => Level1(child), children: [
      QRoute(path: '/', page: (child) => Container()),
      QRoute(path: '/:level-2', page: (child) => Level2(child), children: [
        QRoute(path: '/', page: (child) => Container()),
        QRoute(path: '/:level-3', page: (child) => Level3(child), children: [
          QRoute(path: '/', page: (child) => Container()),
          QRoute(
            path: '/:level-4',
            page: (child) => Text(
              QR.params['level-4'].toString(),
              style: TextStyle(fontSize: 20),
            ),
          ),
        ])
      ]),
    ])
  ];

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerDelegate: QR.router(pages, initRoute: '/simple'),
        routeInformationParser: QR.routeParser(),
      );
}

class Level1 extends StatelessWidget {
  final QRouter router;
  Level1(this.router);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Router App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(child: NumbersWidget(1, 'simple')),
          Expanded(flex: 3, child: router),
        ],
      ),
    );
  }
}

class Level2 extends StatelessWidget {
  final QRouter router;
  final String level2Param = QR.params['level-2'].toString();
  Level2(this.router);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            child: Text(
          'from previous route: $level2Param',
          style: TextStyle(fontSize: 24),
        )),
        Flexible(
            child:
                NumbersWidget(int.parse(level2Param), '/simple/$level2Param')),
        Expanded(child: router),
      ],
    );
  }
}

class Level3 extends StatelessWidget {
  final QRouter router;
  final String level2Param = QR.params['level-2'].toString();
  final String level3Param = QR.params['level-3'].toString();
  Level3(this.router);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            child: Text(
          'from previous route: $level3Param',
          style: TextStyle(fontSize: 24),
        )),
        Flexible(
            child: NumbersWidget(
                int.parse(level3Param), '/simple/$level2Param/$level3Param')),
        Expanded(child: router),
      ],
    );
  }
}

class NumbersWidget extends StatelessWidget {
  final String basePath;
  final int lastValue;
  NumbersWidget(this.lastValue, this.basePath);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [1, 2, 3, 4, 5].map((index) {
        final value = lastValue * index;
        return InkWell(
          onTap: () => QR.to('$basePath/$value'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.toString(),
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// ------- End Simple App Example -------

/// ------- The Package Example -------
/// Exmple of store that sell vagtibals and takes orders of multible items
/// See the compleate example for it.
class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerDelegate: QR.router(AppRoutes().routes, initRoute: '/dashboard'),
        routeInformationParser: QR.routeParser(),
      );
}
