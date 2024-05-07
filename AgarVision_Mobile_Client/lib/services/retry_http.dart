import 'dart:io';

import 'package:http/http.dart';
import 'package:http_interceptor/models/retry_policy.dart';

class MyRetryPolicy extends RetryPolicy {
  final url = 'https://www.example.com/';

  @override
  // how many times you want to retry your request.
  int maxRetryAttempts = 3;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    //You can check if you got your response after certain timeout,
    //or if you want to retry your request based on the status code,
    //usually this is used for refreshing your expired token but you can check for what ever you want

    //your should write a condition here so it won't execute this code on every request
    //for example if(response == null)

    // a very basic solution is that you can check
    // for internet connection, for example
    try {
      return true;
    } on SocketException catch (_) {
      return false;
    } on ClientException catch(_){
      return true;
    }
  }
}