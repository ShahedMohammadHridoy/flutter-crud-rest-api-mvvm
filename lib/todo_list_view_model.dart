import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'todo.dart';

class TodoListViewModel {
  final StreamController<List<Todo>> _todoListController =
      StreamController<List<Todo>>.broadcast();
  List<Todo> _todoList = [];

  Stream<List<Todo>> get todoListStream => _todoListController.stream;

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      _todoList = body.map((dynamic item) => Todo.fromJson(item)).toList();
      _todoListController.add(_todoList);
    } else {
      throw Exception('Failed to load todo list');
    }
  }

  void addData(String title, bool completed) {
    final newTodo = Todo(
      id: _todoList.length + 1,
      title: title,
      completed: completed,
    );
    _todoList.add(newTodo);
    _todoListController.add(_todoList);
  }

  void updateData(Todo todo, String title, bool completed) {
    final index = _todoList.indexOf(todo);
    final updatedTodo = Todo(
      id: todo.id,
      title: title,
      completed: completed,
    );
    _todoList[index] = updatedTodo;
    _todoListController.add(_todoList);
  }

  void deleteData(Todo todo) {
    _todoList.remove(todo);
    _todoListController.add(_todoList);
  }

  void dispose() {
    _todoListController.close();
  }
}
