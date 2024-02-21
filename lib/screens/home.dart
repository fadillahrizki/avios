import 'package:avios/services/task_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../components/custom_dialog.dart';
import '../../components/custom_text_field.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  updateTask(docId) async {
    await TaskService.updateTask(
        docId, titleController.text, descriptionController.text);
    if (context.mounted) {
      Navigator.pop(context);
      titleController.clear();
      descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('uid', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final dt = data[index];
                    return ListTile(
                      onTap: () {
                        titleController.text = dt['title'];
                        descriptionController.text = dt['description'];
                        showDialog(
                          context: context,
                          builder: (_) => CustomDialog(
                            content: [
                              CustomTextField(
                                label: "Title",
                                controller: titleController,
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                label: "Description",
                                controller: descriptionController,
                                maxLines: 10,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      label: "Close",
                                      type: "secondary",
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () async {
                                        await updateTask(dt.id);
                                      },
                                      label: "Update",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      title: Text(dt['title']),
                      subtitle: Text(
                        dt['description'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Icon(dt['status'] == 'waiting'
                          ? Icons.timelapse
                          : Icons.done),
                      tileColor: dt['status'] == 'waiting'
                          ? Colors.amber
                          : Colors.green,
                      trailing: IconButton(
                        icon: Icon(dt['status'] == 'waiting'
                            ? Icons.done
                            : Icons.cancel),
                        onPressed: () async {
                          await TaskService.setStatus(dt.id,
                              dt['status'] == 'waiting' ? 'done' : 'waiting');
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
