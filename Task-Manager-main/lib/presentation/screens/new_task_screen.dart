import 'package:flutter/material.dart';
import 'package:task_manager/data/models/count_by_status_warpper.dart';
import 'package:task_manager/data/models/task_list_wrapper.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/screens/add_new_task.dart';
import 'package:task_manager/presentation/widgets/background_widget.dart';
import 'package:task_manager/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager/presentation/widgets/snack_bar_message.dart';
import 'package:task_manager/presentation/widgets/task_card.dart';
import 'package:task_manager/presentation/widgets/task_counter_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool getAllTaskCountByStatusInprogress = false;
  CountByStatusWarpper? _countByStatusWarpper = CountByStatusWarpper();
  TaskListWrapper _newTaskListWrapper = TaskListWrapper();
  bool newTaskListInProgress = false;
  bool deleaTaskListInProgress = false;
  bool updateTaskSatusListInProgress = false;

  @override
  void initState() {
    super.initState();
    getDataFormApi();
  }

  void getDataFormApi() {
    _getAllTaskCountByStatus();
    _getAllNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Column(
          children: [
            Visibility(
              visible: getAllTaskCountByStatusInprogress == false,
              replacement: const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
              child: taskCounterSection,
            ),
            Expanded(
              child: Visibility(
                visible: newTaskListInProgress == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: RefreshIndicator(
                  onRefresh: () async => getDataFormApi(),
                  child: Visibility(
                    visible: _newTaskListWrapper.taskList?.isNotEmpty ?? false,
                    replacement: const EmptyListWidget(),
                    child: ListView.builder(
                      itemCount: _newTaskListWrapper.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskItem: _newTaskListWrapper.taskList![index],
                          refreshList: () {
                            getDataFormApi();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Todo: refress full apps ,add new any thing.
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
          if(result != null &&result ==true){
            getDataFormApi();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget get taskCounterSection {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _countByStatusWarpper!.listOfTaskbyStatusData?.length ?? 0,
        itemBuilder: (context, index) {
          return NewTaskCard(
            amount:
                _countByStatusWarpper?.listOfTaskbyStatusData![index].sum ?? 0,
            title:
                _countByStatusWarpper?.listOfTaskbyStatusData![index].sId ?? '',
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

  Future<void> _getAllTaskCountByStatus() async {
    getAllTaskCountByStatusInprogress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.taskcountBystatus);

    if (response.isSuccess) {
      _countByStatusWarpper =
          CountByStatusWarpper.fromJson(response.responsBody);
      getAllTaskCountByStatusInprogress = false;
      setState(() {});
    } else {
      getAllTaskCountByStatusInprogress = false;
      setState(() {});
      if (mounted) {
        snackbarMessage(context,
            response.errorMessage ?? 'Get task count by status has been faild');
      }
    }
  }

  Future<void> _getAllNewTaskList() async {
    newTaskListInProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.newTaskList);
    if (response.isSuccess) {
      _newTaskListWrapper = TaskListWrapper.fromJson(response.responsBody);
      newTaskListInProgress = false;
      setState(() {});
    } else {
      newTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        snackbarMessage(context,
            response.errorMessage ?? 'Get new task List has been faild');
      }
    }
  }
}
