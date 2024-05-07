import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart'; // A package for HTTP interception

class ContentTypeInterceptor implements InterceptorContract {
  // An override of the interceptRequest method to set the content type of the request to application/json
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers[HttpHeaders.contentTypeHeader] = "application/json";
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
