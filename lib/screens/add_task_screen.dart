import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class AddTaskScreen extends StatefulWidget {
  final Map<String, String>? taskData; // Dữ liệu công việc (nếu là sửa)

  const AddTaskScreen({Key? key, this.taskData}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _taskController;
  late TextEditingController _locationController;
  late TextEditingController _hostController;
  late TextEditingController _noteController;
  String? _selectedDay;
  DateTime? _startDate;  // Ngày bắt đầu
  DateTime? _endDate;    // Ngày kết thúc
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6'];

  @override
  void initState() {
    super.initState();

    // Nếu có dữ liệu công việc được truyền vào (trường hợp sửa), điền dữ liệu vào các trường
    _taskController = TextEditingController(text: widget.taskData?['task'] ?? '');
    _locationController = TextEditingController(text: widget.taskData?['location'] ?? '');
    _hostController = TextEditingController(text: widget.taskData?['host'] ?? '');
    _noteController = TextEditingController(text: widget.taskData?['note'] ?? '');
    //_selectedDay = widget.taskData?['day'];
    
    // Ngày bắt đầu và ngày kết thúc
    _startDate = widget.taskData?['startDate'] != null
        ? DateFormat('dd/MM/yyyy').parse(widget.taskData!['startDate']!)
        : null;
    _endDate = widget.taskData?['endDate'] != null
        ? DateFormat('dd/MM/yyyy').parse(widget.taskData!['endDate']!)
        : null;
    
    // Thời gian bắt đầu và kết thúc
    _startTime = widget.taskData?['startTime'] != null
        ? _parseTime(widget.taskData!['startTime']!)
        : null;
    _endTime = widget.taskData?['endTime'] != null
        ? _parseTime(widget.taskData!['endTime']!)
        : null;
  }

  // Hàm hỗ trợ để chuyển chuỗi thời gian từ định dạng 12 giờ (AM/PM) sang TimeOfDay
  TimeOfDay _parseTime(String timeString) {
    final time = timeString.split(" ")[0];  // Tách "AM"/"PM"
    final period = timeString.split(" ")[1];  // Lấy "AM" hoặc "PM"
  
    List<String> parts = time.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
  
    if (period == "PM" && hour != 12) {
      hour += 12;  // Chuyển giờ PM thành định dạng 24 giờ
    } else if (period == "AM" && hour == 12) {
      hour = 0;  // Xử lý trường hợp 12 giờ sáng (midnight)
    }
  
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  // Hàm chọn thời gian (cho bắt đầu và kết thúc)
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _locationController.dispose();
    _hostController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm/Sửa Công việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Thứ Ngày'),
                value: _selectedDay,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDay = newValue;
                  });
                },
                items: _days.map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(labelText: 'Nội dung Công việc'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Địa điểm'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _hostController,
                decoration: const InputDecoration(labelText: 'Chủ trì'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context, true), // Chọn ngày bắt đầu
                child: Text(
                  _startDate == null
                      ? 'Chọn ngày bắt đầu'
                      : 'Ngày bắt đầu: ${DateFormat('dd/MM/yyyy').format(_startDate!)}',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context, false), // Chọn ngày kết thúc
                child: Text(
                  _endDate == null
                      ? 'Chọn ngày kết thúc'
                      : 'Ngày kết thúc: ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectTime(context, true),
                child: Text(
                  _startTime == null
                      ? 'Chọn thời gian bắt đầu'
                      : 'Bắt đầu: ${_startTime!.format(context)}',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectTime(context, false),
                child: Text(
                  _endTime == null
                      ? 'Chọn thời gian kết thúc'
                      : 'Kết thúc: ${_endTime!.format(context)}',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedDay != null &&
                      _startDate != null &&
                      _endDate != null &&
                      _startTime != null &&
                      _endTime != null &&
                      _taskController.text.isNotEmpty &&
                      _locationController.text.isNotEmpty &&
                      _hostController.text.isNotEmpty) {
                    // Lưu hoặc sửa công việc
                    final newTask = {
                      'day': _selectedDay!,
                      'startDate': DateFormat('dd/MM/yyyy').format(_startDate!),
                      'endDate': DateFormat('dd/MM/yyyy').format(_endDate!),
                      'task': _taskController.text,
                      'startTime': _startTime!.format(context),
                      'endTime': _endTime!.format(context),
                      'location': _locationController.text,
                      'host': _hostController.text,
                      'note': _noteController.text,
                    };
                    Navigator.pop(context, newTask); // Trả dữ liệu về màn hình trước
                  } else {
                    // Hiển thị cảnh báo nếu thiếu thông tin
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thiếu thông tin'),
                        content: const Text('Vui lòng điền đầy đủ các trường.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Đóng'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Lưu công việc'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
