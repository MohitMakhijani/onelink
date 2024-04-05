import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'getx.dart';

class SearchPage extends StatelessWidget {
  final SearchTabController _controller = Get.put(SearchTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF888BF4),
        title: Text(
          "Search",
          style: GoogleFonts.aladin(
              fontSize: MediaQuery.of(context).size.width * 0.06),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _controller.searchController,
                decoration: InputDecoration(

                  hintText: 'Search...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _controller
                          .performSearch(_controller.searchController.text);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (_controller.searchResults.isEmpty) {
                  return Center(
                      child: Text(
                    'Search Jobs Events Peoples....',
                    style: GoogleFonts.aladin(),
                  ));
                } else {
                  return ListView.builder(
                    itemCount: _controller.searchResults.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            _controller.searchResults[index]['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // Handle tap on search result item onTap
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
