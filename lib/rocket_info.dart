import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/post_api_service.dart';

class RocketInfoPage extends StatelessWidget {
  final String rocketId;

  const RocketInfoPage({
    Key? key,
    required this.rocketId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket App'),
      ),
      body: FutureBuilder<Response>(
        future: Provider.of<PostApiService>(context).getRocketInfo(rocketId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final Map post = json.decode(snapshot.data!.bodyString);
            print(post);
            return _buildPost(post);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Padding _buildPost(Map post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                post['name'],
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post['flickr_images'].length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: Image(
                        image: NetworkImage(post['flickr_images'][index])),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Expanded(
                  child: DataTable(
                columns: const [
                  DataColumn(label: Text('Property')),
                  DataColumn(label: Text('Value'))
                ],
                rows: [
                  DataRow(
                    cells: [
                      const DataCell(Text('Active Status')),
                      DataCell(Wrap(children: [
                        post['active'] == 'true'
                            ? const Icon(Icons.airplanemode_on)
                            : const Icon(Icons.airplanemode_off)
                      ]))
                    ],
                  ),
                  DataRow(
                    cells: [
                      const DataCell(Text('Height')),
                      DataCell(Text(post['height']['feet'].toString()))
                    ],
                  ),
                  DataRow(
                    cells: [
                      const DataCell(Text('Diameter')),
                      DataCell(Text(post['diameter']['feet'].toString()))
                    ],
                  ),
                  DataRow(
                    cells: [
                      const DataCell(Text('Success Rate(%)')),
                      DataCell(Text(post['success_rate_pct'].toString()))
                    ],
                  ),
                  DataRow(
                    cells: [
                      const DataCell(Text('Cost per launch')),
                      DataCell(Text(post['cost_per_launch'].toString()))
                    ],
                  ),
                ],
              )),
            ),
            Flexible(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          post['description'],
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () => launchUrl(Uri.parse(post['wikipedia'])),
                          child: Text('${post['wikipedia']}',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.blue)))
                    ],
                  ),
                ],
              ),
            )
            // Text(post['active'].toString()),
          ],
        ),
      ),
    );
  }
}