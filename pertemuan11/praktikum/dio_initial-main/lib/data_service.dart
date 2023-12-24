import 'package:dio/dio.dart';

import 'user.dart';

class DataService {
  final Dio dio = Dio();
  final String _baseUrl = 'https://reqres.in/api';

  Future getUsers() async {
    try {
      final response = await dio.get('$_baseUrl/users');

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Future postUser(String name, String job) async {
  Future<UserCreate?> postUser(UserCreate user) async {
    try {
      final response =
          await dio.post('$_baseUrl/api/users', data: user.toJson());

      if (response.statusCode == 201) {
        final userCreate = UserCreate.fromJson(response.data);
        return userCreate;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Future putUser(String idUser, String name, String job) async {
  Future putUser(UserCreate user) async {
    try {
      final response =
          await dio.put('$_baseUrl/api/users', data: user.toJson());

      if (response.statusCode == 200) {
        final updatedUser = UserCreate.fromJson(response.data);

        return updatedUser;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deleteUser(String idUser) async {
    try {
      final response = await dio.delete('$_baseUrl/api/users/$idUser');

      if (response.statusCode == 204) {
        return 'terdelete';
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Iterable<User>?> getUserModel() async {
    try {
      final response = await dio.get('$_baseUrl/users');

      if (response.statusCode == 200) {
        final users = (response.data['data'] as List)
            .map((user) => User.fromJson(user))
            .toList();
        return users;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
