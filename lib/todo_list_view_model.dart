import 'dart:async';
import 'dart:convert';
import 'package:flutter_rest_api_crud_mvvm/urls.dart';
import 'package:http/http.dart' as http;
import 'todo.dart';

class TodoListViewModel {
  final StreamController<List<Todo>> _todoListController =
      StreamController<List<Todo>>.broadcast();
  List<Todo> _todoList = [];

  Stream<List<Todo>> get todoListStream => _todoListController.stream;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      _todoList = body.map((dynamic item) => Todo.fromJson(item)).toList();
      _todoListController.add(_todoList);
    } else {
      throw Exception('Failed to load todo list');
    }
  }

  Future<void> addData(String title, bool completed) async {
    final newTodo = Todo(
      id: -1,
      title: title,
      completed: completed,
    );
    final response = await http.post(Uri.parse('$baseUrl/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newTodo.toJson()));

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      newTodo.id = jsonResponse['id'];
      _todoList.add(newTodo);
      _todoListController.add(_todoList);
    } else {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> updateData(Todo todo, String title, bool completed) async {
    final index = _todoList.indexOf(todo);
    final updatedTodo = Todo(
      id: todo.id,
      title: title,
      completed: completed,
    );
    final response = await http.put(Uri.parse('$baseUrl/${todo.id}/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedTodo.toJson()));

    if (response.statusCode == 200) {
      _todoList[index] = updatedTodo;
      _todoListController.add(_todoList);
    } else {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteData(Todo todo) async {
    final response = await http.delete(Uri.parse('$baseUrl/${todo.id}/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    if (response.statusCode == 204) {
      _todoList.remove(todo);
      _todoListController.add(_todoList);
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  void dispose() {
    _todoListController.close();
  }
}
