import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  static createTask(title, description, status) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('tasks').add({
      'uid': user.uid,
      'title': title,
      'status': status,
      'description': description,
      'created_at': Timestamp.now(),
    });
  }

  static updateTask(docId, title, description) async {
    await FirebaseFirestore.instance.collection('tasks').doc(docId).update({
      'title': title,
      'description': description,
    });
  }

  static setStatus(docId, status) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(docId)
        .update({'status': status});
  }
}
