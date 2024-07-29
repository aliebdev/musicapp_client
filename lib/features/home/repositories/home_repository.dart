import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/server_constants.dart';
import '../../../core/errors/failure.dart';
import '../model/song_model.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) => HomeRepository();

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${ServerConstants.serverURL}/song/upload"),
      );

      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath(
              'thumbnail', selectedThumbnail.path),
        ])
        ..fields.addAll({
          "song_name": songName,
          "artist": artist,
          "hex_code": hexCode,
        })
        ..headers.addAll(
          {"x-auth-token": token},
        );

      final res = await request.send();

      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final response = await http
          .get(Uri.parse("${ServerConstants.serverURL}/song/list"), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });

      var decodedResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        decodedResponse = decodedResponse as Map<String, dynamic>;
        return Left(AppFailure(decodedResponse["details"]));
      }

      return Right(
        (decodedResponse as List).map((e) => SongModel.fromMap(e)).toList(),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverURL}/song/favorite"),
        body: jsonEncode({"song_id": songId}),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      var decodedResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        decodedResponse = decodedResponse as Map<String, dynamic>;
        return Left(AppFailure(decodedResponse["details"]));
      }

      return Right(decodedResponse['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getFavSongs({
    required String token,
  }) async {
    try {
      final response = await http.get(
          Uri.parse("${ServerConstants.serverURL}/song/list/favorites"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          });

      var decodedResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        decodedResponse = decodedResponse as Map<String, dynamic>;
        return Left(AppFailure(decodedResponse["details"]));
      }

      return Right(
        (decodedResponse as List)
            .map((json) => SongModel.fromMap(json['song']))
            .toList(),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
