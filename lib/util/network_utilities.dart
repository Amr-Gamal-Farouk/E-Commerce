import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ec_task/data_provider/model/error_model.dart';
import 'package:ec_task/data_provider/model/response_model.dart';
import 'package:ec_task/util/values/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final ErrorModel kConnectionTimeOutError = ErrorModel(
  errorMessage: '',
  errorCode: HttpStatus.requestTimeout,
);

class NetworkUtilities {
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static Future<ResponseModel<dynamic>> handleGetRequest(
      {String? methodURL,
      Map<String, String>? requestHeaders,
      Function? parserFunction}) async {
    ResponseModel getResponse;

    try {
      var serverResponse = await http
          .get(Uri.parse(methodURL!), headers: requestHeaders)
          .timeout(Duration(seconds: 30), onTimeout: () {
        throw SocketException;
      });
      if (serverResponse.statusCode == 200) {
        getResponse = ResponseModel(
          isSuccess: true,
          errorModel: null,
          responseData: parserFunction!(json.decode(serverResponse.body)),
        );
      } else {
        getResponse = handleError(serverResponse);
      }
    } on SocketException {
      getResponse = ResponseModel(
        isSuccess: false,
        errorModel: kConnectionTimeOutError,
        responseData: null,
      );
    } catch (exception) {
      debugPrint("Exception in get => $exception");

      if (exception == SocketException) {
        getResponse = ResponseModel(
          isSuccess: false,
          errorModel: kConnectionTimeOutError,
          responseData: null,
        );
      } else {
        getResponse = ResponseModel(
          isSuccess: false,
          errorModel: ErrorModel(
            errorMessage: '',
            errorCode: HttpStatus.serviceUnavailable,
          ),
          responseData: null,
        );
      }
    }
    networkLogger(
        url: methodURL,
        body: '',
        headers: requestHeaders,
        response: getResponse);
    return getResponse;
  }

  static Future<ResponseModel> handlePostRequest(
      {bool acceptJson = false,
      String? methodURL,
      Map<String, String>? requestHeaders,
      Map<String, dynamic>? requestBody,
      Function? parserFunction}) async {
    ResponseModel postResponse;

    try {
      http.Response serverResponse = await http
          .post(Uri.parse(methodURL!),
              headers: requestHeaders,
              body: acceptJson ? json.encode(requestBody) : requestBody)
          .timeout(Duration(seconds: 30), onTimeout: () {
        throw SocketException;
      });
      if (serverResponse.statusCode == 200) {
        postResponse = ResponseModel(
          isSuccess: true,
          errorModel: null,
          responseData: parserFunction!(json.decode(serverResponse.body)),
        );
      } else {
        postResponse = handleError(serverResponse);
      }
    } on SocketException {
      postResponse = ResponseModel(
        isSuccess: false,
        errorModel: kConnectionTimeOutError,
        responseData: null,
      );
    } catch (exception) {
      debugPrint("Exception in post => $exception");
      if (exception == SocketException) {
        postResponse = ResponseModel(
          isSuccess: false,
          errorModel: kConnectionTimeOutError,
          responseData: null,
        );
      } else {
        postResponse = ResponseModel(
          isSuccess: false,
          errorModel: ErrorModel(
            errorMessage: '',
            errorCode: HttpStatus.serviceUnavailable,
          ),
          responseData: null,
        );
      }
    }
    networkLogger(
        url: methodURL,
        body: requestBody,
        headers: requestHeaders,
        response: postResponse);
    return postResponse;
  }

