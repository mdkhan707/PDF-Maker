import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pdf_maker/resources/created_pdf_list.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

import 'package:pdf_maker/resources/utils.dart';

class CreatedPDFScreen extends StatefulWidget {
  @override
  _CreatedPDFScreenState createState() => _CreatedPDFScreenState();
}

class _CreatedPDFScreenState extends State<CreatedPDFScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    CreatedPDFsList().loadFromPreferences();
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  Future<String> _getFileSize(String path) async {
    final file = File(path);
    final bytes = await file.length();
    return '${(bytes / 1024).toStringAsFixed(2)} KB';
  }

  void _deletePDF(int index) async {
    final createdPDFs = CreatedPDFsList().createdPDFs;
    final pdf = createdPDFs[index];
    final file = File(pdf.path);

    if (await file.exists()) {
      await file.delete();
    }

    setState(() {
      CreatedPDFsList().removePDF(index);
    });
    Utils.flushbarmessage('${pdf.name} Deleted', context);
  }

  void _onSearchChanged(String query) {
    setState(() {});
  }

  List<CreatedPDF> _getFilteredPDFs() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return CreatedPDFsList().createdPDFs;
    } else {
      return CreatedPDFsList().createdPDFs.where((pdf) {
        return pdf.name.toLowerCase().contains(query);
      }).toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPDFs = _getFilteredPDFs();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 187, 27, 16),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search PDFs',
                ),
              )
            : const Text(
                'Created PDFs',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          if (_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredPDFs.length,
        itemBuilder: (context, index) {
          final pdf = filteredPDFs[index];
          return FutureBuilder<String>(
            future: _getFileSize(pdf.path),
            builder: (context, snapshot) {
              final size = snapshot.data ?? 'Calculating...';
              return Dismissible(
                key: Key(pdf.path),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deletePDF(index);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(pdf.name),
                  subtitle: Text('${_formatDate(pdf.date)} - $size'),
                  onTap: () async {
                    final result = await OpenFile.open(pdf.path);
                    if (result.type != ResultType.done) {
                      Utils.flushbarmessage("Could not open the PDF", context);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
