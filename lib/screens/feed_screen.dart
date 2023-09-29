import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:raftl_app/utils/colors.dart';
import 'package:raftl_app/utils/global_variable.dart';
import 'package:raftl_app/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Row(
                children: [
                  Image(
                    image: NetworkImage(
                      'https://clutchco-static.s3.amazonaws.com/s3fs-public/logos/f5dbcd8c150f54636cf91e8c04e95de4.png?VersionId=zdJLRPXVglPvv_F6hZ4hiu8AI7iygYcd',
                    ),
                    height: 48,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; 
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  Text('RaftLabs',style: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 1),),
                ],
              ),
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.docs.length==0 ? Center(child: Text('NO NEW FEED',style: TextStyle(fontWeight: FontWeight.w600),)) : ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
