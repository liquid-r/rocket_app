import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

// for API calls using retofit
import 'package:chopper/chopper.dart';

import 'package:provider/provider.dart';

import 'package:rocketapp/rocket_info.dart';
import 'services/post_api_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rockets'),
      ),
      body: _buildBody(context),
    );
  }

  FutureBuilder<Response> _buildBody(BuildContext context) {
    return FutureBuilder<Response>(
      future: Provider.of<PostApiService>(context).getRockets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List posts = json.decode(snapshot.data!.bodyString);
          // print(snapshot.data);
          return _buildPosts(context, posts);
        } else {
          // Show a loading indicator while waiting
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  int getFlickerImage(List posts, int index) {
    Random rnd = Random();
    return rnd.nextInt(posts[index]['flickr_images'].length);
  }

  String getEnginesCount(List posts, int index) {
    return (posts[index]['first_stage']['engines'] +
            posts[index]['second_stage']['engines'])
        .toString();
  }

  ListView _buildPosts(BuildContext context, List posts) {
    return ListView.builder(
      itemCount: posts.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              opacity: 0.9,
              fit: BoxFit.cover,
              image: NetworkImage(
                  posts[index]['flickr_images'][getFlickerImage(posts, index)]),
            )),
            child: ListTile(
              title: Text(
                'Rocket name : ${posts[index]['name']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Country: ${posts[index]['country']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                'Engines Count: ${getEnginesCount(posts, index)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () => _navigateToPost(context, posts[index]['id']),
            ),
          ),
        );
      },
    );
  }

  void _navigateToPost(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RocketInfoPage(rocketId: id),
      ),
    );
  }
}
