import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:top_listview_widgets/src/models/image.dart' as model;
import 'package:http/http.dart' as http;
import 'package:top_listview_widgets/src/pages/image_detail.dart';
import 'package:top_listview_widgets/urls.dart';

class ListViewWithNavigatorPage extends StatefulWidget {
  const ListViewWithNavigatorPage({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<ListViewWithNavigatorPage> createState() =>
      _ListViewWithNavigatorPageState();
}

class _ListViewWithNavigatorPageState extends State<ListViewWithNavigatorPage> {
  late Future<List<model.Image>> images;
  final String defaultImageUrl =
      'https://images.unsplash.com/photo-1529655683826-aba9b3e77383?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80';

  @override
  void initState() {
    super.initState();
    images = getImages();
  }

  static Future<List<model.Image>> getImages() async {
    const url =
        "https://api.unsplash.com/search/photos?query=london&client_id=$clientId";
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body['results'].map<model.Image>(model.Image.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<model.Image>>(
        future: getImages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final images = snapshot.data!;
            return ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  return Card(
                      child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          NetworkImage(image.raw ?? defaultImageUrl),
                    ),
                    title: Text(image.description ?? "Londra"),
                    subtitle: Text(image.altDescription ?? "Londra.."),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ImageDetailPage(
                                imageDetail: image,
                              )));
                    },
                  ));
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
