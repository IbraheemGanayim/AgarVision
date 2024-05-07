import 'package:http_interceptor/http_interceptor.dart'; // A package for HTTP interception

class KeepAliveInterceptor implements InterceptorContract {
  // An override of the interceptRequest method to add the Keep-Alive header to the request
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers["Keep-Alive"] =
        "timeout=5, max=1000"; // Add the Keep-Alive header to the request with a timeout of 5 seconds and a maximum of 1000 requests
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
