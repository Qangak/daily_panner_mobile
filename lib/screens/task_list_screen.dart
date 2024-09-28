import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart'; 

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, String>> tasks = [];

  // Hàm để thêm công việc vào danh sách
  void _addTask(Map<String, String> newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  // Hàm để cập nhật công việc sau khi chỉnh sửa
  void _updateTask(int index, Map<String, String> updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
    });
  }

  // Hàm để xóa công việc
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Công việc'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            child: ListTile(
              title: Text(task['task'] ?? 'Không có tiêu đề'),
              subtitle: Text('Thứ ngày: ${task['day']}, Thời gian: ${task['startTime']} - ${task['endTime']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      // Điều hướng tới AddTaskScreen với thông tin công việc hiện tại
                      final updatedTask = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTaskScreen(taskData: task),
                        ),
                      );
                      // Nếu người dùng đã chỉnh sửa, cập nhật công việc
                      if (updatedTask != null) {
                        _updateTask(index, updatedTask);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteTask(index);
                    },
                  ),
                ],
              ),
              onTap: () {
                // Điều hướng đến màn hình chi tiết khi nhấn vào công việc
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailScreen(taskData: task),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (newTask != null) {
            _addTask(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
