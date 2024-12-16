import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:taskly/models/tip.dart';

class RandomTipService {
  static const int timeoutSeconds = 15;
  static const String endpoint = "https://api.quotable.io/quotes/random";

  Future<Result<Tip, Exception>> getRandomTip() async {
    try {
      final resp = await http
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: timeoutSeconds));

      if (resp.statusCode == 429) {
        return Error(Exception("Rate Limit Exceeded!"));
      }

      List<dynamic> list = jsonDecode(resp.body);
      return Success(Tip.fromJson(list[0]));
    } catch (e) {
      return Error(Exception(e.toString()));
    }
  }
}
