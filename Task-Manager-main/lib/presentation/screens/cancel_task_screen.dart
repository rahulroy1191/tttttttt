import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_list_wrapper.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/widgets/background_widget.dart';
import 'package:task_manager/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';
import 'package:task_manager/presentation/widgets/task_card.dart';
import 'package:task_manager/presentation/widgets/task_counter_card.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  bool _getCancelTaskListInProgress = false;
  TaskListWrapper _cancelTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    super.initState();
    _getAllCancelTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: ()async{
                  _getAllCancelTaskList();
                },
                child: Visibility(
                  visible: _getCancelTaskListInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: Visibility(
                    visible:
                    _cancelTaskListWrapper.taskList?.isNotEmpty ?? false,
                    replacement: const EmptyListWidget(),
                    child: ListView.builder(
                      itemCount: _cancelTaskListWrapper.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskItem: _cancelTaskListWrapper.taskList![index],
                          refreshList: () {
                            _getAllCancelTaskList();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget get taskCounterSection {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return const NewTaskCard(
            amount: 12,
            title: "New",
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 8,
          );
        },
      ),
    );
  }

  Future<void> _getAllCancelTaskList() async {
    _getCancelTaskListInProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.cancelTaskList);
    if (response.isSuccess) {
      _cancelTaskListWrapper =
          TaskListWrapper.fromJson(response.responsBody);
      _getCancelTaskListInProgress = false;
      setState(() {});
    } else {
      _getCancelTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        snackbarMessage(context,
            response.errorMessage ?? 'Get Cancled task List has been faild');
      }
    }
  }
}


