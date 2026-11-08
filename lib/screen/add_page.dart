import 'package:flutter/material.dart';
import 'package:simple_note_api/services/todo_services.dart';
import 'package:simple_note_api/utils/snackbar_helper.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title']?.toString() ?? '';
      final description = todo['description']?.toString() ?? '';
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Enter note title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter note description',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isSubmitting ? null : (isEdit ? updateData : submitData),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEdit ? 'Update' : 'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      showErrorMessage(context, message: 'Title cannot be empty');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final body = {
      'title': title,
      'description': description,
      'is_completed': false,
    };

    final isSuccess = await ToDoService.addToDo(body);

    if (!mounted) return;
    setState(() {
      isSubmitting = false;
    });

    if (isSuccess) {
      titleController.clear();
      descriptionController.clear();
      showSuccessMessage(context, message: 'Creation Success');
      Navigator.pop(context);
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) return;

    final id = (todo['_id'] ?? todo['id'] ?? '').toString();
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      showErrorMessage(context, message: 'Title cannot be empty');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final body = {
      'title': title,
      'description': description,
      'is_completed': todo['is_completed'] ?? false,
    };

    final isSuccess = await ToDoService.updateToDo(id, body);

    if (!mounted) return;
    setState(() {
      isSubmitting = false;
    });

    if (isSuccess) {
      showSuccessMessage(context, message: 'Updating Success');
      Navigator.pop(context);
    } else {
      showErrorMessage(context, message: 'Updating Failed');
    }
  }
}
