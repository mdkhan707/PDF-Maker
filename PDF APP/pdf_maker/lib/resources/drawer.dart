import 'package:flutter/material.dart';
import 'package:pdf_maker/Routes/routes_name.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _selectedRoute = RoutesName.homescreen;

  void _selectRoute(String routeName) {
    setState(() {
      _selectedRoute = routeName;
    });
    Navigator.of(context).pop();
    Navigator.pushNamed(context, routeName);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color.fromARGB(255, 187, 27, 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 5),
                    height: 85,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image:
                          DecorationImage(image: AssetImage('images/pdf.png')),
                    ),
                  ),
                  const Text(
                    'PDF Maker',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            selected: _selectedRoute == RoutesName.homescreen,
            selectedTileColor: Color.fromARGB(255, 236, 244, 255),
            onTap: () => _selectRoute(RoutesName.homescreen),
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            selectedColor: Colors.cyan,
          ),
          ListTile(
            selected: _selectedRoute == RoutesName.PhotoToPdf,
            selectedTileColor: Color.fromARGB(255, 236, 244, 255),
            onTap: () => _selectRoute(RoutesName.PhotoToPdf),
            leading: const Icon(Icons.camera_alt),
            title: const Text(
              'Make PDF',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            selectedColor: Colors.cyan,
          ),
          ListTile(
            selected: _selectedRoute == RoutesName.createdPdf,
            selectedTileColor: Color.fromARGB(255, 236, 244, 255),
            onTap: () => _selectRoute(RoutesName.createdPdf),
            leading: const Icon(Icons.history),
            title: const Text(
              'Created PDFs',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            selectedColor: Colors.cyan,
          ),
        ],
      ),
    );
  }
}
