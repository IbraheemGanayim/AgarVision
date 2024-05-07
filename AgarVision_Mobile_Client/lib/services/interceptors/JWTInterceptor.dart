import 'package:agar_vision/main.dart'; // The main function of the app
import 'package:agar_vision/services/Authentication.dart'; // A class for user authentication
import 'package:http_interceptor/http_interceptor.dart'; // A package for HTTP interception

class JWTInterceptor implements InterceptorContract {
  // An override of the interceptRequest method to add the JWT token to the Authorization header of the request
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String? token = AuthenticationService
        .token; // Get the JWT token from the AuthenticationService
    String? tok = AppSettings.token; // Get the JWT token from the AppSettings
    if (token != null) {
      request.headers['Authorization'] =
          "Bearer $token"; // Add the JWT token to the Authorization header of the request
    } else if (tok != null) {
      request.headers['Authorization'] =
          "Bearer $tok"; // Add the JWT token to the Authorization header of the request
    } else {
      AuthenticationService
          .routeToLogin(); // Redirect the user to the login screen if there is no JWT token
    }
    return request;
  }

  // An override of the interceptResponse method to return the response as is
  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) {
    return Future(() => response);
  }

  // An override of the shouldInterceptRequest method to always intercept the request
  @override
  Future<bool> shouldInterceptRequest() {
    return Future(() => true);
  }

  // An override of the shouldInterceptResponse method to never intercept the response
  @override
  Future<bool> shouldInterceptResponse() {
    return Future(() => false);
  }
}
