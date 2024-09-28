import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, String> taskData;

  const TaskDetailScreen({Key? key, required this.taskData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết Công việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nội dung: ${taskData['task']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Thứ ngày: ${taskData['day']}, ${taskData['date']}'),
            const SizedBox(height: 10),
            Text('Thời gian: ${taskData['startTime']} - ${taskData['endTime']}'),
            const SizedBox(height: 10),
            Text('Địa điểm: ${taskData['location']}'),
            const SizedBox(height: 10),
            Text('Chủ trì: ${taskData['host']}'),
            const SizedBox(height: 10),
            Text('Ghi chú: ${taskData['note']}'),
          ],
        ),
      ),
    );
  }
}
