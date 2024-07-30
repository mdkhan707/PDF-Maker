import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf_maker/Routes/routes_name.dart';
import 'package:pdf_maker/resources/buttons.dart';
import 'package:pdf_maker/resources/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 187, 27, 16),
        title: const Text(
          'PDF Maker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      drawer: MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              'PDF Maker Utility',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UtilityButton(
                  icon: Icons.photo,
                  label: 'Photo to PDF',
                  onpressed: () {
                    Navigator.pushNamed(context, RoutesName.PhotoToPdf);
                  }),
              const SizedBox(width: 20),
              UtilityButton(
                  icon: Icons.description,
                  label: 'Doc to PDF',
                  onpressed: () {
                    Navigator.pushNamed(context, RoutesName.DocToPdf);
                  }),
            ],
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'History',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          HistoryButton(
              lable: 'Created PDFs ',
              onpress: () {
                Navigator.pushNamed(context, RoutesName.createdPdf);
              })
        ],
      ),
    );
  }
}
