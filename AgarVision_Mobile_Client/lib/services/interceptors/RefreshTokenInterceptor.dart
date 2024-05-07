import 'package:agar_vision/main.dart';
import 'package:agar_vision/services/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;

// Import the ContentTypeInterceptor and JWTInterceptor classes
import 'ContentTypeInterceptor.dart';
import 'JWTInterceptor.dart';

class RefreshTokenInterceptor implements InterceptorContract {
  // Override the interceptRequest method to return the request as is
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    return request;
  }

  // Override the interceptResponse method to handle 401 and 403 status codes
  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    if (response.statusCode == 401 || response.statusCode == 403) {
      bool doesRefreshed =
          await AuthenticationService.instance().refreshAccessToken();
      if (!doesRefreshed) {
        routeToLoginAndDisplayErro();
      } else {
        return ensureResponse(await _retry(response));
      }
    }
    return ensureResponse(response);
  }

  // A helper method to convert a BaseResponse to a Response object
  Future<Response> ensureResponse(BaseResponse response) {
    if (response is http.StreamedResponse) {
      return Future(() => http.Response.fromStream(response));
    } else {
      return Future(() => response as Response);
    }
  }

  // A helper method to retry the request with the new access token
  Future<BaseResponse> _retry(BaseResponse response) async {
    var baseRequest = response.request;
    if (baseRequest != null) {
      return InterceptedClient.build(
        interceptors: [JWTInterceptor(), ContentTypeInterceptor()],
      ).send(baseRequest);
    }
    return Future(() => response);
  }

  // Override the shouldInterceptRequest method to never intercept the request
  @override
  Future<bool> shouldInterceptRequest() {
    return Future(() => false);
  }

  // A method to redirect the user to the login screen and display an error message
  void routeToLoginAndDisplayErro() {
    AuthenticationService.routeToLogin();
    const snackBar = SnackBar(
      content: Text('Your session has expired, please login again.'),
      duration: Duration(seconds: 5),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(AppSettings.navigatorState.currentContext!)
        .showSnackBar(snackBar);
  }

  // Override the shouldInterceptResponse method to always intercept the response
  @override
  Future<bool> shouldInterceptResponse() {
    return Future(() => true);
  }
}
