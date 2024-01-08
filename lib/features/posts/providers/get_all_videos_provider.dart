import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/core/constants/firebaes_collection_names.dart';
import 'package:facebook/core/constants/firebase_field_names.dart';
import 'package:facebook/features/posts/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllVideosProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .where(FirebaseFieldNames.postType, isEqualTo: 'video')
      .orderBy(FirebaseFieldNames.datePublished, descending: true)
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs.map(
      (postData) => Post.fromMap(
        postData.data(),
      ),
    );
    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
