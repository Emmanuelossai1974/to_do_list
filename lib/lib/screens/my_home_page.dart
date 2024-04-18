import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Firestore database instance
  FirebaseFirestore db = FirebaseFirestore.instance;

  // List of task descriptions
  final List<String> tasks = <String>[];

  // Corresponding checklist status for each task
  final List<bool> checkboxes = List.generate(8, (index) => false);

  // FocusNode to manage the keyboard focus for text fields
  FocusNode _textFieldFocusNode = FocusNode();

  // Controller to read text input for new tasks
  TextEditingController nameController = TextEditingController();

  /// Adds a new task to Firestore and updates the local list
  void addItemToList() async {
    final String taskName = nameController.text;

    // Add task to Firestore
    await db.collection('tasks').add({
      'name': taskName,
      'completed': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update local list of tasks and checkboxes
    setState(() {
      tasks.insert(0, taskName);
      checkboxes.insert(0, false);
    });
  }

  /// Removes a task from Firestore and the local list
  void removeItem(int index) async {
    String taskNameToRemove = tasks[index];

    // Query Firestore for the task and delete it
    QuerySnapshot querySnapshot = await db
        .collection('tasks')
        .where('name', isEqualTo: taskNameToRemove)
        .get();

    if (querySnapshot.size > 0) {
      await querySnapshot.docs[0].reference.delete();
    }

    // Update local lists
    setState(() {
      tasks.removeAt(index);
      checkboxes.removeAt(index);
    });
  }

  /// Clears the text field
  void clearTextField() {
    setState(() {
      nameController.clear();
    });
  }

  /// Fetches tasks from Firestore and updates the local list
  Future<void> fetchTasksFromFirestore() async {
    CollectionReference tasksCollection = db.collection('tasks');
    QuerySnapshot querySnapshot = await tasksCollection.get();
    List<String> fetchedTasks = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      fetchedTasks.add(docSnapshot.get('name'));
    }

    setState(() {
      tasks.clear();
      tasks.addAll(fetchedTasks);
    });
  }

  /// Updates a task's completion status in Firestore and locally
  Future<void> updateTaskCompletionStatus(
      String taskName, bool completed) async {
    CollectionReference tasksCollection = db.collection('tasks');
    QuerySnapshot querySnapshot =
        await tasksCollection.where('name', isEqualTo: taskName).get();

    if (querySnapshot.size > 0) {
      await querySnapshot.docs[0].reference.update({'completed': completed});
    }

    setState(() {
      int taskIndex = tasks.indexWhere((task) => task == taskName);
      checkboxes[taskIndex] = completed;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTasksFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*

            Rows() and Columns() both have the mainAxisAlignment 
            property we can utilize to space out their child 
            widgets to our desired format.
           */
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              /*
 
            SizedBox allows us to control the vertical 
            and horizontal dimensions by manipulating the 
            height or width property, or both.
            */

              height: 70,
              child: Image.asset('assets/rdplogo.png'),
            ),
            Text(
              'Daily Planner',
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 300,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:

                      /*
          The TableCalendar() widget below is installed via 
          "flutter pub get table_calendar" or by adding the package 
          to the pubspec.yaml file.  We then import it and implement using
          configuration properties.  You can set a range and a focus day. 
          The particulars of implementation for any package can be gleaned 
          from pub.dev: https://pub.dev/packages/table_calendar.
          */
                      TableCalendar(
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2023),
                    lastDay: DateTime(2025),
                  ),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(4),
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: checkboxes[index]
                            ? Colors.green.withOpacity(0.7)
                            : Colors.blue.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Icon(
                              !checkboxes[index]
                                  ? Icons.manage_history
                                  : Icons.playlist_add_check_circle,
                              size: 32,
                            ),
                            SizedBox(width: 18),
                            Expanded(
                              child: Text(
                                '${tasks[index]}',
                                style: checkboxes[index]
                                    ? TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.5))
                                    : TextStyle(fontSize: 20),
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: checkboxes[index],
                                  onChanged: (newValue) {
                                    setState(() {
                                      checkboxes[index] = newValue!;
                                    });
                                    updateTaskCompletionStatus(
                                        tasks[index], newValue!);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    removeItem(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 25, right: 25),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      focusNode: _textFieldFocusNode,
                      style: TextStyle(fontSize: 18),
                      maxLength: 20,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Add To-Do List Item',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                        hintText: 'Enter your task here',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      clearTextField();
                      // Clear the text field to allow for a new task entry
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  addItemToList();
                  _textFieldFocusNode.unfocus(); // Close the keyboard
                  clearTextField(); // Clear the text field after adding item
                },
                child: Text('Add To-Do'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
