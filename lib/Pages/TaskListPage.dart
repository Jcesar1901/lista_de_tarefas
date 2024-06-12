import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/task.dart';
import 'package:lista_de_tarefas/repositories/taskrepository.dart';

import '../Widgets/TaskListItem.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController tasksController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();

  List<Task> tasks = [];
  Task? deletedTask;
  int? deletedTaskPosition;
  String? error;

  @override
  void initState(){
    super.initState();

    taskRepository.getTaskList().then((value){
      setState(() {
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tasksController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                        labelText: 'Tarefas',
                        hintText: 'Insira uma nova tarefa',
                        errorText: error,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String text = tasksController.text;
                      if(text.isEmpty){
                        setState(() {
                          error = 'Por favor, insira uma tarefa!';
                        });
                        return;
                      }

                      setState(() {
                        Task newTask = Task(title: text, date: DateTime.now());
                        tasks.add(newTask);
                        error = null;
                      });
                      tasksController.clear();
                      taskRepository.saveTaskList(tasks);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan[100],
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 32,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Task task in tasks)
                      TaskListItem(
                        task: task,
                        onDelete: deletar,
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child:
                        Text("Voce possui ${tasks.length} tarefas pendentes"),
                  ),
                  ElevatedButton(
                    onPressed: deleteAllDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan[100],
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text("Limpar tudo"),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  void deletar(Task task) {
    deletedTask = task;
    deletedTaskPosition = tasks.indexOf(task);
    setState(() {
      tasks.remove(task);
    });
    taskRepository.saveTaskList(tasks);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
            child: Text(
          "Tarefa removida!",
          style: TextStyle(color: Colors.blue[900], fontSize: 17),
        )),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: 'Desfazer',
            textColor: Colors.blueAccent,
            onPressed: () {
              setState(() {
                tasks.insert(deletedTaskPosition!, deletedTask!);
              });
              taskRepository.saveTaskList(tasks);
            }),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void deleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Você tem certeza?'),
        content: const Text('Deseja remover todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              deleteAll();
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: const Text('Sim'),
          )
        ],
      ),
    );
  }
  void deleteAll(){
    setState(() {
      tasks.clear();
    });
    taskRepository.saveTaskList(tasks);
  }
}
