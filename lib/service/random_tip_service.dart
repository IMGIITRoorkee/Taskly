import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:taskly/models/tip.dart';

class RandomTipService {
  static const int timeoutSeconds = 15;
  static const String endpoint = "https://zenquotes.io/api/random/";

  Future<Result<Tip, Exception>> getRandomTip() async {
    try {
      final resp = await http.get(
        Uri.parse(endpoint),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ).timeout(const Duration(seconds: timeoutSeconds));

      if (resp.statusCode == 429) {
        return Error(Exception("Rate Limit Exceeded!"));
      }
      List<dynamic> list = jsonDecode(resp.body);
      return Success(Tip.fromMap(list[0]));
    } on TimeoutException {
      return Error(Exception("Tip of the day could not be fetched!"));
    } catch (e) {
      return Error(Exception(e.toString()));
    }
  }
}