  static Future<ResponseModel> handleUploadFiles(
      {String? methodURL,
      Map<String, String>? requestHeaders,
      Function? parserFunction,
      List<String>? files,
      Map<String, dynamic>? requestBody,
      bool? isBodyJson}) async {
    ResponseModel uploadResponse;
    try {
      List<MultipartFile> imageFiles = List.empty(growable: true);
      for (int i = 0; i < files!.length; i++)
        imageFiles.add(await MultipartFile.fromFile(files[i]));
      Map<String, dynamic> requestMap = requestBody!;
      requestMap.putIfAbsent("images", () => imageFiles);
      FormData formData = FormData.fromMap(requestMap);
      Response serverResponse = await Dio().post(methodURL!,
          data: formData,
          options: Options(
            headers: requestHeaders,
          ));

      if (serverResponse.statusCode == 200) {
        uploadResponse = ResponseModel(
          isSuccess: true,
          errorModel: null,
          responseData: parserFunction!(serverResponse.data),
        );
      } else {
        String serverError = "";
        try {
          serverError = json.decode(serverResponse.data)['error'] ??
              json.decode(serverResponse.data)['message'];
        } catch (exception) {
          serverError = serverResponse.data;
        }
        uploadResponse = ResponseModel(
          isSuccess: false,
          errorModel: ErrorModel(
            errorMessage: serverError,
            errorCode: serverResponse.statusCode,
          ),
          responseData: null,
        );

        if (uploadResponse.errorModel!.errorCode == 404) {
          uploadResponse = ResponseModel(
            isSuccess: false,
            errorModel: ErrorModel(
              errorMessage: Strings.kServerUnreachable,
              errorCode: serverResponse.statusCode,
            ),
            responseData: null,
          );
        }
      }
    } on SocketException {
      uploadResponse = ResponseModel(
        isSuccess: false,
        errorModel: kConnectionTimeOutError,
        responseData: null,
      );
    } catch (exception) {
      uploadResponse = ResponseModel(
        isSuccess: false,
        errorModel: ErrorModel(
          errorMessage: '',
          errorCode: HttpStatus.serviceUnavailable,
        ),
        responseData: null,
      );
    }
    return uploadResponse;
  }

  static Map<String, String> getHeaders({Map<String, String>? customHeaders}) {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    };
    if (customHeaders != null) {
      for (int i = 0; i < customHeaders.length; i++) {
        headers.putIfAbsent(customHeaders.keys.toList()[i],
            () => customHeaders[customHeaders.keys.toList()[i]]!);
      }
    }
    return headers;
  }

  static void networkLogger({url, headers, body, ResponseModel? response}) {
    debugPrint('---------------------------------------------------');
    debugPrint('URL => $url');
    debugPrint('headers => $headers');
    debugPrint('Body => $body');
    debugPrint('Response => ${response.toString()}');
    debugPrint('---------------------------------------------------');
  }

  static ResponseModel handleError(http.Response serverResponse) {
    debugPrint("Server Response not ok => ");
    debugPrint(serverResponse.body);
    debugPrint("----------------------------------");

    ResponseModel responseModel;
    if (serverResponse.statusCode == 404 || serverResponse.statusCode == 500) {
      responseModel = ResponseModel(
        isSuccess: false,
        errorModel: ErrorModel(
          errorMessage: Strings.kServerUnreachable,
          errorCode: serverResponse.statusCode,
        ),
        responseData: null,
      );
    } else if (serverResponse.statusCode == 422) {
      List<String> errors = List.empty(growable: true);
      try {
        (json.decode(serverResponse.body)['errors'] as Map<String, dynamic>)
            .forEach((key, value) {
          if (value is List<String>)
            errors.addAll(value);
          else if (value is List<dynamic>) {
            for (int i = 0; i < value.length; i++)
              errors.add(value[i].toString());
          } else if (value is String) errors.add(value);
        });
      } catch (exception) {
        debugPrint("Exception => $exception");
      }
      responseModel = ResponseModel(
        isSuccess: false,
        errorModel: ErrorModel(
          errorMessage:
              errors.length > 0 ? errors.join(',') : Strings.kServerUnreachable,
          errorCode: serverResponse.statusCode,
        ),
        responseData: null,
      );
    } else {
      debugPrint("Server Response not OK => ${serverResponse.body}");
      String serverError = "";
      try {
        serverError = json.decode(serverResponse.body)['error'] ??
            json.decode(serverResponse.body)['message'];
      } catch (exception) {
        serverError = serverResponse.body;
      }
      responseModel = ResponseModel(
        isSuccess: false,
        errorModel: ErrorModel(
          errorMessage: serverError,
          errorCode: serverResponse.statusCode,
        ),
        responseData: null,
      );
    }
    return responseModel;
  }
}
