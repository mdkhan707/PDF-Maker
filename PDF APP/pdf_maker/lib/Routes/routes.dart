import 'package:flutter/material.dart';
import 'package:pdf_maker/Routes/routes_name.dart';
import 'package:pdf_maker/view/created_pdf.dart';
import 'package:pdf_maker/view/doc_to_pdf.dart';
import 'package:pdf_maker/view/home_screen.dart';
import 'package:pdf_maker/view/phot_to_pdf.dart';
import 'package:pdf_maker/view/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RoutesName.homescreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
      case RoutesName.PhotoToPdf:
        return MaterialPageRoute(
            builder: (BuildContext context) => const PhotToPdf());
      case RoutesName.DocToPdf:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DocToPdf());
      case RoutesName.createdPdf:
        return MaterialPageRoute(
            builder: (BuildContext context) => CreatedPDFScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text("No Route defined"),
                  ),
                ));
    }
  }
}
