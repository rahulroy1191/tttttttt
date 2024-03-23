import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_manager/data/models/task_item.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskItem,
    required this.refreshList,
  });

  final TaskItem taskItem;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool updateTaskSatusListInProgress = false;
  bool deletaTaskListInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskItem.title ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.taskItem.description ?? ""),
            Text("date: ${widget.taskItem.createdDate}"),
            Row(
              children: [
                Chip(
                  label: Text(widget.taskItem.status ?? ""),
                ),
                const Spacer(),
                Visibility(
                  visible: updateTaskSatusListInProgress == false,
                  replacement: CircularProgressIndicator(),
                  child: IconButton(
                    onPressed: () {
                      _showUpdateStatusDiloge(widget.taskItem.sId!);
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                Visibility(
                  visible: deletaTaskListInProgress == false,
                  replacement: const CircularProgressIndicator(),
                  child: IconButton(
                    onPressed: () {
                      _deleateTaskbyId(widget.taskItem.sId!);
                    },
                    icon: const Icon(
                      Icons.delete_outline_outlined,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showUpdateStatusDiloge(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("New"),
                trailing: _isCurrentStatus("New") ? Icon(Icons.check) : null,
                onTap: () {
                  if (_isCurrentStatus("New")) {
                    return;
                  }
                  _updateTaskById(id, "New");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Completed"),
                trailing:
                    _isCurrentStatus("Completed") ? Icon(Icons.check) : null,
                onTap: () {
                  if (_isCurrentStatus("Completed")) {
                    return;
                  }
                  _updateTaskById(id, "Completed");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Progress"),
                trailing:
                    _isCurrentStatus("Progress") ? Icon(Icons.check) : null,
                onTap: () {
                  if (_isCurrentStatus("Progress")) {
                    return;
                  }
                  _updateTaskById(id, "Progress");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Cancled"),
                trailing:
                    _isCurrentStatus("Cancled") ? Icon(Icons.check) : null,
                onTap: () {
                  if (_isCurrentStatus("Cancled")) {
                    return;
                  }
                  _updateTaskById(id, "Cancled");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isCurrentStatus(String status) {
    return widget.taskItem.status! == status;
  }

  Future<void> _updateTaskById(String id, String status) async {
    updateTaskSatusListInProgress = true;
    setState(() {});
    final response =
        await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    updateTaskSatusListInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      updateTaskSatusListInProgress = false;
      widget.refreshList();
    } else {
      if (mounted) {
        snackbarMessage(
            context, response.errorMessage ?? 'Update Task Status been faild');
      }
    }
  }

  Future<void> _deleateTaskbyId(String id) async {
    deletaTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.deleateTaskList(id));
    deletaTaskListInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      if (mounted) {
        snackbarMessage(
            context, response.errorMessage ?? 'Delete Task has been faild');
      }
    }
  }
}
