import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/server_constants.dart';
import '../../../core/errors/failure.dart';
import '../../../core/models/user_model.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) =>
    AuthRemoteRepository();

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverURL}/auth/signup"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "name": name,
            "email": email,
            "password": password,
          },
        ),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode != 201) {
        return Left(AppFailure(
          decodedResponse["detail"],
          response.statusCode,
        ));
      }
      return Right(UserModel.fromMap(decodedResponse));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverURL}/auth/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(
          decodedResponse["detail"],
          response.statusCode,
        ));
      }
      return Right(UserModel.fromMap(decodedResponse['user']).copyWith(
        token: decodedResponse['token'],
      ));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverURL}/auth/"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(
          decodedResponse["detail"],
          response.statusCode,
        ));
      }
      return Right(UserModel.fromMap(decodedResponse).copyWith(
        token: token,
      ));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
