import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _taskCollection {
    final uid = _auth.currentUser!.uid;

    return _firestore.collection('users').doc(uid).collection('tasks');
  }

  Future<void> addTask(TaskModel task) async {
    await _taskCollection.add(task.toMap());
  }

  Future<List<TaskModel>> fetchTasks() async {
    final snapshot = await _taskCollection.get();

    return snapshot.docs.map((doc) {
      return TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> updateTask(TaskModel task) async {
    if (task.id != null) {
      await _taskCollection.doc(task.id).update(task.toMap());
    }
  }

  Future<void> deleteTask(String id) async {
    await _taskCollection.doc(id).delete();
  }
}
