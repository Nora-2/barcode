import 'package:parcode/features/EnterCompanies.dart';
import 'package:parcode/features/home/home.dart';
import 'package:parcode/features/excel/presentation/view/excel.dart';

import 'package:parcode/features/scanner/presentation/widget/qrview.dart';
import 'package:parcode/features/viewdata/presentation/view/Viewdataa.dart';
import 'package:parcode/features/spalsh/welcome.dart';
import 'package:path/path.dart';

class AppRoutes {
  AppRoutes._();

  static String? get initialRoute {
    return welcomePage.id;
  }

  static final routes = {
     Entercompanies.id: (context) => Entercompanies(),
    welcomePage.id: (context) => const welcomePage(),
    QRViewExample.id: (context) => const QRViewExample(),
    Core.id: (context) =>  Core(),
    DownloadDataScreen.id: (context) => const DownloadDataScreen(),
    ViewDataScreen.id: (context) =>  ViewDataScreen(),
   
  };
}
