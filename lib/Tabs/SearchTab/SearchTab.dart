import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Screens/profile/profilePage.dart';
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
            fontSize: MediaQuery.of(context).size.width * 0.06,
          ),
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _controller.searchController,
                onChanged: (value) {
                  _controller.performSearch(value.toLowerCase());
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _controller
                          .performSearch(_controller.searchController.text.toLowerCase());
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
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: _controller.searchResults.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey[100],
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ProfileScreen(uid: _controller.searchResults[index]['uuid']);
                            },));
                          },
                          title: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: CachedNetworkImageProvider(
                                  _controller.searchResults[index]['profilePhotoUrl'],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _controller.searchResults[index]['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Followers: ${_controller.searchResults[index]['followers'].length.toString()}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "Following: ${_controller.searchResults[index]['following'].length.toString()}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
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
